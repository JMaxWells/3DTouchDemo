# 3DTouchDemo

* 1.3D Touch

* 2.FDTemplateLayoutCell

* 3.Peek And Pop

* 4.LKGlobalNavigationController

* 5.UIViewController+WMBase

## LKGlobalNavigationController
自定义导航栏，可以直接用URL进行跳转到新页面。

## UIViewController+WMBase
使用runtime动态添加属性，在LKGlobalNavigationController跳转到新页面的同时可以传参数。

## 3DTouch使用

### ShortcutItem初始化

``` swift
- (void)createItemsWithIcons {
    // icons with my own images,icon size 35*35
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeFavorite];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    
    // create several (dynamic) shortcut items
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.touch.deep1" localizedTitle:@"喜爱" localizedSubtitle:@"我的收藏" icon:icon1 userInfo:nil];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.touch.deep2" localizedTitle:@"搜索" localizedSubtitle:@"搜索活动" icon:icon2 userInfo:nil];
    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.touch.deep3" localizedTitle:@"分享" localizedSubtitle:@"分享到朋友圈" icon:icon3 userInfo:nil];
    
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
```

### ShortcutItem事件

``` swift
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
```

### UIPreviewActionItem

``` swift
// setup a list of preview actions
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"保存" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Default Action triggered");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Default Action triggered");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Destructive Action triggered");
    }];
    
    // add them to an arrary
    NSArray *actions = @[action1, action2, action3];
    
    // add all actions to a group
//    UIPreviewActionGroup *group1 = [UIPreviewActionGroup actionGroupWithTitle:@"Action Group" style:UIPreviewActionStyleDefault actions:actions];
//    NSArray *group = @[group1];
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return actions;
}
```

### Peek And Pop

注册UIViewControllerPreviewingDelegate

``` swift
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestTableViewCell"];
    // Enable to use "-sizeThatFits:"
    cell.fd_enforceFrameLayout = NO;

    cell.entity = self.titleArray[indexPath.row%10];

    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
        
    return cell;
}
```

实现UIViewControllerPreviewingDelegate

``` swift
# pragma mark - 3D Touch Delegate

// 轻压显示预览页面
// check if we're not already displaying a preview controller
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    if ([self.presentedViewController isKindOfClass:[DetailViewController class]]) {
        return nil;
    }

    DetailViewController *detailView = [[DetailViewController alloc] init];
    TestTableViewCell *cell = (TestTableViewCell *)[previewingContext sourceView];
    detailView.params = @{@"params":cell.txtLabel.text};
    
    return detailView;
}

// 重压显示详情页面
// alternatively, use the view controller that's being provided here (viewControllerToCommit)
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    TestTableViewCell *cell = (TestTableViewCell *)[previewingContext sourceView];

    [self showViewControllerWithUrLPattern:DETAIL_VIEW_CONTROLLER withParams:@{@"params":cell.txtLabel.text}];
}
```

## 扩展

[iOS9 3DTouch、ShortcutItem、Peek And Pop技术一览](http://maxwellpro.cn/2016/03/11/iOS9%203DTouch、ShortcutItem、Peek%20And%20Pop技术一览/)
