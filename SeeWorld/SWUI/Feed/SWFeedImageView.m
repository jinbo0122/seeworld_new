//
//  SWFeedImageView.m
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedImageView.h"
#import "SWFeedTagButton.h"
#import "WTTag.h"
#import "WTTagViewItem.h"
#import "SWFeedLinkView.h"
#import "UIButton+WebCache.h"
@interface SWFeedImageView()<WTTagViewDataSouce,WTTagViewDelegate>

@end

@implementation SWFeedImageView{
  UITapGestureRecognizer *_tapGesture;
  SWFeedItem             *_feedItem;
  SWFeedLinkView         *_linkView;
  
  UIButton               *_btnImage[9];
}
- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    self.userInteractionEnabled = YES;
    self.layer.masksToBounds = YES;
    self.backgroundColor     = [UIColor colorWithRGBHex:0xffffff];
    self.contentMode         = UIViewContentModeScaleAspectFit;
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTapped:)];
    [self addGestureRecognizer:_tapGesture];
    
    _tagView = [[WTTagView alloc] initWithFrame:self.bounds];
    _tagView.backgroundColor = [UIColor blackColor];
    _tagView.dataSource = self;
    _tagView.delegate = self;
    _tagView.viewMode = WTTagViewModePreview;
    [self addSubview:_tagView];
    
    _linkView = [[SWFeedLinkView alloc] initWithFrame:CGRectMake(12, 0, self.width-24, 62)];
    [self addSubview:_linkView];
    
    for (NSInteger i=0; i<9; i++) {
      _btnImage[i] = [[UIButton alloc] initWithFrame:CGRectZero];
      _btnImage[i].tag = i;
      [_btnImage[i] addTarget:self action:@selector(onImageClicked:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:_btnImage[i]];
    }
  }
  return self;
}

- (void)refreshWithFeed:(SWFeedItem *)feedItem{
  [self refreshWithFeed:feedItem showTag:YES];
}

- (void)refreshWithFeed:(SWFeedItem *)feedItem showTag:(BOOL)showTag{
  SWFeedType type = feedItem.feed.type;
  _feedItem = feedItem;
  if (type == SWFeedTypeLink || [feedItem.feed.content isEqualToString:@"http://www.qq.com"]) {
    _linkView.hidden = NO;
    [_linkView refreshWithTitle:feedItem.feed.link.title image:feedItem.feed.link.imageUrl];
    _tagView.hidden = YES;
    for (NSInteger i=0; i<9; i++) {
      _btnImage[i].hidden = YES;
    }
    self.height = _linkView.height;
  }else if (type == SWFeedTypeVideo ||
            (type == SWFeedTypeImage && feedItem.feed.photos.count==1)){
    _linkView.hidden = YES;
    SWFeedImageItem *item = [feedItem.feed.photos safeObjectAtIndex:0];
    if ([item isKindOfClass:[SWFeedImageItem class]]) {
      self.height = UIScreenWidth *item.height/item.width;
      
      _tagView.frame = self.bounds;
      [_tagView reloadData];
      
      [self.tagView reloadData];
      [_tagView.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[item.picUrl stringByAppendingString:FEED_SMALL]]];
      _tagView.hidden = NO;
    }else{
      _tagView.hidden = YES;
    }
    for (NSInteger i=0; i<9; i++) {
      _btnImage[i].hidden = YES;
    }
  }else if (type == SWFeedTypeImage){
    _linkView.hidden = YES;
    _tagView.hidden = YES;
    for (NSInteger i=0; i<9; i++) {
      if (i<feedItem.feed.photos.count) {
        _btnImage[i].hidden = NO;
        SWFeedImageItem *item = [feedItem.feed.photos safeObjectAtIndex:i];
        [_btnImage[i] sd_setImageWithURL:[NSURL URLWithString:item.picUrl] forState:UIControlStateNormal];
      }else{
        _btnImage[i].hidden = YES;
      }
    }
    
    if (feedItem.feed.photos.count == 2){
      self.height = UIScreenWidth/2.0;
      _btnImage[0].frame = CGRectMake(0, 0, self.height, self.height);
      _btnImage[1].frame = CGRectMake(_btnImage[0].right+0.5, 0, self.height, self.height);
    }else if (feedItem.feed.photos.count == 3){
      self.height = UIScreenWidth/3.0;
      _btnImage[0].frame = CGRectMake(0, 0, self.height, self.height);
      _btnImage[1].frame = CGRectMake(_btnImage[0].right, 0, self.height, self.height);
      _btnImage[2].frame = CGRectMake(_btnImage[1].right, 0, self.height, self.height);
    }else if (feedItem.feed.photos.count == 4||
              (feedItem.feed.photos.count>=7 && feedItem.feed.photos.count<=9)){
      self.height = UIScreenWidth;
      if (feedItem.feed.photos.count == 4) {
        _btnImage[0].frame = CGRectMake(0, 0, self.height/2.0, self.height/2.0);
        _btnImage[1].frame = CGRectMake(_btnImage[0].right, 0, self.height/2.0, self.height/2.0);
        _btnImage[2].frame = CGRectMake(0, _btnImage[0].bottom, self.height/2.0, self.height/2.0);
        _btnImage[3].frame = CGRectMake(_btnImage[2].right, _btnImage[0].bottom, self.height/2.0, self.height/2.0);
      }else{
        _btnImage[0].frame = CGRectMake(0, 0, self.height/2.0, self.height/2.0);
        _btnImage[1].frame = CGRectMake(_btnImage[0].right, 0, _btnImage[0].width, _btnImage[0].height);
        _btnImage[2].frame = CGRectMake(_btnImage[1].right, 0, _btnImage[0].width, _btnImage[0].height);
        _btnImage[3].frame = CGRectMake(0, _btnImage[0].bottom, self.height/2.0, self.height/2.0);
        _btnImage[4].frame = CGRectMake(_btnImage[0].right, _btnImage[0].bottom, _btnImage[0].width, _btnImage[0].height);
        _btnImage[5].frame = CGRectMake(_btnImage[1].right, _btnImage[0].bottom, _btnImage[0].width, _btnImage[0].height);
        _btnImage[6].frame = CGRectMake(0, _btnImage[3].bottom, self.height/2.0, self.height/2.0);
        _btnImage[7].frame = CGRectMake(_btnImage[0].right, _btnImage[3].bottom, _btnImage[0].width, _btnImage[0].height);
        _btnImage[8].frame = CGRectMake(_btnImage[1].right, _btnImage[3].bottom, _btnImage[0].width, _btnImage[0].height);
      }
      
    }else if (feedItem.feed.photos.count == 5||
              feedItem.feed.photos.count == 6){
      self.height = UIScreenWidth * 2.0/3.0;
      _btnImage[0].frame = CGRectMake(0, 0, self.height/2.0, self.height/2.0);
      _btnImage[1].frame = CGRectMake(_btnImage[0].right, 0, _btnImage[0].width, _btnImage[0].height);
      _btnImage[2].frame = CGRectMake(_btnImage[1].right, 0, _btnImage[0].width, _btnImage[0].height);
      _btnImage[3].frame = CGRectMake(0, _btnImage[0].bottom, self.height/2.0, self.height/2.0);
      _btnImage[4].frame = CGRectMake(_btnImage[0].right, _btnImage[0].bottom, _btnImage[0].width, _btnImage[0].height);
      _btnImage[5].frame = CGRectMake(_btnImage[1].right, _btnImage[0].bottom, _btnImage[0].width, _btnImage[0].height);
    }else{
      self.height = 0;
    }
  }
  self.backgroundColor = [UIColor whiteColor];
}

- (void)onImageClicked:(UIButton *)button{
  NSMutableArray *frames = [NSMutableArray array];
  for (NSInteger i=0; i<_feedItem.feed.photos.count; i++) {
    CGRect rect = [_btnImage[i] convertRect:_btnImage[i].bounds toView:[UIApplication sharedApplication].delegate.window];
    [frames addObject:[NSValue valueWithCGRect:rect]];
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedImageViewDidPressImage:buttonFrames:atIndex:)]) {
    [self.delegate feedImageViewDidPressImage:_feedItem buttonFrames:frames atIndex:button.tag];
  }
}

#pragma mark - WTTagView DataSource

- (NSInteger)numberOfTagViewItemsInTagView:(WTTagView *)tagView{
  SWFeedImageItem *item = [_feedItem.feed.photos safeObjectAtIndex:0];
  if ([item isKindOfClass:[SWFeedImageItem class]]) {
    return item.tags.count;
  }else{
    return 0;
  }
}

- (UIView<WTTagViewItemMethods> *)tagView:(WTTagView *)tagView tagViewItemAtIndex:(NSInteger)index{
  SWFeedImageItem *item = [_feedItem.feed.photos safeObjectAtIndex:0];
  if ([item isKindOfClass:[SWFeedImageItem class]]) {
    SWFeedTagItem *tag = item.tags[index];
    WTTagViewItem *tagViewItem = [[WTTagViewItem alloc] init];
    tagViewItem.titleText = tag.tagName;
    tagViewItem.tagViewItemDirection = 1- [tag.direction integerValue];
    tagViewItem.centerPointPercentage = CGPointMake([tag.coord.x floatValue], [tag.coord.y floatValue]);
    return tagViewItem;
  }else{
    return nil;
  }
}

- (void)tagView:(WTTagView *)tagView didTappedTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index{
  SWFeedImageItem *item = [_feedItem.feed.photos safeObjectAtIndex:0];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedImageViewDidPressTag:)]
      && [item isKindOfClass:[SWFeedImageItem class]]) {
    [self.delegate feedImageViewDidPressTag:item.tags[index]];
  }
}

- (void)onImageTapped:(UITapGestureRecognizer *)gesture{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedImageViewDidPressImage:)]) {
    [self.delegate feedImageViewDidPressImage:_feedItem];
  }
}
@end
