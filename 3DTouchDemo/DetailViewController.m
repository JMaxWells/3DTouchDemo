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

@interface DetailViewController ()

@property (nonatomic ,strong) YYTextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    self.textView.text = self.title;
    
    self.title = @"详情";
}

@end
