//
//  HotelBL.m
//  BusinessLayer
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import "HotelBL.h"
#import "MKNetworkKit.h"
#import "TBXML.h"
#import "BLHelp.h"

#define HOST_NAME @"jiagexian.com"
#define KEY_QUERY_URL @"/ajaxplcheck.mobile?method=mobilesuggest&v=1&city=%@"
#define HOTEL_QUERY_URL @"/hotelListForMobile.mobile?newSearch=1"
@implementation HotelBL

static HotelBL *instance = nil;
+ (HotelBL*)sharedHoteolBL {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void)selectKey:(NSString*)city
{
    NSString *strURL = [[NSString alloc] initWithFormat:KEY_QUERY_URL, city];
    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"strURL: %@",strURL);
    MKNetworkEngine *engine = [[MKNetworkEngine alloc]
                               initWithHostName:HOST_NAME customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:strURL];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        //NSLog(@"responseData : %@", [operation responseString]);
        NSData *data  = [operation responseData];
        NSDictionary *resDict = [NSJSONSerialization
                                 JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName: BLQueryKeyFinishedNotification object: resDict];
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork请求错误 : %@", [err localizedDescription]);
        [[NSNotificationCenter defaultCenter] postNotificationName: BLQueryKeyFailedNotification
                                                            object: err];
    }];
    
    [engine enqueueOperation:op];
    
}

//查询酒店
-(void)queryHotel:(NSDictionary*)keyInfo
{
    NSString *strURL = [[NSString alloc] initWithFormat:HOTEL_QUERY_URL];
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[keyInfo objectForKey:@"Plcityid"] forKey:@"f_plcityid"];
    [param setValue:[keyInfo objectForKey:@"key"] forKey:@"q"];
    [param setValue:[keyInfo objectForKey:@"currentPage"] forKey:@"currentPage"];
    
    NSString *price = [keyInfo objectForKey:@"Price"];
    NSLog(@"price: %@",price);
    if ([price isEqualToString:@"价格不限"]) {
        [param setValue:@"￥0" forKey:@"priceSlider_minSliderDisplay"];
        [param setValue:@"￥3000+" forKey:@"priceSlider_maxSliderDisplay"];
    } else {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"--> "];
        NSArray *tempArray = [price componentsSeparatedByCharactersInSet:set];
        [param setValue:tempArray[0] forKey:@"priceSlider_minSliderDisplay"];
        [param setValue:tempArray[3] forKey:@"priceSlider_maxSliderDisplay"];
    }
    
    [param setValue:[keyInfo objectForKey:@"Checkin"] forKey:@"fromDate"];
    [param setValue:[keyInfo objectForKey:@"Checkout"] forKey:@"toDate"];
    
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_NAME customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:strURL params:param httpMethod:@"POST"];
    NSLog(@"request: %@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        //NSLog(@"responseData : %@", [operation responseString]);
        NSData *data  = [operation responseData];
        NSLog(@"data: %@",data);
        NSMutableArray *list = [[NSMutableArray alloc] init];
        NSError *error = nil;
        
        TBXML* tbxml = [[TBXML alloc] initWithXMLData:data error:&error];
        
        if (!error) {
            TBXMLElement * root = tbxml.rootXMLElement;
            
            if (root) {
                TBXMLElement * hotel_listElement = [TBXML childElementNamed:@"hotel_list" parentElement:root];
                if (hotel_listElement) {
                    TBXMLElement * hotelElement = [TBXML childElementNamed:@"hotel" parentElement:hotel_listElement];
                    
                    while (hotelElement) {
                        
                        NSMutableDictionary *dict = [NSMutableDictionary new];
                        //取id
                        TBXMLElement *idElement = [TBXML childElementNamed:@"id" parentElement:hotelElement];
                        if (idElement) {
                            [dict setValue:[TBXML textForElement:idElement] forKey:@"id"];
                        }
                        //取name
                        TBXMLElement *nameElement = [TBXML childElementNamed:@"name" parentElement:hotelElement];
                        if (nameElement) {
                            [dict setValue:[TBXML textForElement:nameElement] forKey:@"name"];
                        }
                        //取city
                        TBXMLElement *cityElement = [TBXML childElementNamed:@"city" parentElement:hotelElement];
                        if (cityElement) {
                            [dict setValue:[TBXML textForElement:cityElement] forKey:@"city"];
                        }
                        //取address
                        TBXMLElement *addressElement = [TBXML childElementNamed:@"address" parentElement:hotelElement];
                        if (addressElement) {
                            [dict setValue:[TBXML textForElement:addressElement] forKey:@"address"];
                        }
                        //取phone
                        TBXMLElement *phoneElement = [TBXML childElementNamed:@"phone" parentElement:hotelElement];
                        if (phoneElement) {
                            [dict setValue:[TBXML textForElement:phoneElement] forKey:@"phone"];
                        }
                        //取lowprice
                        TBXMLElement *lowpriceElement = [TBXML childElementNamed:@"lowprice" parentElement:hotelElement];
                        if (lowpriceElement) {
                            NSString *price = [BLHelp prePrice:[TBXML textForElement:lowpriceElement]];
                            [dict setValue:price forKey:@"lowprice"];
                        }
                        //取grade
                        TBXMLElement *gradeElement = [TBXML childElementNamed:@"grade" parentElement:hotelElement];
                        if (gradeElement) {
                            NSString *grade = [BLHelp preGrade:[TBXML textForElement:gradeElement]];
                            [dict setValue:grade forKey:@"grade"];
                        }
                        //取description
                        TBXMLElement *descriptionElement = [TBXML childElementNamed:@"description" parentElement:hotelElement];
                        if (descriptionElement) {
                            [dict setValue:[TBXML textForElement:descriptionElement] forKey:@"description"];
                        }
                        //取img
                        TBXMLElement *imgElement = [TBXML childElementNamed:@"img" parentElement:hotelElement];
                        if (imgElement) {
                            NSString *src = [TBXML valueOfAttributeNamed:@"src" forElement:imgElement];
                            [dict setValue:src forKey:@"img"];
                        }
                        
                        hotelElement = [TBXML nextSiblingNamed:@"hotel" searchFromElement:hotelElement];
                        
                        [list addObject:dict];
                        NSLog(@"%@",list);
                    }
                    
                }
            }
        }
        
        NSLog(@"解析完成...");
        [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryHotelFinishedNotification object:list];
        
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork请求错误 : %@", [err localizedDescription]);
        [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryHotelFailedNotification object:err];
    }];
    
    [engine enqueueOperation:op];
    
}
@end
