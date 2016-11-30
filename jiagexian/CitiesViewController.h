//
//  CitiesViewController.h
//  jiagexian
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CitiesViewControllerDelegate <NSObject>

- (void)closeCitiesView:(NSDictionary*)info;

@end

@interface CitiesViewController : UITableViewController

//城市信息列表
@property (nonatomic, strong)NSArray* cities;

//委托对象属性
@property (nonatomic, weak) id<CitiesViewControllerDelegate> delegate;

@end
