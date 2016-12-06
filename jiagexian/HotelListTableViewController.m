//
//  HotelListTableViewController.m
//  jiagexian
//
//  Created by Derexpan on 2016/11/30.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import "HotelListTableViewController.h"

@interface HotelListTableViewController ()

@end

@implementation HotelListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"酒店列表";
    currentPage = 1;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundSearch"]];
    [backgroundView setFrame:self.tableView.frame];
    self.tableView.backgroundView = backgroundView;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryHotelFinished:)
                                                 name:BLQueryHotelFinishedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryHotelFailed:)
                                                 name:BLQueryHotelFailedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryRoomFinished:)
                                                 name:BLQueryRoomFinishedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryRoomFailed:)
                                                 name:BLQueryRoomFailedNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//接受BL查询关键字成功通知
- (void)queryHotelFinished:(NSNotification*)not {
    
    NSArray *resList = not.object;
    if ([resList count] < 20) {
        self.loadViewCell.hidden = YES;
    } else {
        self.loadViewCell.hidden = NO;
    }
    
    if (currentPage == 1) {
        self.list = [NSMutableArray new];
    }
    
    [self.list addObjectsFromArray:resList];
    [self.tableView reloadData];
    
}

//接受BL查询关键字失败通知
- (void)queryHotelFailed:(NSNotification*)not {
    
    NSError *error = [not object];
    NSString *errorStr = [error localizedDescription];
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"出错信息" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelButton];
    [self presentViewController:alertView animated:YES completion:nil];
}

//接受BL查询Room信息成功通知
- (void)queryRoomFinished:(NSNotification*)not {
    self.roomList = not.object;
    if (self.roomList == nil || [self.roomList count] == 0) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"出错信息" message:@"没有房间数据" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:cancelButton];
        [self presentViewController:alertView animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:@"showRoomDetail" sender:nil];
    }
}

//接受BL查询Room信息失败通知
- (void)queryRoomFailed:(NSNotification*)not {
    NSError *error = not.object;
    NSString *errorStr = [error localizedDescription];
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"出错信息" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelButton];
    [self presentViewController:alertView animated:YES completion:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelTableViewCell *cell = (HotelTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dict = [self.list objectAtIndex:indexPath.row];
    
    cell.hotelName.text = [dict valueForKey:@"name"];
    cell.tel.text = [dict valueForKey:@"phone"];
    cell.address.text = [dict valueForKey:@"address"];
    cell.price.text = [dict valueForKey:@"lowprice"];
    cell.grade.text = [dict valueForKey:@"grade"];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"myIndex" ofType:@"html"];
    NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSRange range = [html rangeOfString:@"####"];
    if (range.location != NSNotFound) {
        NSString *src = [dict valueForKey:@"img"];
        [html replaceCharactersInRange:range withString:src];
    }
    [cell.image loadHTMLString:html baseURL:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.list count] == indexPath.row + 1 && self.loadViewCell.hidden == NO) {
        NSLog(@"load data....");
        currentPage ++;
        
        NSString *str = [[NSString alloc] initWithFormat:@"%i",currentPage];
        [self.queryKey setObject:str forKey:@"currentPage"];
        
        [[HotelBL sharedHoteolBL] queryHotel:self.queryKey];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showRoomDetail"]) {
        NSMutableDictionary *qkey = [[NSMutableDictionary alloc] init];
        [qkey setObject:[self.queryKey objectForKey:@"Checkin"] forKey:@"Checkin"];
        [qkey setObject:[self.queryKey objectForKey:@"Checkout"] forKey:@"Checkout"];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *dict = [self.list objectAtIndex:indexPath.row];
        [qkey setObject:[dict objectForKey:@"id"] forKey:@"hotelId"];
        
        self.queryRoomKey = qkey;
        [[RoomBL sharedInstance] queryRoom:self.queryRoomKey];
        

    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showRoomDetail"]) {
        RoomsTableViewController *roomList = (RoomsTableViewController*)[segue destinationViewController];
        roomList.roomList = self.roomList;
        
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

*/

@end
