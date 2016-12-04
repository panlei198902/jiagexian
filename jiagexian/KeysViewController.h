//
//  KeysViewController.h
//  jiagexian
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeysViewContollerDelegate

- (void)closeKeysView:(NSString *)selectKey;

@end
@interface KeysViewController : UITableViewController

//关键字类型列表
@property(nonatomic, strong) NSArray* keyTypeList;
//关键字字典
@property(nonatomic, strong) NSDictionary *keyDict;

@property (nonatomic,weak) id<KeysViewContollerDelegate> delegate;

- (IBAction)cancel:(id)sender;

@end
