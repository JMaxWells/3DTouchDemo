//
//  LoginViewController.m
//  KEEP
//
//  Created by ZhangXu on 16/3/29.
//  Copyright © 2016年 zhangXu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AVAudioSession *avaudioSession;
@property (nonatomic, strong) UIView *alpaView;
@property (nonatomic, strong) UIButton *regiset;
@property (nonatomic, strong) UIButton *login;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation LoginViewController

+ (void)load {
    [LKGlobalNavigationController registerURLPattern:LOGIN_VIEW_CONTROLLER viewControllerClass:[self class]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  设置其他音乐软件播放的音乐不被打断
     */
    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    
    
    NSString *urlStr = [[NSBundle mainBundle]pathForResource:@"1.mp4" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    //    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    [_moviePlayer play];
    [_moviePlayer.view setFrame:self.view.bounds];
    
    [self.view addSubview:_moviePlayer.view];
    _moviePlayer.shouldAutoplay = YES;
    [_moviePlayer setControlStyle:MPMovieControlStyleNone];
    [_moviePlayer setFullscreen:YES];
    
    [_moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_moviePlayer];
    
    self.alpaView = [[UIView alloc] initWithFrame:CGRectZero];
    self.alpaView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_alpaView];
    
    [self.alpaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4,0);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-70);
    }];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.213  green:0.807  blue:0.614 alpha:1];
    self.pageControl.tintColor = [UIColor colorWithRed:0.476  green:0.476  blue:0.476 alpha:1];
    [self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-70);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(37);
        make.left.mas_equalTo(SCREEN_WIDTH/2-65/2);
    }];
    
    self.regiset = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.regiset setTitle:@"注册" forState:UIControlStateNormal];
    [self.regiset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.regiset.backgroundColor = [UIColor blackColor];
    self.regiset.layer.cornerRadius = 3.0f;
    self.regiset.alpha = 0.4f;
    [self.alpaView addSubview:self.regiset];
    
    [self.regiset addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.login = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.login setTitle:@"登录" forState:UIControlStateNormal];
    [self.login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.login.backgroundColor = [UIColor whiteColor];
    [self.login addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.login.layer.cornerRadius = 3.0f;
    self.login.alpha = 0.4f;
    
    [self.alpaView addSubview:self.login];
    
    [self.regiset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.login.mas_left).with.offset(-20);
        make.height.mas_equalTo(@50);
        make.width.equalTo(self.login);
        make.bottom.mas_equalTo(@-20);
    }];
    
    [self.login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.left.equalTo(self.regiset.mas_right).with.offset(20);
        make.height.mas_equalTo(@50);
        make.width.equalTo(self.regiset);
        make.bottom.mas_equalTo(@-20);
    }];
    
    NSArray *sologn = @[@"每个动作都精确规范", @"规划陪伴你的训练过程", @"分享汗水后你的性感", @"全程记录你的健身数据"];
    
    for (int i = 0; i<sologn.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor whiteColor];
        label.text = sologn[i];
        label.font = [UIFont systemFontOfSize:22.0];
        label.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(i*SCREEN_WIDTH);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.bottom.equalTo(self.pageControl.mas_top).equalTo(@-10);
        }];
    }
 
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keep6plus@3x"]];
    [self.view addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH/2-70/2);
        make.top.mas_equalTo(SCREEN_HEIGHT*1/3);
        make.height.mas_equalTo(70/2);
        make.width.mas_equalTo(160/2);
    }];
    
    [self setupTimer];
}

- (void)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)playbackStateChanged {
    //取得目前状态
    MPMoviePlaybackState playbackState = [_moviePlayer playbackState];
    
    //状态类型
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
            [_moviePlayer play];
            break;
            
        case MPMoviePlaybackStatePlaying:
            NSLog(@"播放中");
            break;
            
        case MPMoviePlaybackStatePaused:
            [_moviePlayer play];
            break;
            
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"播放被中断");
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"往前快转");
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"往后快转");
            break;
            
        default:
            NSLog(@"无法辨识的状态");
            break;
    }
}

//ios以后隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupTimer {
    self.timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pageChanged:(UIPageControl *)pageControl {
    
    CGFloat x = (pageControl.currentPage) * [UIScreen mainScreen].bounds.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)timerChanged {
    int page  = (self.pageControl.currentPage +1) %4;
    
    self.pageControl.currentPage = page;
    
    [self pageChanged:self.pageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    double page = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    self.pageControl.currentPage = page;
    
    if (page== - 1) {
        self.pageControl.currentPage = 3;// 序号0 最后1页
    }
    else if (page == 4) {
        self.pageControl.currentPage = 0; // 最后+1,循环第1页
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:_moviePlayer];
}

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    NSLog(@"%s",__FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
