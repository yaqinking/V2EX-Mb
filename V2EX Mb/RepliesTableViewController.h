//
//  RepliesTableViewController.h
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "User.h"

@interface RepliesTableViewController : UITableViewController

@property (nonatomic, strong) User *user;

@end
