//
//  ReplyPageViewController.m
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import "ReplyPageViewController.h"

@interface ReplyPageViewController() <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation ReplyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Open in Safari"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(openInSafari)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void) openInSafari {
    [[UIApplication sharedApplication] openURL:self.url];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
