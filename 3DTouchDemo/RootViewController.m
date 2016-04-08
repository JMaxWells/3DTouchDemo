//
//  RootViewController.m
//  3DTouchDemo
//
//  Created by MaxWellPro on 16/2/22.
//  Copyright © 2016年 MaxWellPro. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UIViewControllerPreviewingDelegate,UIActionSheetDelegate> {
    BOOL _down;
}

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *cameraButton;

@end

@implementation RootViewController

+ (void)load {
    [LKGlobalNavigationController registerURLPattern:ROOT_VIEW_CONTROLLER viewControllerClass:[self class]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_loginButton];
    [self.navigationController.navigationBar addSubview:_cameraButton];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_loginButton removeFromSuperview];
    [_cameraButton removeFromSuperview];
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
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(SCREEN_WIDTH - 52, 0, 44, 44);
    _loginButton.backgroundColor = [UIColor clearColor];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraButton.frame = CGRectMake(8, 0, 44, 44);
    _cameraButton.backgroundColor = [UIColor clearColor];
    _cameraButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_cameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cameraButton setTitle:@"短视频" forState:UIControlStateNormal];
    [_cameraButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cameraAction:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择拍摄方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"趣拍",@"EasyVideo", nil];
    [sheet showInView:self.view];
}

- (void)loginAction:(UIButton *)sender {
    [self presentViewControllerWithPattern:LOGIN_VIEW_CONTROLLER completion:^{
        
    }];
}

// register for 3D Touch (if available)
- (void)check3DTouch {
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        id<ALBBQuPaiService> sdk = [[ALBBSDK sharedInstance] getService:@protocol(ALBBQuPaiService)];
        [sdk setDelegte:(id<QupaiSDKDelegate>)self];
        
        /* 可选设置 */
        
        /* 是否开启导入 */
        [sdk setEnableImport:YES];
        /* 是否添加更多音乐按钮 */
        [sdk setEnableMoreMusic:YES];
        /* 是否开启美颜切换 */
        [sdk setEnableBeauty:YES];
        /* 是否开启视频编辑页面 */
        [sdk setEnableVideoEffect:YES];
        /* 是否开启水印图片 */
        [sdk setEnableWatermark:YES];
        [sdk setTintColor:[UIColor colorWithRed:0.351  green:0.788  blue:0.986 alpha:1]];
        /* 首帧图图片质量:压缩质量 0-1 */
        [sdk setThumbnailCompressionQuality:1.0f];
        /* 水印图片 */
        [sdk setWatermarkImage:[UIImage imageNamed:@"watermask"]];
        /* 水印图片位置 */
        [sdk setWatermarkPosition:QupaiSDKWatermarkPositionTopRight];
        /* 默认摄像头位置，only Back or Front */
        [sdk setCameraPosition:QupaiSDKCameraPositionBack];
        
        /* 基本设置 */
        
        /**
         *创建录制页面，需要以 UINavigationController 为父容器
         * @param minDuration 允许拍摄的最小时长
         * @param maxDuration 允许拍摄的最大时长
         * @param bitRate 视频码率，建议800*1000-5000*1000,码率越大，视频越清析，视频文件也会越大。参考：8秒的视频以2000*1000的码率压缩，文件大小1.5M-2M。请开发者根据自己的业务场景设置时长和码率
         */
        UIViewController *recordController = [sdk createRecordViewControllerWithMinDuration:2
                                                                                maxDuration:10
                                                                                    bitRate:2000*1000];
        
        recordController.view.backgroundColor = [UIColor colorWithRed:0.144  green:0.172  blue:0.242 alpha:1];
        
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:recordController];
        navigation.navigationBarHidden = YES;
        [self presentViewController:navigation animated:YES completion:nil];
    }
}

- (void)qupaiSDK:(id<ALBBQuPaiService>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath
{
    NSLog(@"Qupai SDK compelete %@",videoPath);
    [self dismissViewControllerAnimated:YES completion:nil];
    if (videoPath) {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
    }
    if (thumbnailPath) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:thumbnailPath], nil, nil, nil);
    }
}

- (NSArray *)qupaiSDKMusics:(id<ALBBQuPaiService>)sdk
{
    NSString *baseDir = [[NSBundle mainBundle] bundlePath];
    NSString *configPath = [[NSBundle mainBundle] pathForResource:_down ? @"music2" : @"music1" ofType:@"json"];
    NSData *configData = [NSData dataWithContentsOfFile:configPath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil];
    NSArray *items = dic[@"music"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *item in items) {
        NSString *path = [baseDir stringByAppendingPathComponent:item[@"resourceUrl"]];
        QPEffectMusic *effect = [[QPEffectMusic alloc] init];
        effect.name = item[@"name"];
        effect.eid = [item[@"id"] intValue];
        effect.musicName = [path stringByAppendingPathComponent:@"audio.mp3"];
        effect.icon = [path stringByAppendingPathComponent:@"icon.png"];
        [array addObject:effect];
    }
    return array;
}

- (void)qupaiSDKShowMoreMusicView:(id<ALBBQuPaiService>)sdk viewController:(UIViewController *)viewController {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更多音乐正在更新中...敬请期待" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil, nil];
    [alert show];
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
