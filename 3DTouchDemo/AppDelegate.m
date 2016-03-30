//
//  AppDelegate.m
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/2/22.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import "AppDelegate.h"
#import "PreviewViewController.h"
#import "YYFPSLabel.h"
#import <YYKit.h>
#import <Masonry.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.alpha = 1.0f;
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController *vc = [ViewController  new];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
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
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.lark.deep1" localizedTitle:@"喜爱" localizedSubtitle:@"我的收藏" icon:icon1 userInfo:nil];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.lark.deep2" localizedTitle:@"搜索" localizedSubtitle:@"搜索活动" icon:icon2 userInfo:nil];
    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.lark.deep3" localizedTitle:@"扫码" localizedSubtitle:@"扫描二维码" icon:icon3 userInfo:nil];
    
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
    if ([shortcutItem.type isEqualToString:@"com.lark.deep1"]) {
        NSLog(@"clicked deep1");
        PreviewViewController *vc = [PreviewViewController new];
        self.window.rootViewController = vc;
        [self.window makeKeyWindow];
    }
    
    if ([shortcutItem.type isEqualToString:@"com.lark.deep2"]) {
        NSLog(@"clicked deep2");
    }
    
    if ([shortcutItem.type isEqualToString:@"com.lark.deep3"]) {
        NSLog(@"clicked deep3");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
