//
//  LKGlobalNavigationController.m
//  lark
//
//  Created by baohui.qct on 15/8/19.
//  Copyright © 2015年 quncaotech. All rights reserved.
//

#import "LKGlobalNavigationController.h"

static NSString * const LK_ROUTER_WILDCARD_CHARACTER = @"~";

NSString *const LKGlobalParameterURL        = @"LKGlobalParameterURL";

@interface LKGlobalNavigationController ()

/**
 *  保存了所有已注册的 URL
 *  结构类似 @{@"beauty": @{@":id": {@"_", [block copy]}}}
 */
@property (nonatomic) NSMutableDictionary *routes;

- (NSMutableDictionary *)extractParametersFromURL:(NSString *)url;

@property (nonatomic) NSMutableDictionary *registerViewControllerCls;
@end

@implementation LKGlobalNavigationController

IMPLEMENT_SINGLETON(LKGlobalNavigationController)

+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(LKRouterHandler)handler {
    [[self sharedInstance] addURLPattern:URLPattern andHandler:handler];
}

+ (void)registerURLPattern:(NSString *)URLPattern viewControllerClass:(Class)cls {
    [((LKGlobalNavigationController*)[self sharedInstance]).registerViewControllerCls setObject:cls forKey:URLPattern];
}

+ (UIViewController *) findAnExistViewControllerWithURLPattern:(NSString *)URLPattern{
    for (NSInteger i=[LKGlobalNavigationController sharedInstance].viewControllers.count; i>0; i--) {
        UIViewController * v=[[LKGlobalNavigationController sharedInstance].viewControllers objectAtIndex:(i-1)];
        Class vClass=[LKGlobalNavigationController findViewControllerClassWithURLPattern:URLPattern];
        if ([v isKindOfClass:vClass]) {
            return v;
        }
    }
    return nil;
}

+ (Class) findViewControllerClassWithURLPattern:(NSString *)URLPattern
{
  return [((LKGlobalNavigationController*)[self sharedInstance]).registerViewControllerCls valueForKey:URLPattern];
}

+ (void)deregisterURLPattern:(NSString *)URLPattern {
    [[self sharedInstance] removeURLPattern:URLPattern];
}

#pragma mark - Utils

- (NSMutableDictionary *)extractParametersFromURL:(NSString *)url {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    parameters[LKGlobalParameterURL] = url;
    
    NSMutableDictionary* subRoutes = self.routes;
    NSArray* pathComponents = [self pathComponentsFromURL:url];
    
    // borrowed from HHRouter(https://github.com/Huohua/HHRouter)
    
    for (NSString* pathComponent in pathComponents) {
        BOOL found = NO;
        
        // 对 key 进行排序，这样可以把 ~ 放到最后
        NSArray *subRoutesKeys =[subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString* key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:LK_ROUTER_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                parameters[[key substringFromIndex:1]] = pathComponent;
                break;
            }
        }
        // 如果没有找到该 pathComponent 对应的 handler，则以上一层的 handler 作为 fallback
        if (!found && !subRoutes[@"_"]) {
            return nil;
        }
    }
    // Extract Params From Query.
    NSArray* pathInfo = [url componentsSeparatedByString:@"?"];
    if (pathInfo.count > 1) {
        NSString* parametersString = [pathInfo objectAtIndex:1];
        NSArray* paramStringArr = [parametersString componentsSeparatedByString:@"&"];
        for (NSString* paramString in paramStringArr) {
            NSArray* paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
                NSString* key = [paramArr objectAtIndex:0];
                NSString* value = [paramArr objectAtIndex:1];
                parameters[key] = value;
            }
        }
    }
    
    if (subRoutes[@"_"]) {
        parameters[@"block"] = [subRoutes[@"_"] copy];
    }
    
    return parameters;
}

- (void)addURLPattern:(NSString *)URLPattern andHandler:(LKRouterHandler)handler {
    NSArray *pathComponents = [self pathComponentsFromURL:URLPattern];
    
    NSInteger index = 0;
    NSMutableDictionary* subRoutes = self.routes;
    
    while (index < pathComponents.count) {
        NSString* pathComponent = pathComponents[index];
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
        index++;
    }
    if (handler) {
        subRoutes[@"_"] = [handler copy];
    }
}

- (void)removeURLPattern:(NSString *)URLPattern {
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[self pathComponentsFromURL:URLPattern]];
    
    // 只删除该 pattern 的最后一级
    if (pathComponents.count >= 1) {
        // 假如 URLPattern 为 a/b/c, components 就是 @"a.b.c" 正好可以作为 KVC 的 key
        NSString *components = [pathComponents componentsJoinedByString:@"."];
        NSMutableDictionary *route = [self.routes valueForKeyPath:components];
        
        if (route.count >= 1) {
            NSString *lastComponent = [pathComponents lastObject];
            [pathComponents removeLastObject];
            
            // 有可能是根 key，这样就是 self.routes 了
            route = self.routes;
            if (pathComponents.count) {
                NSString *componentsWithoutLast = [pathComponents componentsJoinedByString:@"."];
                route = [self.routes valueForKeyPath:componentsWithoutLast];
            }
            [route removeObjectForKey:lastComponent];
        }
    }
}

- (NSArray*)pathComponentsFromURL:(NSString*)URL {
    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        // 如果只有协议，那么放一个占位符
        if ((pathSegments.count == 2 && ((NSString *)pathSegments[1]).length) || pathSegments.count < 2) {
            [pathComponents addObject:LK_ROUTER_WILDCARD_CHARACTER];
        }
        
        URL = [URL substringFromIndex:[URL rangeOfString:@"://"].location + 3];
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}


-(LKGlobalNavigationController*) init {
    self.registerViewControllerCls = [[NSMutableDictionary alloc] initWithCapacity:10];
    return [super init];
}


@end
