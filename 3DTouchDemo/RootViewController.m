//
//  RootViewController.m
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/2/22.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UIViewControllerPreviewingDelegate>

@end

@implementation RootViewController

+ (void)load {
    [LKGlobalNavigationController registerURLPattern:ROOT_VIEW_CONTROLLER viewControllerClass:[self class]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"3DTouch";
    
    UIImageView *imageView = [UIImageView new];
    [imageView setUserInteractionEnabled:YES];
    [imageView setImage:[UIImage imageNamed:@"WeChat_1455870166.jpeg"]];
    imageView.frame = self.view.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    [self check3DTouch];
}

// register for 3D Touch (if available)
- (void)check3DTouch {
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
    }
}

# pragma mark - 3D Touch Delegate

// check if we're not already displaying a preview controller
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    if ([self.presentedViewController isKindOfClass:[PreviewViewController class]]) {
        return nil;
    }
    
    PreviewViewController *previewController = [[PreviewViewController alloc] init];
    
    previewController.view.layer.masksToBounds = YES;
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"PreviewViewController";
    titleView.textColor = [UIColor whiteColor];
    titleView.backgroundColor = [UIColor blackColor];
    [previewController.view addSubview:titleView];
    
    return previewController;
}

// alternatively, use the view controller that's being provided here (viewControllerToCommit)
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewControllerWithUrLPattern:PREVIEW_VIEW_CONTROLLER];
}

@end
