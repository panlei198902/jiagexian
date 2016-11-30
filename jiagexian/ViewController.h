//
//  ViewController.h
//  jiagexian
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitiesViewController.h"

@interface ViewController : UIViewController <CitiesViewControllerDelegate>

@property (nonatomic, strong) NSDictionary* cityInfo;

@end

