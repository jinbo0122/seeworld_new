//
//  ALPhotoListFullView.m
//  ALExtension
//
//  Created by Albert Lee on 7/13/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import "ALPhotoListFullView.h"
#import "SWFeedTagButton.h"
#import "WTTagView.h"
#import "WTTag.h"
#import "WTTagViewItem.h"
@interface ALZoomScrollView : UIScrollView
@property(nonatomic, strong)UIImageView *imageView;
@end

@implementation ALZoomScrollView

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.contentSize = self.bounds.size;
  }
  return self;
}
@end


@interface ALPhotoListFullView()<UIScrollViewDelegate,WTTagViewDataSouce,WTTagViewDelegate>
@property(nonatomic, strong)UIScrollView    *scrollView;
@property(nonatomic, strong)UIPageControl   *pageControl;
@property(nonatomic, strong)NSArray         *photoList;
@property(nonatomic, strong)UITapGestureRecognizer *tapGesture;

@property(nonatomic, strong)NSArray         *originFrames;
@property(nonatomic, strong)UIButton        *btnShowTag;
@property(nonatomic, assign)CGSize          imageSize;
@property(nonatomic, strong)WTTagView       *tagView;
@end

@implementation ALPhotoListFullView
- (id)initWithFrames:(NSArray *)frames photoList:(NSArray *)photoList index:(NSInteger)index{
  if(self = [super initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0x282828 alpha:0.7];
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(dismissFullScreen)];
    [self addGestureRecognizer:_tapGesture];
    
    self.originFrames = [frames copy];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.clipsToBounds = NO;
    _scrollView.decelerationRate = 0.0;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(UIScreenWidth*photoList.count, UIScreenHeight);
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.pagingEnabled = YES;
    [_scrollView setZoomScale:1.0];
    [self addSubview:_scrollView];
    [_scrollView setContentOffset:CGPointMake(UIScreenWidth*index, 0)];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height-50, UIScreenWidth, 50)];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRGBHex:0x323332];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRGBHex:0xffffff];
    _pageControl.numberOfPages = photoList.count;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPage = index;
    _pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:_pageControl];
    
    _tagView = [[WTTagView alloc] initWithFrame:self.bounds];
    _tagView.backgroundColor = [UIColor clearColor];
    _tagView.dataSource = self;
    _tagView.delegate = self;
    _tagView.viewMode = WTTagViewModePreview;
    [self addSubview:_tagView];
    _tagView.userInteractionEnabled = NO;
    
    for (NSInteger i=0; i<photoList.count; i++) {
      CGRect frame = [[self.originFrames safeObjectAtIndex:i] CGRectValue];
      ALZoomScrollView *zoomImageView = [[ALZoomScrollView alloc] initWithFrame:CGRectMake(UIScreenWidth*i, 0, UIScreenWidth, UIScreenHeight)];
      zoomImageView.imageView.frame = frame;
      zoomImageView.tag = i;
      zoomImageView.delegate = self;
      [self.scrollView addSubview:zoomImageView];
      __block MBProgressHUD *hud;
      zoomImageView.maximumZoomScale = 3.0;
      zoomImageView.minimumZoomScale = 1.0;
      zoomImageView.zoomScale = 1.0;
      __weak typeof(self)wSelf = self;
      [zoomImageView.imageView sd_setImageWithURL:[NSURL URLWithString:[photoList safeStringObjectAtIndex:i]]
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          [hud hide:YES];
                                          wSelf.imageSize = image.size;
                                          CGFloat height = image.size.height * UIScreenWidth/image.size.width;
                                          wSelf.tagView.frame = CGRectMake(0, (UIScreenHeight-height)/2.0, UIScreenWidth, height);
                                          [wSelf.tagView reloadData];
       }];
      __weak typeof(zoomImageView)wZoomImageView = zoomImageView;
      [UIView setAnimationsEnabled:YES];
      [UIView animateWithDuration:0.3 delay:0
                          options:UIViewAnimationOptionCurveEaseInOut
                       animations:^{
                         wZoomImageView.imageView.frame = zoomImageView.bounds;
                         wSelf.backgroundColor = [UIColor blackColor];
                       }
                       completion:^(BOOL finished) {
                         hud = [MBProgressHUD showLoadingInView:wZoomImageView.imageView];
                         if (wZoomImageView.imageView.image) {
                           [hud hide:NO];
                         }
                       }];
    }
  }
  return self;
}

- (void)setFeedItem:(SWFeedItem *)feedItem{
  _feedItem = feedItem;
  _btnShowTag = [[UIButton alloc] initWithFrame:CGRectMake((UIScreenWidth-60)/2.0, UIScreenHeight-80, 60, 60)];
  [_btnShowTag setImage:[UIImage imageNamed:@"home_btn_tag_off"] forState:UIControlStateNormal];
  [_btnShowTag addTarget:self action:@selector(onShowTagClicked:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_btnShowTag];
  
  [_tagView reloadData];
  _tagView.hidden = YES;
}

- (void)onShowTagClicked:(UIButton *)button{
  if (button.tag==0) {
    button.tag = 1;
    [_btnShowTag setImage:[UIImage imageNamed:@"home_btn_tag_on"] forState:UIControlStateNormal];
    _tagView.hidden = NO;
  }else{
    button.tag = 0;
    [_btnShowTag setImage:[UIImage imageNamed:@"home_btn_tag_off"] forState:UIControlStateNormal];
    _tagView.hidden = YES;
  }
}

#pragma mark - WTTagView DataSource

- (NSInteger)numberOfTagViewItemsInTagView:(WTTagView *)tagView
{
  return _feedItem.feed.tags.count;
}

- (UIView<WTTagViewItemMethods> *)tagView:(WTTagView *)tagView tagViewItemAtIndex:(NSInteger)index
{
  SWFeedTagItem *tag = _feedItem.feed.tags[index];
  WTTagViewItem *tagViewItem = [[WTTagViewItem alloc] init];
  tagViewItem.titleText = tag.tagName;
  tagViewItem.tagViewItemDirection = 1- [tag.direction integerValue];
  tagViewItem.centerPointPercentage = CGPointMake([tag.coord.x floatValue], [tag.coord.y floatValue]);
  return tagViewItem;
}

- (void)tagView:(WTTagView *)tagView didTappedTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"onHomeFeedTagClicked" object:nil userInfo:@{@"tag":_feedItem.feed.tags[index]}];
  
  for (SWFeedTagButton *button in [self subviews]) {
    if ([button isKindOfClass:[SWFeedTagButton class]]) {
      [button removeFromSuperview];
    }
  }
  
  [self dismissFullScreen];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
  _btnShowTag.tag = 1;
  [self onShowTagClicked:_btnShowTag];
  
  _btnShowTag.hidden = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
  if (scale==1) {
    _btnShowTag.hidden = NO;
  }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
  if ([scrollView isKindOfClass:[ALZoomScrollView class]]) {
    return [(ALZoomScrollView *)scrollView imageView];
  }
  return nil;
}

- (void)dismissFullScreen{
  __weak typeof(self)wSelf = self;
  NSInteger index = wSelf.scrollView.contentOffset.x/UIScreenWidth;
  for (ALZoomScrollView *zoomImageView in [self.scrollView subviews]) {
    if ([zoomImageView isKindOfClass:[ALZoomScrollView class]]&&
        zoomImageView.tag!=index) {
      [zoomImageView removeFromSuperview];
    }
  }
  CGRect frame = [[wSelf.originFrames safeObjectAtIndex:index] CGRectValue];
  [_btnShowTag removeFromSuperview];
  [UIView animateWithDuration:0.3
                        delay:0.0f
                      options:(UIViewAnimationOptionCurveEaseInOut)
                   animations:^{
                     wSelf.pageControl.alpha = 0;
                     wSelf.scrollView.delegate = nil;
                     for (ALZoomScrollView *zoomImageView in [self.scrollView subviews]) {
                       if ([zoomImageView isKindOfClass:[ALZoomScrollView class]]&&
                           zoomImageView.tag==index) {
                         zoomImageView.imageView.frame = frame;
                       }
                     }
                     wSelf.backgroundColor = [UIColor clearColor];
                   }
                   completion:^(BOOL finished){
                     [wSelf removeFromSuperview];
                   }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat pageWidth = self.scrollView.frame.size.width;
  float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
  NSInteger page = lround(fractionalPage);
  self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  if (![scrollView isKindOfClass:[ALZoomScrollView class]]) {
    for (ALZoomScrollView *zoomView in scrollView.subviews) {
      if ([zoomView isKindOfClass:[ALZoomScrollView class]]) {
        zoomView.zoomScale = 1.0;
      }
    }
  }
}
@end
