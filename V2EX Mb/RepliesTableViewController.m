//
//  RepliesTableViewController.m
//  V2EX Mb
//
//  Created by 小笠原やきん on 15/8/17.
//  Copyright © 2015年 yaqinking. All rights reserved.
//

#import "RepliesTableViewController.h"
#import "V2EXAPI.h"
#import "ReplyTableViewCell.h"

#import "AFNetworking.h"
#import "AFOnoResponseSerializer.h"
#import "IGHTMLQuery.h"
#import "SVPullToRefresh.h"

#import "ReplyPageViewController.h"

@interface RepliesTableViewController()

@property (nonatomic, assign) int pageOffset;

@property (nonatomic, strong) NSMutableArray *replyTopics;
@property (nonatomic, strong) NSMutableArray *replyURLs;
@property (nonatomic, strong) NSMutableArray *replyContents;

@end

@implementation RepliesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 的所有回复",self.user.name];
    self.pageOffset = 1;
    [self loadRepliesDataWithUserName:self.user.name andOffset:self.pageOffset];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self configureInfiniteScroll];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)configureInfiniteScroll {
    __weak RepliesTableViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadRepliesDataWithUserName:weakSelf.user.name andOffset:weakSelf.pageOffset];
    }];
}

- (void)loadRepliesDataWithUserName:(NSString *)name andOffset:(int) offset {
    __weak RepliesTableViewController *weakSelf = self;
    NSString *urlString = [NSString stringWithFormat:V2EX_REPLY_PAGE_WITH_ID_OFFSET,name,offset];
//    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    if (op) {
        op.responseSerializer = [AFOnoResponseSerializer HTMLResponseSerializer];
    } else {
        NSLog(@"can't set response serializer T_T ");
    }
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id htmlBody) {
 
        //后台处理这些数据，话说这个时候我才知道它返回数据后就开始直接在主线程执行了……
        dispatch_queue_t q = dispatch_queue_create("Query Content", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(q, ^{
            NSString *htmlBodyString = [htmlBody description];
            IGHTMLDocument *doc = [[IGHTMLDocument alloc] initWithHTMLString:htmlBodyString error:nil];
            [[doc queryWithXPath:kXPATHReplyContent] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
                [self.replyContents addObject:node.text];
            }];
            [[doc queryWithXPath:kXPATHReplyTopic] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
                [self.replyTopics addObject:node.text];
            }];
            [[doc queryWithXPath:kXPATHReplyTopicURL] enumerateNodesUsingBlock:^(IGXMLNode *node, NSUInteger idx, BOOL *stop) {
                NSString *completeURL = [NSString stringWithFormat:V2EX_URL_FORMAT_WITH_INNER_LINK,node.text];
                [self.replyURLs addObject:completeURL];
//                NSLog(@"URL -> %@",completeURL);
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                    self.pageOffset ++;
//                NSLog(@"Contents count %lu",self.replyContents.count);
            });
            
        });

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error T_T %@",[error localizedDescription]);
            [weakSelf.tableView.infiniteScrollingView stopAnimating];

    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.replyContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentidier = @"Reply Cell";
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentidier
                                                            forIndexPath:indexPath];
    cell.topicLabel.text = self.replyTopics[indexPath.row];
    cell.contentLabel.text = self.replyContents[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

#pragma mark - Lazy Initialization

- (NSMutableArray *)replyContents {
    if (!_replyContents) {
        _replyContents = [[NSMutableArray alloc] init];
    }
    return _replyContents;
}

- (NSMutableArray *)replyTopics {
    if (!_replyTopics) {
        _replyTopics = [[NSMutableArray alloc] init];
    }
    return _replyTopics;
}

- (NSMutableArray *)replyURLs {
    if (!_replyURLs) {
        _replyURLs = [[NSMutableArray alloc] init];
    }
    return _replyURLs;
}

#pragma mark - Open url

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ReplyPageViewController class]]) {
        ReplyPageViewController *rpvc = segue.destinationViewController;
        NSIndexPath *idx = [self.tableView indexPathForSelectedRow];
        NSString *urlString = self.replyURLs[idx.row];
//        NSLog(@"Jump url -> %@",urlString);
        rpvc.url = [NSURL URLWithString:urlString];
    }
}

@end
