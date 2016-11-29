//
//  HotelBL.m
//  BusinessLayer
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import "HotelBL.h"
#import "MKNetworkKit.h"
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLRequestCompleted" object:resDict];
    }];

    
    //发出请求
    [host startRequest:request];
    
}
- (void)queryHotel:(NSDictionary*)keyInfo{
    
}

@end
