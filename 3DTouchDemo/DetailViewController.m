//
//  DetailViewController.m
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/3/28.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import "DetailViewController.h"
#import <Masonry.h>
#import <YYTextView.h>
#import "LKGlobalNavigationController.h"
#import "UIViewController+WMBase.h"

@interface DetailViewController ()

@property (nonatomic ,strong) YYTextView *textView;

@end

@implementation DetailViewController

+ (void)load {
    [LKGlobalNavigationController registerURLPattern:@"3DTouch://detailview" viewControllerClass:[self class]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textView = [YYTextView new];
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    self.textView.textColor = [UIColor blackColor];
    [self.view addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    if (self.params) {
        self.textView.text = [self.params valueForKey:@"params"];;
    }
}

@end
