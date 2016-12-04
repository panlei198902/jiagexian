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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryKeyFinished:)
                                                 name:BLQueryKeyFinishedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryKeyFailed:)
                                                 name:BLQueryKeyFailedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryHotelFinished:)
                                                 name:BLQueryHotelFinishedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryHotelFailed:)
                                                 name:BLQueryHotelFailedNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
} 

//接受BL查询关键字成功通知
- (void)queryKeyFinished:(NSNotification*)not {
    
    self.keyDict = not.object;
    if (self.keyDict != nil) {
        [self performSegueWithIdentifier:@"SelectKey" sender:nil];
    } else {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"没有数据" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:cancelButton];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

//接受BL查询关键字失败通知
- (void)queryKeyFailed:(NSNotification*)not {
    
    NSError *error = [not object];
    NSString *errorStr = [error localizedDescription];
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"出错信息" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelButton];
    [self presentViewController:alertView animated:YES completion:nil];
}

//接受BL查询Hotel信息成功通知
- (void)queryHotelFinished:(NSNotification*)not {
    self.hotelList = not.object;
    if (self.hotelList == nil || [self.hotelList count] == 0) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"出错信息" message:@"没有数据" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:cancelButton];
        [self presentViewController:alertView animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:@"queryHotel" sender:nil];
    }
}

//接受BL查询Hotel信息s失败通知
- (void)queryHotelFailed:(NSNotification*)not {
    NSError *error = not.object;
    NSString *errorStr = [error localizedDescription];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"出错信息" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelButton];
    [self presentViewController:alertView animated:YES completion:nil];
    
}
#pragma mark -实现citiesViewControllerDelegate协议
//关闭城市选择view方法
- (void)closeCitiesView:(NSDictionary*)info {
    self.cityInfo = info;
    [self dismissViewControllerAnimated:NO completion:nil];
    NSString* cityname = info[@"name"];
    [self.selectCity setTitle:cityname forState:UIControlStateNormal];
}

//关闭关键字选择view方法
- (void)closeKeysView:(NSString *)selectKey {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.selectKey setTitle:selectKey forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CitySegue"]) {
        UINavigationController* nvgViewController = (UINavigationController*)[segue destinationViewController];
        CitiesViewController* citiesViewController = (CitiesViewController*)nvgViewController.topViewController ;
        citiesViewController.cityDelegate = self;
        
    } else if ([[segue identifier] isEqualToString:@"SelectKey"]) {
        UINavigationController *nvgViewController = (UINavigationController*)[segue destinationViewController];
        KeysViewController *keyViewController = (KeysViewController*)[nvgViewController topViewController];
        keyViewController.delegate = self;
        keyViewController.keyDict = self.keyDict;
    } else if ([[segue identifier] isEqualToString:@"queryHotel"]) {
        UINavigationController *nvgViewController = (UINavigationController*)[segue destinationViewController];
        HotelListTableViewController *hotelListViewController = (HotelListTableViewController*)[nvgViewController topViewController];
        hotelListViewController.list = self.hotelList;
        hotelListViewController.queryKey = self.hoteQueryKey;
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
        [[HotelBL sharedHoteolBL] selectKey:self.selectCity.titleLabel.text];
        return NO;
    } else if  ([identifier isEqualToString:@"queryHotel"]) {
        NSString *errorMsg ;
        
        if ([self.selectCity.titleLabel.text isEqualToString:@"选择城市"]) {
            errorMsg = @"请选择城市";
        } else if ([self.selectKey.titleLabel.text isEqualToString:@"选择关键字"]) {
            errorMsg = @"请选择关键字";
        } else if ([self.checkInTime.titleLabel.text isEqualToString:@"选择日期"]) {
            errorMsg = @"请选择入住日期";
        } else if ([self.checkOutTime.titleLabel.text isEqualToString:@"选择日期"]) {
            errorMsg = @"请选择退房日期";
        }
        
        if (errorMsg) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示信息" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertView addAction:cancelButton];
            [self presentViewController:alertView animated:YES completion:nil];
            return NO;
        }
    self.hoteQueryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         [self.cityInfo objectForKey:@"Plcityid"], @"Plcityid",
                         @"1",@"currentPage",
                         self.selectKey.titleLabel.text, @"key",
                         self.priceRange.titleLabel.text, @"Price",
                         self.checkInTime.titleLabel.text, @"Checkin",
                         self.checkOutTime.titleLabel.text, @"Checkout",
                         nil];
    
    return NO;
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
