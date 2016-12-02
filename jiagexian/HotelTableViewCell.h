//
//  HotelTableViewCell.h
//  jiagexian
//
//  Created by Derexpan on 2016/12/2.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *image;
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
