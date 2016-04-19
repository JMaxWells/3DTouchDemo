//
//  PreviewViewController.m
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/2/22.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import "PreviewViewController.h"

static char overviewKey;

@interface PreviewViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation PreviewViewController

+ (void)load {
    [LKGlobalNavigationController registerURLPattern:PREVIEW_VIEW_CONTROLLER viewControllerClass:[self class]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PreviewView";
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[TestTableViewCell class] forCellReuseIdentifier:@"TestTableViewCell"];
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.fd_debugLogEnabled = YES;

    self.titleArray = @[@"其实，iOS8已经提供了直接通过XIB让Cell高度自适应的方法了，只要简单拖拖线，根本木有必要计算Cell高度，就可以搞定不等高Cell",@"想知道妹纸爱你有多深？知道这个干嘛，直接通过iOS8，让妹纸爱上你不就好啦~",@"ummmm就不给效果图了哦，和上一张是一样一样的~",@"通常情况下，Cell之所以不等高，是因为Cell内部文字区域的高度会根据文字数量动态变化，图片区域的高度会根据图片数量而自动变化。也就是说，只要知道文字区域的高度、图片区域的高度，就可以硬生生计算出Cell的高度了。",@"嗯！Cell也是一样的，想知道cell到底有多高？直接问Cell本人就好了。直接法，就是把数据布局到Cell上，然后拿到Cell最底部控件的MaxY值。",@"第二步：再给这个Cell添加点别的东东，就叫这个东东BottomCub了。为Cub添加好约束。",@"第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法",@"第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法",@"第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法",@"第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法第三步：为这个Cell写一个返回Cell高度 - 也就是BottomCub最大Y值的方法",@"11",@"eqweqwe",@"课题二：在哪计算Cell高度"];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count*10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"TestTableViewCell" cacheByIndexPath:indexPath configuration:^(TestTableViewCell *cell) {
        cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
        cell.entity = self.titleArray[indexPath.row%10];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TestTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    [self pushViewControllerWithUrLPattern:DETAIL_VIEW_CONTROLLER withParams:@{@"params":cell.txtLabel.text}];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSNumber *number = (NSNumber *)objc_getAssociatedObject(alertView,&overviewKey);
        NSLog(@"number is %@",number);
    }
}

# pragma mark - 3D Touch Delegate

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

// alternatively, use the view controller that's being provided here (viewControllerToCommit)
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    TestTableViewCell *cell = (TestTableViewCell *)[previewingContext sourceView];

    [self showViewControllerWithUrLPattern:DETAIL_VIEW_CONTROLLER withParams:@{@"params":cell.txtLabel.text}];
}

#pragma mark - Preview Actions

// setup a list of preview actions
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"保存" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"test" message:@"msg" delegate:self cancelButtonTitle:@"no" otherButtonTitles:@"yes", nil];
        objc_setAssociatedObject(alert,&overviewKey,@1,OBJC_ASSOCIATION_RETAIN);
        [alert show];
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Destructive Action triggered");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了分享按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Selected Action triggered");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了删除按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    // add them to an arrary
    NSArray *actions = @[action1, action2, action3];
    
    // add all actions to a group
//    UIPreviewActionGroup *group1 = [UIPreviewActionGroup actionGroupWithTitle:@"Action Group" style:UIPreviewActionStyleDefault actions:actions];
//    NSArray *group = @[group1];
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return actions;
}


@end
