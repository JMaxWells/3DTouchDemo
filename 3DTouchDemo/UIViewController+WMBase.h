//
//  UIViewController+WMBase.h
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/3/31.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeBlock)(id result);

@interface UIViewController (WMBase)

/**
 *  外部传入的参数
 */
@property (nonatomic, strong) id params;
/**
 *  外部传入的block参数
 */
@property (nonatomic, copy) completeBlock completeBlock;

/**
 *  根据参数创建视图
 */
- (id)initWithParams:(id)params;
- (id)initWithParams:(id)params complete:(completeBlock)callBack;

#pragma mark SHOW

- (void)showViewControllerWithUrLPattern:(NSString *)URLPattern;
- (void)showViewControllerWithUrLPattern:(NSString *)URLPattern withParams:(NSDictionary *)params;
- (void)showViewControllerWithUrLPattern:(NSString *)URLPattern withParams:(NSDictionary *)params completeReply:(completeBlock)callBack;

#pragma mark PUSH

- (void)pushViewControllerWithUrLPattern:(NSString *)URLPattern;
- (void)pushViewControllerWithUrLPattern:(NSString *)URLPattern withParams:(NSDictionary *)params;
- (void)pushViewControllerWithUrLPattern:(NSString *)URLPattern completeReply:(completeBlock)callBack;
- (void)pushViewControllerWithUrLPattern:(NSString *)URLPattern withParams:(NSDictionary *)params completeReply:(completeBlock)callBack;
- (void)pushViewControllerWithUrLPattern:(NSString *)URLPattern withParams:(NSDictionary *)params animated:(BOOL)animate completeReply:(completeBlock)callBack;

#pragma mark POP

-(void)popPPViewController;
-(void)popPPViewControllerAnimate:(BOOL)animated;
-(void)popToRootViewControllerAnimated:(BOOL)animated;
-(BOOL)popToViewControllerWithURLPattern:(NSString *)URLPattern animated:(BOOL)animated;

#pragma mark PRESENT

-(void)presentViewControllerWithPattern:(NSString *)URLPattern completion:(void (^)(void))completion;
-(void)presentViewControllerWithPattern:(NSString *)URLPattern withParams:(NSDictionary *)params completion:(void (^)(void))completion;

@end
