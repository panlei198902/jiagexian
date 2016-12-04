//
//  KeysViewController.m
//  jiagexian
//
//  Created by derex pan on 2016/11/27.
//  Copyright © 2016年 derex pan. All rights reserved.
//

#import "KeysViewController.h"

@interface KeysViewController ()

@end

@implementation KeysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyTypeList = [self.keyDict allKeys];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundSearch"]];
    [backgroundView setFrame:self.tableView.frame];
    self.tableView.backgroundView = backgroundView;
    
    UINavigationBar* navigationBar = self.navigationController.navigationBar;
    navigationBar.barTintColor = [UIColor colorWithRed:48.0/255 green:89.0/255 blue:181.0/255 alpha:1.0];
    navigationBar.tintColor = [UIColor colorWithRed:112.0/255 green:180.0/255 blue:255.0/255 alpha:1.0];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    
    //设置表视图标题栏颜色
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor colorWithRed:112.0/255 green:180.0/255 blue:255.0/255 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.keyDict count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *keyName = [self.keyTypeList objectAtIndex:section];
    NSArray *keyList = [self.keyDict objectForKey:keyName];
    return [keyList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *keyName = [self.keyTypeList objectAtIndex:indexPath.section];
    NSArray *keyList = [self.keyDict objectForKey:keyName];
    
    cell.textLabel.text = [[keyList objectAtIndex:indexPath.row] objectForKey:@"key"];
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *keyTypeName = [self.keyTypeList objectAtIndex:section];
    return keyTypeName;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.keyDict allKeys];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *keyName = [self.keyTypeList objectAtIndex:indexPath.section];
    NSArray *keyList = [self.keyDict objectForKey:keyName];
    [self.delegate closeKeysView:[[keyList objectAtIndex:indexPath.row] objectForKey:@"key"]];
    
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
