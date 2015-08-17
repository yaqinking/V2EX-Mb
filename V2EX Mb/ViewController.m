//
//  ViewController.m
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import "ViewController.h"
#import "UserStore.h"
#import "V2EXAPI.h"
#import "User.h"

#import "RepliesTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[UserStore sharedStore] allUsers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"User Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    User *user = [[[UserStore sharedStore] allUsers] objectAtIndex:indexPath.row ];
    cell.textLabel.text = user.name;
    cell.textLabel.font = [UIFont systemFontOfSize:22.0f];
//    cell.detailTextLabel.text = user.replyPageURLString;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        User *user = [[[UserStore sharedStore] allUsers] objectAtIndex:indexPath.row];
        [[UserStore sharedStore] removeUser:user];
       [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[UserStore sharedStore] saveChanges];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[RepliesTableViewController class]]) {
        RepliesTableViewController *rtvc = [segue destinationViewController];
        NSIndexPath *idx = [self.tableView indexPathForSelectedRow];
        rtvc.user = [[[UserStore sharedStore] allUsers] objectAtIndex:idx.row];
    }
}

#pragma mark - UserDataSource

- (void)loadUserData {
    [self.tableView reloadData];
}
- (IBAction)addUser:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加用户"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"完成"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          UITextField *tagTextField =  alert.textFields[0];
                                                          if (![tagTextField.text isEqualToString:@""]) {
                                                              NSString *addUserName = tagTextField.text;
                                                              NSString *addUserReplyPageURLString = [NSString stringWithFormat:V2EX_REPLY_PAGE_WITH_ID_OFFSET,addUserName,1];
//                                                              NSLog(@"%@",addUserName);
                                                              
                                                              User *newUser = [[UserStore sharedStore] createUser];
                                                              newUser.name = addUserName;
                                                              newUser.replyPageURLString = addUserReplyPageURLString;
                                                              
                                                              NSInteger lastRow = [[[UserStore sharedStore] allUsers] indexOfObject:newUser];
                                                              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                                                  
                                                                  [[UserStore sharedStore] saveChanges];
                                                              });
                                                          }
                                                      }];
    
    addAction.enabled = NO;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             //                                                             NSLog(@"Cancel");
                                                         }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入要添加的用户 ID";
        
        NSNotificationCenter *notiCen = [NSNotificationCenter defaultCenter];
        [notiCen addObserverForName:UITextFieldTextDidChangeNotification
                             object:textField queue:[NSOperationQueue mainQueue]
                         usingBlock:^(NSNotification * _Nonnull note) {
                             addAction.enabled = YES;
                         }];
        
        
    }];
    
    [alert addAction:addAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
