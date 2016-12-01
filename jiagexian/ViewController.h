//
//  ViewController.h
//  jiagexian
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitiesViewController.h"
#import "MyDatePickerViewController.h"
#import "MyPickerViewController.h"

@interface ViewController : UIViewController <CitiesViewControllerDelegate, MyDatePickerViewControllerDelegate, MyPickerViewControllerDelegate>

- (IBAction)selectPrice:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *priceRange;
@property (weak, nonatomic) IBOutlet UIButton *selectDate;
@property (weak, nonatomic) IBOutlet UIButton *checkInTime;
@property (weak, nonatomic) IBOutlet UIButton *checkOutTime;


@property (nonatomic, strong) NSDictionary* cityInfo;

@property (nonatomic, strong) MyDatePickerViewController* checkoutDateViewController;

@property (nonatomic, strong) MyDatePickerViewController* checkinDateViewController;

@property (nonatomic, strong) MyPickerViewController* priceSelect;

- (void)myPickDateViewControllerDidFinish:(MyDatePickerViewController *)controller andSelectedDate:(NSDate*)selected;

- (void)myPickViewClose:(NSString*)selected;

@end

