//
//  HotelListTableViewController.h
//  jiagexian
//
//  Created by Derexpan on 2016/11/30.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelTableViewCell.h"
#import "HotelBL.h"
#import "RoomBL.h"
#import "RoomsTableViewController.h"
@interface HotelListTableViewController : UITableViewController {
    int currentPage; //当前页数
}



//查询条件
@property(nonatomic,strong) NSMutableDictionary* queryKey;

//查询结果
@property(nonatomic,strong) NSMutableArray *list;
//加载视图单元格
@property (weak, nonatomic) IBOutlet UIView *loadViewCell;

//查询房间条件
@property(nonatomic,strong) NSMutableDictionary* queryRoomKey;

//查询房间结果
@property(nonatomic,strong) NSMutableArray *roomList;

@end
