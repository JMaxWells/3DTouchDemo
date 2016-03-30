//
//  TestTableViewCell.m
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/3/30.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import "TestTableViewCell.h"
#import "Masonry.h"

@implementation TestTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.txtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.txtLabel.numberOfLines = 0;
        self.txtLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.txtLabel.font = [UIFont systemFontOfSize:15.0f];
        self.txtLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.txtLabel];
        
        [self.txtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-10);
        }];
    }
    
    return self;
}

-(void)setEntity:(NSString *)entity {
    self.txtLabel.text = entity;
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.txtLabel sizeThatFits:size].height;
    return CGSizeMake(size.width, totalHeight);
}


@end
