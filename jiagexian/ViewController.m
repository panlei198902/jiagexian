//
//  ViewController.m
//  jiagexian
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import "ViewController.h"
#import "HotelBL.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkinDateViewController = [[MyDatePickerViewController alloc] init];
    self.checkinDateViewController.delegate = self;
    
    self.checkoutDateViewController = [[MyDatePickerViewController alloc] init];
    self.checkoutDateViewController.delegate = self;
    
    self.priceSelect = [[MyPickerViewController alloc] init];
    self.priceSelect.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -实现citiesViewControllerDelegate协议
- (void)closeCitiesView:(NSDictionary*)info {
    self.cityInfo = info;
    [self dismissViewControllerAnimated:NO completion:nil];
    NSString* cityname = info[@"name"];
    self.selectCity.titleLabel.text = cityname;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CitySegue"]) {
        UINavigationController* nvgViewController = (UINavigationController*)[segue destinationViewController];
        CitiesViewController* citiesViewController = (CitiesViewController*)nvgViewController.topViewController ;
        citiesViewController.cityDelegate = self;
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"SelectKey"] && [self.selectCity.titleLabel.text isEqualToString:@"选择城市"]) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请先选择城市" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:cancelButton];
        [self presentViewController:alertView animated:YES completion:nil];
        
        return NO;
    } else if ([identifier isEqualToString:@"SelectKey"]) {
        [[HotelBL sharedHoteolBL] selectKey:self.selectKey.titleLabel.text];
        return NO;
    } else if ([identifier isEqualToString:@"queryHotel"]) {
        NSString *errorMsg;
        
        if ([self.selectCity.titleLabel.text isEqualToString:@"选择城市"]) {
            errorMsg = @"请选择城市";
        } else if ([self.selectKey.titleLabel.text isEqualToString:@"选择关键字"]) {
            errorMsg = @"请选择关键字";
        } else if ([self.checkInTime.titleLabel.text isEqualToString:@"入住时间"]) {
            errorMsg = @"请选择入住日期";
        } else if ([self.checkOutTime.titleLabel.text isEqualToString:@"退房时间"]) {
            errorMsg = @"请选择退房时间";
        }
        
        if (errorMsg) {
            UIAlertController *noSelectAnItem = [UIAlertController alertControllerWithTitle:@"提示信息" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [noSelectAnItem addAction:cancelButton];
            [self presentViewController:noSelectAnItem animated:YES completion:nil];
            
            return NO;
        }
        
    }
    return YES;
}


#pragma mark -实现MyPickerViewController和MyDataPickerView协议
- (void)myPickDateViewControllerDidFinish:(MyDatePickerViewController *)controller andSelectedDate:(NSDate*)selected {
    NSDateFormatter* date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [date setLocale:locale];
    
    NSString* strDate = [date stringFromDate:selected];
    
    if (self.checkinDateViewController == controller) {
        [self.checkInTime setTitle:strDate forState:UIControlStateNormal];
    } else if (self.checkoutDateViewController == controller) {
        [self.checkOutTime setTitle:strDate forState:UIControlStateNormal];
    }

}

- (void)myPickViewClose:(NSString*)selected {
    [self.priceRange setTitle:selected forState:UIControlStateNormal];
}

//按钮点击事件
- (IBAction)selectPrice:(id)sender {
    [self.priceSelect showInView:self.view];
}

- (IBAction)selectCheckin:(id)sender {
    [self.checkinDateViewController showInView:self.view];

}
- (IBAction)selectCheckout:(id)sender {
    [self.checkoutDateViewController showInView:self.view];

}




@end
