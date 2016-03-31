//
//  LKGlobalNavigationController.h
//  lark
//
//  Created by baohui.qct on 15/8/19.
//  Copyright © 2015年 quncaotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSingleton.h"

extern NSString *const LKGlobalParameterURL;

typedef void (^LKRouterHandler)(NSDictionary *routerParameters);
@interface LKGlobalNavigationController : UINavigationController
DECLARE_SINGLETON(LKGlobalNavigationController)

/**
 *  注册 URLPattern 对应的 Handler，在 handler 中可以初始化 VC，然后对 VC 做各种操作
 *
 *  @param URLPattern 带上 scheme，如 lark://beauty/:id
 *  @param handler    该 block 会传一个字典，包含了注册的 URL 中对应的变量。
 *                    假如注册的 URL 为 lark://beauty/:id 那么，就会传一个 @{@"id": 4} 这样的字典过来
 */
+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(LKRouterHandler)handler;

/**
 *  注册 URLPattern 对应的 Viewcontroller，可以根据相应的URL打开
 *
 *  @param URLPattern   带上 scheme，如 lark://beauty/:id
 *  @param cls          Viewcontroller的Class
 */
+ (void)registerURLPattern:(NSString *)URLPattern viewControllerClass:(Class)cls;

/**
 *  根据URL查找Controller类
 *
 *  @param URLPattern 带上 scheme，如 lark://beauty/:id
 *
 *  @return Viewcontroller的Class
 */
+ (Class)findViewControllerClassWithURLPattern:(NSString *)URLPattern;

+ (UIViewController *)findAnExistViewControllerWithURLPattern:(NSString *)URLPattern;

/**
 *  取消注册某个 URL Pattern
 *
 *  @param URLPattern
 */
+ (void)deregisterURLPattern:(NSString *)URLPattern;

@end
