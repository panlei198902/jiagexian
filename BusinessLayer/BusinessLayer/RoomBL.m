//
//  RoomBL.m
//  BusinessLayer
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import "RoomBL.h"

#import "TBXML.h"
#import "MKNetworkKit.h"
#import "BLHelp.h"

#define HOST_NAME @"jiagexian.com"
#define ROOM_QUERY_URL @"/priceline/hotelroom/hotelroomcache.mobile"
//@"/priceline/hotelroom/hotelroomqunar.mobile"

@implementation RoomBL

static RoomBL *instance = nil;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)queryRoom:(NSDictionary*)keyInfo{
    NSString *strURL = [[NSString alloc] initWithFormat:ROOM_QUERY_URL];
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"strURL = %@",strURL);
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    //测试
    //    [param setValue:@"100194" forKey:@"supplierid"];
    //    [param setValue:@"2015-05-10" forKey:@"fromDate"];
    //    [param setValue:@"2015-05-12" forKey:@"toDate"];
    
    [param setValue:[keyInfo objectForKey:@"hotelId"] forKey:@"supplierid"];
    [param setValue:[keyInfo objectForKey:@"Checkin"] forKey:@"fromDate"];
    [param setValue:[keyInfo objectForKey:@"Checkout"] forKey:@"toDate"];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_NAME customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:strURL params:param httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        NSLog(@"responseData : %@", [operation responseString]);
        NSData *data  = [operation responseData];
        
        NSMutableArray *list = [NSMutableArray new];
        
        NSError *error = nil;
        
        TBXML* tbxml = [[TBXML alloc] initWithXMLData:data error:&error];
        
        if (!error) {
            TBXMLElement * root = tbxml.rootXMLElement;
            
            if (root) {
                TBXMLElement * roomsElement = [TBXML childElementNamed:@"rooms" parentElement:root];
                
                if (roomsElement) {
                    TBXMLElement * roomElement = [TBXML childElementNamed:@"room" parentElement:roomsElement];
                    
                    while (roomElement) {
                        
                        NSMutableDictionary *dict = [NSMutableDictionary new];
                        //取name
                        NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:roomElement];
                        [dict setValue:name forKey:@"name"];
                        //取breakfast
                        NSString *breakfast = [TBXML valueOfAttributeNamed:@"breakfast" forElement:roomElement];
                        [dict setValue:[BLHelp preBreakfast:breakfast] forKey:@"breakfast"];
                        
                        //取bed
                        NSString *bed = [TBXML valueOfAttributeNamed:@"bed" forElement:roomElement];
                        [dict setValue:[BLHelp preBed:bed] forKey:@"bed"];
                        
                        //取broadband
                        NSString *broadband = [TBXML valueOfAttributeNamed:@"broadband" forElement:roomElement];
                        [dict setValue:[BLHelp preBroadband:broadband] forKey:@"broadband"];
                        
                        //取paymode
                        NSString *paymode = [TBXML valueOfAttributeNamed:@"paymode" forElement:roomElement];
                        [dict setValue:[BLHelp prePaymode:paymode]  forKey:@"paymode"];
                        
                        //取frontprice
                        NSString *frontprice = [TBXML valueOfAttributeNamed:@"frontprice" forElement:roomElement];
                        [dict setValue:[BLHelp prePrice:frontprice] forKey:@"frontprice"];
                        
                        
                        roomElement = [TBXML nextSiblingNamed:@"room" searchFromElement:roomElement];
                        
                        [list addObject:dict];
                    }
                }
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryRoomFinishedNotification object:list];
        NSLog(@"解析完成...");
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork请求错误 : %@", [err localizedDescription]);
        [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryRoomFailedNotification object:err];
    }];
    
    [engine enqueueOperation:op];

}

@end
