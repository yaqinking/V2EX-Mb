//
//  User.m
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import "User.h"

#define kUserName @"userName"
#define kUserReplyPageURL @"userReplyURL"

@implementation User

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:kUserName];
        self.replyPageURLString = [aDecoder decodeObjectForKey:kUserReplyPageURL];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:kUserName];
    [aCoder encodeObject:self.replyPageURLString forKey:kUserReplyPageURL];
}

@end
