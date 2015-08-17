//
//  ReplyTableViewCell.m
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import "ReplyTableViewCell.h"

@implementation ReplyTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.topicLabel.preferredMaxLayoutWidth = self.topicLabel.frame.size.width;
    self.contentLabel.preferredMaxLayoutWidth = self.contentLabel.frame.size.width;
//    self.topicLabel.
}

@end
