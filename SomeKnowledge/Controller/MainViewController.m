//
//  MainViewController.m
//  SomeKnowledge
//
//  Created by HuangJin on 2018/6/13.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "MainViewController.h"
#import "MainListCell.h"
#import "NSObject+Test.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface MainViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *titleDataSource;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *backgroundColor = [UIColor whiteColor];
//    backgroundColor = [backgroundColor colorWithAlphaComponent:0.8]
    self.view.backgroundColor = backgroundColor;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"清单";
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
    _dataSource = [@[
                     @"CalendarViewController",
                     @"WaveViewController",
                     @"KeyBoradInputViewViewController",
                     @"StringViewController",
                     @"LocateNotifiyAndSyncCalendarEventViewController",
                     @"NaviToPushViewController",
                     @"RuntimeViewController",
                     @"TimerViewController",
                     @"GCDViewController",
                     @"NSOperationViewController",
                     @"NSThreadViewController",
                     @"FMDBViewController",
                     @"BlockViewController"
                     ] mutableCopy];
    _titleDataSource = [@[
                          @"日历",
                          @"波浪动画",
                          @"键盘",
                          @"字符串",
                          @"本地推送和日历同步",
                          @"跳转到别的TabbarItem",
                          @"Runtime",
                          @"定时器",
                          @"GCD",
                          @"NSOperation",
                          @"NSThread",
                          @"FMDB",
                          @"Block"
                          ] mutableCopy];
    
//    [self.tableView registerClass:[MainListCell class] forCellReuseIdentifier:cellIdentifier];
    
//    __weak NSString *test = @"test";
//    NSLog(@"===%@",test);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _titleDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _titleDataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class class = NSClassFromString(_dataSource[indexPath.row]);
    UIViewController *viewController = [[class alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
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
