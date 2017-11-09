//
//  SWExploreVC.m
//  SeeWorld
//
//  Created by Albert Lee on 9/9/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWExploreVC.h"
#import "SWExploreModel.h"
#import "SWExploreSegView.h"
#import "SWSearchVC.h"
#import "SWExploreFeedItemView.h"
#import "SWTagFeedsVC.h"
#define MOVE_DISTANCE 150.0
@interface SWExploreVC ()<SWExploreSegViewDelegate,SWExploreModelDelegate,
SWExploreFeedItemViewDelegate>
@property(nonatomic, strong)SWExploreModel *model;
@property(nonatomic, strong)SWExploreSegView *titleView;
@property(nonatomic, strong)SWExploreFeedItemView *itemA;
@property(nonatomic, strong)SWExploreFeedItemView *itemB;
@property(nonatomic, strong)SWExploreFeedItemView *itemC;
@property(nonatomic, strong)NSArray                 *itemFrames;
@property(nonatomic, strong)UIPanGestureRecognizer  *panGesture;
@property(nonatomic, strong)UIView                  *failView;
@property(nonatomic, strong)UIButton                *btnReload;


@property(nonatomic, strong)UIView                *actionView;
@property(nonatomic, strong)UIButton              *btnLike;
@property(nonatomic, strong)UIButton              *btnDislike;
@property(nonatomic, strong)UIButton              *btnComment;
@property(nonatomic, strong)MBProgressHUD         *hud;
@end

@implementation SWExploreVC

- (id)init{
  if (self = [super init]) {
    self.model = [[SWExploreModel alloc] init];
    self.model.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self uiInitialize];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark Custom
- (void)uiInitialize{
  self.titleView = [[SWExploreSegView alloc] initWithFrame:CGRectMake(0, iOSNavHeight, UIScreenWidth, 38)
                                                     items:@[@"",@""]
                                                    images:@[@"explore_btn_find",@"explore_btn_locad"]];
  self.titleView.delegate = self;
  self.titleView.selectedIndex = 0;
  [self.view addSubview:self.titleView];
  
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"探索" color:[UIColor colorWithRGBHex:0x191d28]];
//  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"explore_btn_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                                                            style:UIBarButtonItemStylePlain
//                                                                           target:self action:@selector(onSearchClicked:)];
  CGFloat itemStartY  = is35InchDevice?(-18):(is4InchDevice?(-10):0);
  CGFloat itemOffsetY = is35InchDevice?(-2):(is4InchDevice?(-2):0);
  
  CGFloat itemWidth = UIScreenWidth-40;
  CGFloat itemHeight = itemWidth*0.85 + 57;
  self.itemFrames = @[[NSValue valueWithCGRect:CGRectMake(20,iOSNavHeight+self.titleView.height + 25 +itemStartY, itemWidth, itemHeight)],
                      [NSValue valueWithCGRect:CGRectMake(20,iOSNavHeight+self.titleView.height + 30 +itemStartY+itemOffsetY,
                                                          itemWidth,itemHeight)],
                      [NSValue valueWithCGRect:CGRectMake(20,iOSNavHeight+self.titleView.height + 35 +itemStartY+itemOffsetY*2,
                                                          itemWidth, itemHeight)]];
  
  
  self.itemC = [[SWExploreFeedItemView alloc] initWithFrame:[[self.itemFrames safeObjectAtIndex:2] CGRectValue]];
  [self.view addSubview:self.itemC];
  
  self.itemC.top = CGRectGetMinY([[self.itemFrames safeObjectAtIndex:2] CGRectValue]);
  
  self.itemB = [[SWExploreFeedItemView alloc] initWithFrame:[[self.itemFrames safeObjectAtIndex:1] CGRectValue]];
  [self.view addSubview:self.itemB];
  
  self.itemB.top = CGRectGetMinY([[self.itemFrames safeObjectAtIndex:1] CGRectValue]);
  
  self.itemA = [[SWExploreFeedItemView alloc] initWithFrame:[[self.itemFrames safeObjectAtIndex:0] CGRectValue]];
  [self.view addSubview:self.itemA];
  
  
  self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onItemPanGesture:)];
  [self.view addGestureRecognizer:self.panGesture];
  [self itemDelegate];
  
  CGFloat actionStartY  = is35InchDevice?(-15):(is4InchDevice?(-25):0);
  self.actionView = [[UIView alloc] initWithFrame:CGRectMake(0, _itemC.bottom+26+actionStartY, self.view.width, 65)];
  [self.view addSubview:self.actionView];
  
  _btnDislike = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
  [_btnDislike setImage: [UIImage imageNamed:@"explore_btn_dislike"] forState:UIControlStateNormal];
  [self.actionView addSubview:_btnDislike];
  
  _btnComment = [[UIButton alloc] initWithFrame:CGRectMake(self.view.centerX-40.5, 0, 81, 81)];
  [_btnComment setImage: [UIImage imageNamed:@"explore_slip_chat_default"] forState:UIControlStateNormal];
  [_btnComment setImage: [UIImage imageNamed:@"explore_slip_chat_press"] forState:UIControlStateHighlighted];
  [self.actionView addSubview:_btnComment];
  
  _btnLike = [[UIButton alloc] initWithFrame:CGRectMake(_btnComment.right+40, 20, 40, 40)];
  [_btnLike setImage: [UIImage imageNamed:@"explore_btn_like"] forState:UIControlStateNormal];
  [self.actionView addSubview:_btnLike];
  
  _btnDislike.right = _btnComment.left-40;
  
  [_btnDislike addTarget:self action:@selector(onDislikeClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_btnComment addTarget:self action:@selector(onCommentClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_btnLike    addTarget:self action:@selector(onLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.model getLatestFeeds];
  [self restartState];
}

- (void)onDislikeClicked:(UIButton*)button{
  [button setImage:[UIImage imageNamed:@"explore_btn_dislike"] forState:UIControlStateNormal];
  [self.model operateFeed:[self.model.feeds safeObjectAtIndex:self.model.currentIndex] like:NO];
  
  [self autoAnimateItemViewWithOpLike:NO];
}

- (void)onLikeClicked:(UIButton*)button{
  [button setImage:[UIImage imageNamed:@"explore_btn_like"] forState:UIControlStateNormal];
  [self.model operateFeed:[self.model.feeds safeObjectAtIndex:self.model.currentIndex] like:NO];
  [self autoAnimateItemViewWithOpLike:YES];
}

- (void)onCommentClicked:(UIButton*)button{
  SWFeedInteractVC *vc = [[SWFeedInteractVC alloc] init];
  vc.defaultIndex = SWFeedInteractIndexComments;
  vc.feedRow  = self.model.currentIndex;
  vc.isModal  = YES;
  vc.model.feedItem  = self.itemA.feedItem;
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)onRefreshClick{
  [self.model getLatestFeeds];
  [self restartState];
}

- (void)onReloadClick{
  [self.failView setHidden:YES];
  [self.model getLatestFeeds];
  [self restartState];
}

- (void)onSearchClicked:(UIBarButtonItem *)barButton{
  SWSearchVC *vc = [[SWSearchVC alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)onItemPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer{
  if (self.model.feeds.count==0) {
    return;
  }
  if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    [self.itemA setCenter:CGPointMake([self.itemA center].x + translation.x, [self.itemA center].y + translation.y)];
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    if (self.itemA.centerX<self.view.centerX) {
      CGFloat scale = - MIN((self.view.centerX-self.itemA.centerX)/MOVE_DISTANCE, 1)/2.0;
      self.itemA.iconDislike.alpha = 1.0;
      self.itemA.iconLike.alpha = 0;
      self.itemA.transform = CGAffineTransformRotate(CGAffineTransformIdentity, scale);
    }else if (self.itemA.centerX>self.view.centerX){
      CGFloat scale = MIN((self.itemA.centerX-self.view.centerX)/MOVE_DISTANCE, 1)/2.0;
      self.itemA.iconLike.alpha = 1.0;
      self.itemA.iconDislike.alpha = 0;
      self.itemA.transform = CGAffineTransformRotate(CGAffineTransformIdentity, scale);
    }else{
      self.itemA.iconLike.alpha = 0;
      self.itemA.iconDislike.alpha = 0;
    }
  }else{
    [self handleItem];
  }
}

#pragma mark Animations
- (void)itemDelegate{
  self.itemA.delegate = self;
  self.itemB.delegate = self;
  self.itemC.delegate = self;
}

- (void)handleItem{
  if (self.itemA.centerX < self.view.center.x-130 && self.itemA.iconDislike.alpha ==1.0) {
    [self.model operateFeed:self.itemA.feedItem like:NO];
    
    __weak typeof(self)wSelf = self;
    [self.itemA animateLeftWithCompletionBlock:^{
      [wSelf proceedToNextPhoto];
    }];
  }else if (self.itemA.centerX > self.view.center.x+130&& self.itemA.iconLike.alpha ==1.0){
    [self.model operateFeed:self.itemA.feedItem like:YES];
    __weak typeof(self)wSelf = self;
    [self.itemA animateRightWithCompletionBlock:^{
      [wSelf proceedToNextPhoto];
    }];
  }else{
    [self.itemA animateBackToRect:[[self.itemFrames safeObjectAtIndex:0] CGRectValue]];
  }
}

- (void)proceedToNextPhoto{
  if (self.model.currentIndex>self.model.feeds.count-3&&
      self.model.currentIndex<self.model.feeds.count&&
      self.model.currentIndex>0) {
    [self.model getNextPageFeeds];
  }
  
  if(self.model.currentIndex<self.model.feeds.count){
    SWExploreFeedItemView *tempItem = self.itemA;
    [tempItem resetImage];
    self.itemA = self.itemB;
    self.itemB = self.itemC;
    self.itemC = tempItem;
    [self itemDelegate];
    [self.view bringSubviewToFront:self.itemB];
    [self.view bringSubviewToFront:self.itemA];
    
    self.itemC.hidden = YES;
    __weak typeof(self)wSelf = self;
    [UIView
     animateWithDuration:0.3
     animations:^{
       wSelf.itemA.transform = CGAffineTransformIdentity;
       wSelf.itemB.transform = CGAffineTransformIdentity;
       wSelf.itemC.transform = CGAffineTransformIdentity;
       wSelf.itemA.frame = [[wSelf.itemFrames safeObjectAtIndex:0] CGRectValue];
       wSelf.itemB.frame = [[wSelf.itemFrames safeObjectAtIndex:1] CGRectValue];
       wSelf.itemC.frame = [[self.itemFrames safeObjectAtIndex:2] CGRectValue];
     } completion:^(BOOL finished) {
       wSelf.itemC.hidden = NO;
       
       wSelf.model.currentIndex ++;
       [wSelf refreshItemView];
       
     }];
    
  }else{
    [self finishState];
  }
}

- (void)autoAnimateItemViewWithOpLike:(BOOL)like{
  __weak typeof(self)wSelf = self;
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (like) {
      [self.itemA animateRightWithCompletionBlock:^{
        [wSelf proceedToNextPhoto];
      }];
    }else{
      [self.itemA animateLeftWithCompletionBlock:^{
        [wSelf proceedToNextPhoto];
      }];
    }
    
    wSelf.btnDislike.enabled = NO;
    wSelf.btnLike.enabled = NO;
    wSelf.btnComment.enabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      wSelf.btnDislike.enabled = YES;
      wSelf.btnComment.enabled = YES;
      wSelf.btnLike.enabled = YES;
      
      [wSelf.btnDislike setImage:[UIImage imageNamed:@"explore_btn_dislike"] forState:UIControlStateNormal];
      [wSelf.btnLike setImage:[UIImage imageNamed:@"explore_btn_like"] forState:UIControlStateNormal];
    });
  });
}

- (void)refreshItemView{
  if (self.model.currentIndex-1<self.model.feeds.count) {
    [self.itemA refreshReviewItemUI:[self.model.feeds safeObjectAtIndex:self.model.currentIndex-1]];
  }else{
    [self.itemA setHidden:YES];
  }
  
  if (self.model.currentIndex<self.model.feeds.count) {
    [self.itemB refreshReviewItemUI:[self.model.feeds safeObjectAtIndex:self.model.currentIndex]];
  }else{
    [self.itemB setHidden:YES];
  }
  
  if (self.model.currentIndex+1<self.model.feeds.count) {
    [self.itemC refreshReviewItemUI:[self.model.feeds safeObjectAtIndex:self.model.currentIndex+1]];
  }else{
    [self.itemC setHidden:YES];
  }
}

#pragma mark State Control

- (void)finishState{
  [self.itemA setHidden:YES];
  [self.itemB setHidden:YES];
  [self.itemC setHidden:YES];
  self.actionView.hidden = YES;
}

- (void)failState{
  if (!self.failView) {
    self.failView = [[UIView alloc] initWithFrame:self.itemA.frame];
    [self.view addSubview:self.failView];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((self.failView.width-108)/2.0, 76, 108, 83)];
    logo.image = [UIImage imageNamed:@"audit_icon_signal"];
    [self.failView addSubview:logo];
    
    self.btnReload = [[UIButton alloc] initWithFrame:CGRectMake((self.failView.width-128)/2.0, logo.bottom+53, 128, 36)];
    [self.btnReload setBackgroundColor:[UIColor colorWithRGBHex:0xd9d9d9]];
    [_btnReload setTitle:@"重新獲取照片" forState:UIControlStateNormal];
    [_btnReload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnReload.layer.masksToBounds = YES;
    _btnReload.layer.cornerRadius = 4.0;
    [self.failView addSubview:self.btnReload];
    
    [self.btnReload addTarget:self action:@selector(onReloadClick) forControlEvents:UIControlEventTouchUpInside];
  }
  self.failView.hidden = NO;
}

- (void)restartState{
  self.actionView.hidden = YES;
  self.itemA.hidden = YES;
  self.itemB.hidden = YES;
  self.itemC.hidden = YES;
  
  [self.hud removeFromSuperview];
  self.hud = [MBProgressHUD showLoadingInView:self.view];
  self.failView.hidden = YES;
}

#pragma mark Title View Delegate
- (void)feedInteractNavViewDidSelectIndex:(NSInteger)index{
  self.model.currentSegIndex = index;
  
  [self restartState];
}

#pragma mark Feed Item View Delegate
- (void)feedItemViewDidPressAvatar:(SWFeedUserItem *)userItem{
  [SWFeedUserItem pushUserVC:userItem nav:self.navigationController];
}

- (void)feedItemViewDidPressImage:(SWFeedItem *)feedItem rect:(CGRect)rect{
  ALPhotoListFullView *view = [[ALPhotoListFullView alloc] initWithFrames:@[[NSValue valueWithCGRect:rect]]
                                                                photoList:@[[feedItem.feed.picUrl stringByAppendingString:FEED_SMALL]]
                                                                    index:0];
  [view setFeedItem:feedItem];
  [[UIApplication sharedApplication].delegate.window addSubview:view];
}

- (void)feedItemViewDidPressTag:(SWFeedTagItem *)tagItem{
  SWTagFeedsVC *vc = [[SWTagFeedsVC alloc] init];
  vc.model.tagItem = tagItem;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Model delegate
- (void)exploreModelDidGetPhotos:(SWExploreModel *)model feedId:(NSNumber *)feedId{
  [self.hud hide:YES];
  
  if (model.feeds.count==0) {
    [self finishState];
    return;
  }
  
  if (feedId.integerValue==0) {
    self.model.currentIndex = 1;
  }
  [self refreshItemView];
  self.actionView.hidden = NO;
  
  if (model.feeds.count>2) {
    [self.itemC setHidden:NO];
  }
  if (model.feeds.count>1) {
    [self.itemB setHidden:NO];
  }
  [self.itemA setHidden:NO];
  self.failView.hidden = YES;
}

- (void)exploreModelDidFailGetPhotos:(SWExploreModel *)model{
  [self.itemA setHidden:YES];
  [self.itemB setHidden:YES];
  [self.itemC setHidden:YES];
  
  [self failState];
  
  [self.hud hide:YES];
}

- (void)exploreModelDidLetRefreshAvailable:(SWExploreModel *)model{
  
}

- (void)exploreModelDidOperateFeed:(SWFeedItem *)feedItem{
  
}
@end
