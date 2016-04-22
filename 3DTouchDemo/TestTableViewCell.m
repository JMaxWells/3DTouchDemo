//
//  TestTableViewCell.m
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/3/30.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import "TestTableViewCell.h"
#import "NSAttributedString+YYText.h"

@implementation TestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.txtLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        self.txtLabel.numberOfLines = 0;
        self.txtLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.txtLabel];
        
        [self.txtLabel setFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 0)];
        
//        [self.txtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(10);
//            make.left.mas_equalTo(10);
//            make.bottom.mas_equalTo(-10);
//            make.right.mas_equalTo(-10);
//        }];
    }
    
    return self;
}

- (void)setEntity:(NSString *)entity {
    self.txtLabel.displaysAsynchronously = YES;
    self.txtLabel.ignoreCommonProperties = YES; //忽略除了 textLayout 之外的其他属性
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建属性字符串
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:entity];
        text.font = [UIFont systemFontOfSize:15];
        text.color = [UIColor blackColor];
        
        // 创建文本容器
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX);
        container.maximumNumberOfRows = 0;
        
        // 生成排版结果
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.txtLabel.size = layout.textBoundingSize;
            self.txtLabel.textLayout = layout;
            [self.txtLabel setAttributedText:text];
        });
    });
    
//    self.txtLabel.text = entity;
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += self.txtLabel.size.height;
    return CGSizeMake(size.width, totalHeight);
}


@end
