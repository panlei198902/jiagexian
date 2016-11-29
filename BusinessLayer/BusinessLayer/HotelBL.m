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
#define HOTEL_QUERY_URL @"/hotelListForMobile?newSearch=1"
@implementation HotelBL

static HotelBL *instance = nil;
+ (HotelBL*)sharedHoteolBL {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)selectKey:(NSString*)city{
    NSString* strURL = [[NSString alloc] initWithFormat:KEY_QUERY_URL, city];
    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    MKNetworkHost* host = [[MKNetworkHost alloc] initWithHostName:HOST_NAME];
    MKNetworkRequest *request = [host requestWithPath:strURL];
    
    [request addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        NSLog(@"request Data : %@",completedRequest.responseAsString);
        NSData* data = [completedRequest responseData];
        NSDictionary* resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryKeyFinishedNotification object:resDict];
        
    }];
    
    
    //发出请求
    [host startRequest:request];
    
}
- (void)queryHotel:(NSDictionary*)keyInfo{
    NSString* strURL = [[NSString alloc] initWithFormat:HOTEL_QUERY_URL];
    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    MKNetworkHost* host = [[MKNetworkHost alloc] initWithHostName:HOST_NAME];
    //准备参数
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //f_plcityid 城市ID，从表示层plcityid获得
    [params setValue:[keyInfo objectForKey:@"Plcityid"] forKey:@"f_plcityid"];
    //q 查询关键字，从表示层key获得
    [params setValue:[keyInfo objectForKey:@"key"] forKey:@"q"];
    //currentPage 查询数据的第X页，用于翻页，从表示层currentPage键获得。
    [params setValue:[keyInfo objectForKey:@"currentPage"] forKey:@"currentPage"];
    
    //pricesSlider_minSliderDisplay 最低价格，从表示层price键取得
    //priceSlider_maxSliderDisplay 最高价格，从表示层price键取得
    NSString* price = [keyInfo objectForKey:@"Price"];
    if ([price isEqualToString:@"价格不限"]) {
        [params setValue:[keyInfo objectForKey:@"￥0"] forKey:@"pricesSlider_minSliderDisplay"];
        [params setValue:[keyInfo objectForKey:@"￥3000+"] forKey:@"pricesSlider_maxSliderDisplay"];
    } else {
        NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@"-> "];
        NSArray* tempArray = [price componentsSeparatedByCharactersInSet:set];
        [params setValue:tempArray[0] forKey:@"pricesSlider_minSliderDisplay"];
        [params setValue:tempArray[4] forKey:@"pricesSlider_maxSliderDisplay"];
    }
    //fromDate 入住日期，从表示层checkin键获得
    [params setValue:[keyInfo objectForKey:@"checkin"] forKey:@"fromDate"];
    //toDate 退房日期，从表示层checkout键获得
    [params setValue:[keyInfo objectForKey:@"checkout"] forKey:@"toDate"];


    
    MKNetworkRequest *request = [host requestWithPath:strURL params:params httpMethod:@"POST"];
    
    [request addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        NSLog(@"request Data : %@",completedRequest.responseAsString);
        NSData* data = [completedRequest responseData];
        
        //解析数据
        NSMutableArray* list = [[NSMutableArray alloc] init];
        NSError* error = nil;
        
        TBXML *tbxml = [[TBXML alloc] initWithXMLData:data error:&error];
        
        if (error == nil) {  //成功创建tbxml对象
            TBXMLElement *root = tbxml.rootXMLElement;
            
            if (root) {
                TBXMLElement *hotelListElement = [TBXML childElementNamed:@"hotel_list" parentElement:root];
                if (hotelListElement) {
                    TBXMLElement *hotelElement = [TBXML childElementNamed:@"hotel" parentElement:hotelListElement];
                    while (hotelElement) {
                        id dict = [[NSMutableDictionary alloc] init];
                        //取出id
                        TBXMLElement* idElment = [TBXML childElementNamed:@"id" parentElement:hotelElement];
                        if (idElment) {
                            NSString* idText = [TBXML textForElement:idElment];
                            [dict setValue:idText forKey:@"id"];
                        }
                        //取出name
                        TBXMLElement* nameElment = [TBXML childElementNamed:@"name" parentElement:hotelElement];
                        if (nameElment) {
                            NSString* nameText = [TBXML textForElement:nameElment];
                            [dict setValue:nameText forKey:@"name"];
                        }
                        
                        //取出city
                        TBXMLElement* cityElment = [TBXML childElementNamed:@"city" parentElement:hotelElement];
                        if (cityElment) {
                            NSString* cityText = [TBXML textForElement:cityElment];
                            [dict setValue:cityText forKey:@"city"];
                        }
                        
                        //取出address
                        TBXMLElement* addressElment = [TBXML childElementNamed:@"address" parentElement:hotelElement];
                        if (addressElment) {
                            NSString* addressText = [TBXML textForElement:addressElment];
                            [dict setValue:addressText forKey:@"address"];
                        }
                        
                        //取出phone
                        TBXMLElement* phoneElment = [TBXML childElementNamed:@"phone" parentElement:hotelElement];
                        if (phoneElment) {
                            NSString* phoneText = [TBXML textForElement:phoneElment];
                            [dict setValue:phoneText forKey:@"phone"];
                        }
                        
                        //取出lowprice
                        TBXMLElement* lowpriceElment = [TBXML childElementNamed:@"lowprice" parentElement:hotelElement];
                        if (lowpriceElment) {
                            NSString* lowpriceText = [BLHelp prePrice:[TBXML textForElement:lowpriceElment]];
                            [dict setValue:lowpriceText forKey:@"lowprice"];
                        }
                        
                        //取出grade
                        TBXMLElement* gradeElment = [TBXML childElementNamed:@"grade" parentElement:hotelElement];
                        if (gradeElment) {
                            NSString* gradeText = [BLHelp preGrade:[TBXML textForElement:gradeElment]];
                            [dict setValue:gradeText forKey:@"grade"];
                        }
                        
                        //取出img
                        TBXMLElement* imgElment = [TBXML childElementNamed:@"img" parentElement:hotelElement];
                        if (imgElment) {
                            NSString* srcText = [TBXML valueOfAttributeNamed:@"scr" forElement:imgElment];
                            [dict setValue:srcText forKey:@"img"];
                        }
                        
                        [list addObject:dict];
                        
                        hotelElement = [TBXML nextSiblingNamed:@"hotel" searchFromElement:hotelElement];  //继续查找同一级其他名字为Hotel的元素
                    }
                }
            }
        }
        
        NSLog(@"解析完成...");
        [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryHotelFinishedNotification object:list];   //postName 需要定义
    }];
    //发出请求
    [host startRequest:request];
}

@end
