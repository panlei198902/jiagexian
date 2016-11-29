//
//  BLHelp.m
//  BusinessLogicLayer
//
//  Created by tonyguan on 13-1-25.
//  Copyright (c) 2013年 eorient. All rights reserved.
//

#import "BLHelp.h"

@implementation BLHelp

//预处理价格
+(NSString *)prePrice:(NSString *)price
{
    if (price == nil || [price integerValue] == 0) {
        return @"无房";
    }
    return [[NSString alloc] initWithFormat:@"￥%@/天起", price];
}

//预处理级别
+(NSString *)preGrade:(NSString *)grade
{
    return [[NSString alloc] initWithFormat:@"%@星级", grade];
}

//预处理早餐
+(NSString *)preBreakfast:(NSString *)breakfast
{
    //room breakfast: 含几份早餐，不可为空,-1 <= breakfast <= 4。-1表示含早（数量不定），0表示无早，其他数值表示含N早
    int bf = [breakfast intValue];
    if (bf == -1) {
        return @"含早餐";
    } else if (bf == 0) {
        return @"无早餐";
    } else {
        return [[NSString alloc] initWithFormat:@"含%i早餐", bf];
    }
}

//预处理床型
+(NSString *)preBed:(NSString *)bed
{
    //床型，不可为空, 0大床 / 1双床 / 2大/双床 / 3三床 / 4一单一双 / 5单人床 / 6上下铺 / 7通铺 / 8榻榻米 / 9水床 / 10圆床 / 11拼床
    int intBed = [bed intValue];
    if (intBed == 0) {
        return @"大床";
    } else if (intBed == 1) {
        return @"双床";
    }
    else if (intBed == 2) {
        return @"大/双床 ";
    }
    else if (intBed == 3) {
        return @"三床";
    }
    else if (intBed == 4) {
        return @"一单一双";
    }
    else if (intBed == 5) {
        return @"单人床";
    }
    else if (intBed == 6) {
        return @"上下铺";
    }
    else if (intBed == 7) {
        return @"通铺";
    }
    else if (intBed == 8) {
        return @"榻榻米";
    }
    else if (intBed == 9) {
        return @"水床";
    }else if (intBed == 10) {
        return @"圆床";
    } else  {
        return @"拼床";
    }
}
//预处理宽带
+(NSString *)preBroadband:(NSString *)broadband
{
    //room broadband: 宽带，不可为空，0无 / 1有 / 2免费 / 3收费 / 4部分收费 / 5部分有且收费 / 6部分有且免费 / 7部分有且部分收费
    int intbroadband = [broadband intValue];
    if (intbroadband == 0) {
        return @"无宽带";
    } else if (intbroadband == 1) {
        return @"有宽带";
    }
    else if (intbroadband == 2) {
        return @"宽带免费";
    }
    else if (intbroadband == 3) {
        return @"宽带收费";
    }
    else if (intbroadband == 4) {
        return @"宽带部分收费";
    }
    else if (intbroadband == 5) {
        return @"宽带部分收费";
    }
    else if (intbroadband == 6) {
        return @"部分部分免费";
    }
    else if (intbroadband == 7) {
        return @"宽带部分收费";
    }
    else  {
        return @"宽带部分收费";
    }
}


//预处理支付类型
+(NSString *)prePaymode:(NSString *)prepay
{
    //room prepay:支付类型，不可为空， 0 需预付 / 1 前台现付
    int intprepay = [prepay intValue];
    if (intprepay == 0) {
        return @"需预付";
    }  else  {
        return @"前台现付";
    }
}

@end
