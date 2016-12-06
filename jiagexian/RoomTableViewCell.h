//
//  RoomTableViewCell.h
//  jiagexian
//
//  Created by Derexpan on 2016/12/6.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *frontprice;
@property (weak, nonatomic) IBOutlet UILabel *breakfast;
@property (weak, nonatomic) IBOutlet UILabel *broadband;
@property (weak, nonatomic) IBOutlet UILabel *payway;

@end
