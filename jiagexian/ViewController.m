//
//  ViewController.m
//  jiagexian
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -实现citiesViewControllerDelegate协议
- (void)closeCitiesView:(NSDictionary*)info {
    self.cityInfo = info;
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
