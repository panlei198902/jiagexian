//
//  RoomBL.h
//  BusinessLayer
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomBL : NSObject

+ (instancetype)sharedInstance;

//查询酒店查询
- (void)queryRoom:(NSDictionary*)keyInfo;

@end
