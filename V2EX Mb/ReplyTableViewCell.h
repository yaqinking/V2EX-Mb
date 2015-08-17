//
//  ReplyTableViewCell.h
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
