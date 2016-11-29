//
//  BLHelp.h
//  BusinessLogicLayer
//
//  Created by tonyguan on 13-1-25.
//  Copyright (c) 2013年 eorient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLHelp : NSObject

//预处理价格
+(NSString *)prePrice:(NSString *)price;
//预处理级别
+(NSString *)preGrade:(NSString *)grade;
//预处理早餐
+(NSString *)preBreakfast:(NSString *)breakfast;
//预处理床型
+(NSString *)preBed:(NSString *)bed;
//预处理支付类型
+(NSString *)prePaymode:(NSString *)prepay;
//预处理宽带
+(NSString *)preBroadband:(NSString *)broadband;

@end
