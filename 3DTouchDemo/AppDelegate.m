//
//  AppDelegate.m
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/2/22.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.alpha = 1.0f;
    self.window.backgroundColor = [UIColor whiteColor];
    
    RootViewController *vc = [RootViewController  new];
    LKGlobalNavigationController *nvc = [[LKGlobalNavigationController sharedInstance] initWithRootViewController:vc];
    UIBarButtonItem *leftItem = nvc.navigationItem.backBarButtonItem;
    [leftItem setTitle:nil];
    [nvc.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [nvc.navigationBar setTintColor:[UIColor blackColor]];
    [nvc.navigationBar setBarStyle:UIBarStyleDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] init];
    [nvc.navigationBar.superview addSubview:fpsLabel];
    
    [fpsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(30, 20));
        make.top.mas_equalTo(64);
    }];
    
    self.window.rootViewController = nvc;
    [self.window makeKeyWindow];
    
    /**
     *  如果系统大于9 才使用3DTouch
     */
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        [self createItemsWithIcons];
    }
   
    return YES;
}

# pragma mark - Springboard Shortcut Items

- (void)createItemsWithIcons {
    // icons with my own images
    /**
     *  icon大小35*35
     */
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeFavorite];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"touch_qrcode"];
    
    // create several (dynamic) shortcut items
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.touch.deep1" localizedTitle:@"喜爱" localizedSubtitle:@"我的收藏" icon:icon1 userInfo:nil];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.touch.deep2" localizedTitle:@"搜索" localizedSubtitle:@"搜索活动" icon:icon2 userInfo:nil];
    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.touch.deep3" localizedTitle:@"扫码" localizedSubtitle:@"扫描二维码" icon:icon3 userInfo:nil];
    
    // add all items to an array
    /**
     *  防止不支持设备引起崩溃
     */
    if (item1 && item2 && item3) {
        NSArray *items = @[item1, item2, item3];
        
        // add the array to our app
        [UIApplication sharedApplication].shortcutItems = items;
    }
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    // react to shortcut item selections
    NSLog(@"A shortcut item was pressed. It was %@.", shortcutItem.localizedTitle);
    
    // have we launched Deep Link Level 1
    if ([shortcutItem.type isEqualToString:@"com.touch.deep1"]) {
        NSLog(@"clicked deep1");
        PreviewViewController *vc = [PreviewViewController new];
        self.window.rootViewController = vc;
        [self.window makeKeyWindow];
    }
    
    if ([shortcutItem.type isEqualToString:@"com.touch.deep2"]) {
        NSLog(@"clicked deep2");
        [[LKGlobalNavigationController sharedInstance] pushViewControllerWithUrLPattern:PREVIEW_VIEW_CONTROLLER];
    }
    
    if ([shortcutItem.type isEqualToString:@"com.touch.deep3"]) {
        NSLog(@"clicked deep3");
    }
}

@end
