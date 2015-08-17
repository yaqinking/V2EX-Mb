//
//  UserStore.m
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import "UserStore.h"
#import "User.h"

@interface UserStore ()

@property (nonatomic) NSMutableArray *privateUsers;

@end

@implementation UserStore

+ (instancetype)sharedStore {
    static UserStore *sharedStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[UserStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        NSString *path = [self userArchivePath];
        _privateUsers = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!_privateUsers) {
            _privateUsers = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allUsers {
    return [self.privateUsers copy];
}

- (User *)createUser {
    User *user = [[User alloc] init];
    [self.privateUsers addObject:user];
    return user;
}

- (void)removeUser:(User *)user {
    [self.privateUsers removeObjectIdenticalTo:user];
}

- (NSString *)userArchivePath {
    //NSDocumentDirectory 这里一定要注意 QAQ
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"users.archive"];
}

- (BOOL)saveChanges {
    NSString *path = [self userArchivePath];
//    NSLog(@"%@",path);
    return [NSKeyedArchiver archiveRootObject:self.privateUsers
                                       toFile:path];
}

@end
