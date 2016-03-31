//
//  UIViewController+WMBase.m
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/3/31.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import "UIViewController+WMBase.h"
#import "objc/runtime.h"

static char const *const paramsKey = "BaseParamskey";
static char const *const completeBlockKey = "CompleteBlockKey";

@implementation UIViewController (WMBase)

- (id)initWithParams:(id)params {
    if ([self init]) {
        self.params = params;
    }
    return self;
}

- (id)initWithParams:(id)params complete:(completeBlock)callBack {
    if ([self init]) {
        self.params = params;
        self.completeBlock = callBack;
    }
    return self;
}

#pragma mark 属性关联

- (void)setParams:(id)params {
    objc_setAssociatedObject(self, paramsKey, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)params {
    return objc_getAssociatedObject(self, paramsKey);
}

- (void)setCompleteBlock:(completeBlock)completeBlock {
    objc_setAssociatedObject(self, completeBlockKey, completeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (completeBlock)completeBlock {
    return objc_getAssociatedObject(self, completeBlockKey);
}

#pragma mark 自定义跳转方法

- (void)pushViewControllerWithUrLPattern:(NSString *)URLPattern {
    [self pushViewControllerWithUrLPattern:URLPattern withParams:nil];
}

- (void)pushViewControllerWithUrLPattern:(NSString *)URLPattern withParams:(NSDictionary *)params {
    [self pushViewControllerWithUrLPattern:URLPattern withParams:params completeReply:nil];
}

- (void)pushViewControllerWithUrLPattern:(NSString *)URLPattern  completeReply:(completeBlock)callBack
{
    [self pushViewControllerWithUrLPattern:URLPattern withParams:nil completeReply:callBack];
}

- (void)pushViewControllerWithUrLPattern:(NSString *)URLPattern withParams:(NSDictionary *)params completeReply:(completeBlock)callBack {
    [self pushViewControllerWithUrLPattern:URLPattern withParams:params animated:YES completeReply:callBack];
}

- (void)pushViewControllerWithUrLPattern:(NSString *)URLPattern withParams:(NSDictionary *)params animated:(BOOL)animate completeReply:(completeBlock)callBack {
    Class vcClass = [LKGlobalNavigationController findViewControllerClassWithURLPattern:URLPattern];
    UIViewController * vc=[[vcClass alloc] initWithParams:params complete:callBack];
    [[LKGlobalNavigationController sharedInstance] pushViewController:vc animated:animate];
}

- (void)presentViewControllerWithPattern:(NSString * __nullable )URLPattern completion:(void (^)(void))completion {
    UIViewController * vc=[[[LKGlobalNavigationController findViewControllerClassWithURLPattern:URLPattern] alloc] init];
    if (vc) {
        [self presentViewController:vc animated:YES completion:completion];
    }
    else
        NSLog(@"未找到ViewController");
}

- (void)presentViewControllerWithPattern:(NSString *)URLPattern withParams:(NSDictionary * __nullable)params completion:(void (^)(void))completion{
    Class vcClass = [LKGlobalNavigationController findViewControllerClassWithURLPattern:URLPattern];
    UIViewController *vc = [[vcClass alloc]initWithParams:params];
    if (vc) {
        [self presentViewController:vc animated:YES completion:completion];
    }
    else
        NSLog(@"未找到ViewController");
}

- (void)popPPViewController {
    [self popPPViewControllerAnimate:YES];
}

- (void)popPPViewControllerAnimate:(BOOL)animated {
    [self popoverPresentationControllerAnimated:animated completion:nil];
}

- (void)popoverPresentationControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    if ([self isKindOfClass:[UITabBarController class]]) {
        if (animated) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [[LKGlobalNavigationController sharedInstance].view.layer addAnimation:transition forKey:nil];
        }
        [[LKGlobalNavigationController sharedInstance] popViewControllerAnimated:NO];
    }
    else
        [[LKGlobalNavigationController sharedInstance] popViewControllerAnimated:animated];
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
    [[LKGlobalNavigationController sharedInstance] popToRootViewControllerAnimated:animated];
}

- (BOOL)popToViewControllerWithURLPattern:(NSString *)URLPattern animated:(BOOL)animated {
    UIViewController * vc=  [LKGlobalNavigationController findAnExistViewControllerWithURLPattern:URLPattern];
    if (vc) {
        [[LKGlobalNavigationController sharedInstance] popToViewController:vc animated:animated];
        return YES;
    }
    return NO;
}

@end
