//
//  V2EXAPI.h
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#ifndef V2EXAPI_h
#define V2EXAPI_h

//Example https://www.v2ex.com/member/Livid/replies?p=2
#define V2EX_REPLY_PAGE_WITH_ID_OFFSET @"https://www.v2ex.com/member/%@/replies?p=%i"

/**
 *后面根提取出来的短链接如 t/191215#reply6
 */
#define V2EX_URL_FORMAT_WITH_INNER_LINK @"https://www.v2ex.com%@"

//可提取出回复内容
#define kXPATHReplyContent @"//div[@class='reply_content']"
//Exapmle 回复了 xxx 创建的 xxx 主题，包括主题链接
#define kXPATHReplyTopic @"//span[@class='gray']"
#define kXPATHReplyTopicURL @"//span[@class='gray']/a/@href"

#endif /* V2EXAPI_h */
