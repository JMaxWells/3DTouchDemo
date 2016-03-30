//
//  ViewController.m
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/2/22.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import "ViewController.h"
#import "PreviewViewController.h"
#import <BabyBluetooth.h>

@interface ViewController ()<UIViewControllerPreviewingDelegate>
{
    BabyBluetooth *_baby;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"3DTouch";
    UIImageView *imageView = [UIImageView new];
    [imageView setUserInteractionEnabled:YES];
    [imageView setImage:[UIImage imageNamed:@"WeChat_1455870166.jpeg"]];
    imageView.frame = CGRectMake(50, 200, 275, 275);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    [self check3DTouch];
    
    /**
     *  中心模式 central model
     */
    //初始化BabyBluetooth 蓝牙库
//    _baby = [BabyBluetooth shareBabyBluetooth];
//    //设置蓝牙委托
//    [self babyDelegate];
//    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
//    _baby.scanForPeripherals().begin();
    /**
     *  外设模式 peripheral model
     */
    
    /*
    //配置第一个服务s1
    CBMutableService *s1 = makeCBService(@"FFF0");
    //配置s1的3个characteristic
    makeCharacteristicToService(s1, @"FFF1", @"r", @"hello1");//读
    makeCharacteristicToService(s1, @"FFF2", @"w", @"hello2");//写
    makeCharacteristicToService(s1, genUUID(), @"rw", @"hello3");//可读写,uuid自动生成
    makeCharacteristicToService(s1, @"FFF4", nil, @"hello4");//默认读写字段
    makeCharacteristicToService(s1, @"FFF5", @"n", @"hello5");//notify字段
    //配置第一个服务s2
    CBMutableService *s2 = makeCBService(@"FFE0");
    makeStaticCharacteristicToService(s2, genUUID(), @"hello6", [@"a" dataUsingEncoding:NSUTF8StringEncoding]);//一个含初值的字段，该字段权限只能是只读
    
    //实例化baby
    _baby = [BabyBluetooth shareBabyBluetooth];
    //配置委托
    [self baby_Delegate];
    //启动外设
    _baby.bePeripheral().addServices(@[s1,s2]).startAdvertising();
     */
}

//设置蓝牙外设模式的委托
-(void)baby_Delegate{
    
    //设置添加service委托 | set didAddService block
    [_baby peripheralModelBlockOnPeripheralManagerDidUpdateState:^(CBPeripheralManager *peripheral) {
        NSLog(@"PeripheralManager trun status code: %ld",(long)peripheral.state);
    }];
    
    //设置添加service委托 | set didAddService block
    [_baby peripheralModelBlockOnDidStartAdvertising:^(CBPeripheralManager *peripheral, NSError *error) {
        NSLog(@"didStartAdvertising !!!");
    }];
    
    //设置添加service委托 | set didAddService block
    [_baby peripheralModelBlockOnDidAddService:^(CBPeripheralManager *peripheral, CBService *service, NSError *error) {
        NSLog(@"Did Add Service uuid: %@ ",service.UUID);
    }];
    
    //.....
}

//设置蓝牙委托
-(void)babyDelegate{
    
    //设置扫描到设备的委托
    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
    
    //过滤器
    //设置查找设备的过滤器
    [_baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];
    
    //.......
}

/**
 *  检测3DTouch是否可用
 */
- (void)check3DTouch {
    // register for 3D Touch (if available)
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
    }
}

# pragma mark - 3D Touch Delegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    // check if we're not already displaying a preview controller
    /**
     *  防止重复跳转
     */
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

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    PreviewViewController *previewController = [PreviewViewController new];
    [self showViewController:previewController sender:self];
    
    // alternatively, use the view controller that's being provided here (viewControllerToCommit)
}

@end
