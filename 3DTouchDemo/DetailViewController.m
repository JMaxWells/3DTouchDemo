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
#import <MMPlaceHolder.h>

@interface DetailViewController ()

@property (nonatomic, strong) YYTextView *textView;

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
    
    UIView *sv = [UIView new];
    sv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sv];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];

    UIView *sv1 = [UIView new];
    sv1.backgroundColor = [UIColor redColor];
    [sv addSubview:sv1];
    [sv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        
        /* 等价于
         make.top.equalTo(sv).with.offset(10);
         make.left.equalTo(sv).with.offset(10);
         make.bottom.equalTo(sv).with.offset(-10);
         make.right.equalTo(sv).with.offset(-10);
         */
        
        /* 也等价于
         make.top.left.bottom.and.right.equalTo(sv).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
         */
    }];
    
    UIView *sv2 = [UIView new];
    sv2.backgroundColor = [UIColor blackColor];
    [sv1 addSubview:sv2];
    [sv2 showPlaceHolder];

    UIView *sv3 = [UIView new];
    sv3.backgroundColor = [UIColor blackColor];
    [sv1 addSubview:sv3];
    [sv3 showPlaceHolder];

    [sv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(150);
        make.centerY.mas_equalTo(sv1.mas_centerY);
        make.width.equalTo(sv3);
        make.right.equalTo(sv3.mas_left).offset(-10);
        make.left.equalTo(sv1.mas_left).offset(10);
    }];

    [sv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(150);
        make.centerY.mas_equalTo(sv1.mas_centerY);
        make.width.equalTo(sv2);
        make.right.equalTo(sv1.mas_right).offset(-10);
        make.left.equalTo(sv2.mas_right).offset(10);
    }];
    
}

@end
