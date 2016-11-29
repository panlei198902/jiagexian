//
//  HotelBL.h
//  BusinessLayer
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelBL : NSObject

+ (HotelBL*)sharedHoteolBL;
- (void)selectKey:(NSString*)city;
- (void)queryHotel:(NSDictionary*)keyInfo;

@end
