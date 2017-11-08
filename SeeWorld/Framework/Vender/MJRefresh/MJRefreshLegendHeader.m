//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshLegendHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 itcast
//

#import "MJRefreshLegendHeader.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"

@interface MJRefreshLegendHeader()
//@property (nonatomic, weak) UIImageView *arrowImage;
@property (nonatomic, weak) UIImageView *waitingImageView;
@end

@implementation MJRefreshLegendHeader
#pragma mark - 懒加载
//del by xiongchen
//- (UIImageView *)arrowImage
//{
//    if (!_arrowImage) {
//        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
//        //隐藏箭头
//        arrowImage.hidden = YES;
//        [self addSubview:_arrowImage = arrowImage];
//    }
//    return _arrowImage;
//}


//- (UIActivityIndicatorView *)activityView
//{
//    if (!_activityView) {
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        //隐藏圈圈
//        activityView.hidden = YES;
//        activityView.bounds = self.arrowImage.bounds;
//        [self addSubview:_activityView = activityView];
//    }
//    return _activityView;
//}

//add by xiongchen
- (UIImageView *)waitingImageView
{
    if (!_waitingImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_icon_pullrefresh"]];
        imageView.hidden = YES;
        [self addSubview:_waitingImageView = imageView];
    }
    
    return _waitingImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self startIndicatorAnimation];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(handleEnterForeground:)
                                                     name: UIApplicationWillEnterForegroundNotification
                                                   object: nil];
    }
    
    return self;
}

//动画
- (void)startIndicatorAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.6;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.waitingImageView.layer addAnimation:rotationAnimation forKey:nil];
}

- (void)stopIndicatorAnimation
{
    [self.waitingImageView.layer removeAllAnimations];
}

//后台进前台
- (void)handleEnterForeground:(NSNotification*)notification
{
    [self startIndicatorAnimation];
}

#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 箭头
//    CGFloat arrowX = (self.stateHidden && self.updatedTimeHidden) ? self.mj_w * 0.5 : (self.mj_w * 0.5 - 100);
//    self.arrowImage.center = CGPointMake(arrowX, self.mj_h * 0.5);
    
    //mod by xiongchen
    self.waitingImageView.frame = self.headImageView.frame;
    
    // 指示器
//    self.activityView.center = self.arrowImage.center;
}

#pragma mark - 公共方法
#pragma mark 设置状态
- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;
    
    // 旧状态
    MJRefreshHeaderState oldState = self.state;
    
    switch (state) {
        case MJRefreshHeaderStateIdle: {
            if (oldState == MJRefreshHeaderStateRefreshing) {
//                self.arrowImage.transform = CGAffineTransformIdentity;
                //mod by xiongchen
                if (self.allImageHiden)
                {
                    self.headImageView.hidden = YES;
                    self.waitingImageView.hidden = YES;
                }
                else
                {
                    self.waitingImageView.hidden = YES;
                    self.headImageView.hidden = NO;
                }
                
                [self stopIndicatorAnimation];
                
//                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
//                    self.activityView.alpha = 0.0;
//                } completion:^(BOOL finished) {
//                    self.arrowImage.alpha = 1.0;
//                    self.activityView.alpha = 1.0;
//                    [self.activityView stopAnimating];
//                }];
            } else {
//                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//                    self.arrowImage.transform = CGAffineTransformIdentity;
//                }];
            }
            break;
        }
            
        case MJRefreshHeaderStatePulling: {
//            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//                self.arrowImage.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
//            }];
            break;
        }
            
        case MJRefreshHeaderStateRefreshing: {
            //mod by xiongchen
//            [self.activityView startAnimating];
            if (self.allImageHiden)
            {
                self.headImageView.hidden = YES;
                self.waitingImageView.hidden = YES;
            }
            else
            {
                self.headImageView.hidden = YES;
                self.waitingImageView.hidden = NO;
            }
            
            [self startIndicatorAnimation];
//            self.arrowImage.alpha = 0.0;
            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
