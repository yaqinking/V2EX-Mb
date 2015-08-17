//
//  ReplyPageViewController.m
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import "ReplyPageViewController.h"

@interface ReplyPageViewController()

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation ReplyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
}

@end
