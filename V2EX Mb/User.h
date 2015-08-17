//
//  User.h
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *replyPageURLString;

@end
