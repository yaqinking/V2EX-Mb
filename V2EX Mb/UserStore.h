//
//  UserStore.h
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface UserStore : NSObject
@property (nonatomic, readonly) NSArray *allUsers;

+ (instancetype)sharedStore;

- (User *)createUser;
- (NSString *)userArchivePath;
- (void)removeUser:(User *)user;

- (BOOL)saveChanges;

@end
