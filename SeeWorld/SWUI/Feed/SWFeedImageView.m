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
@interface SWFeedImageView()<WTTagViewDataSouce,WTTagViewDelegate>

@end

@implementation SWFeedImageView{
  UITapGestureRecognizer *_tapGesture;
  SWFeedItem             *_feedItem;
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
  }
  return self;
}

- (void)refreshWithFeed:(SWFeedItem *)feedItem{
  [self refreshWithFeed:feedItem showTag:YES];
}

- (void)refreshWithFeed:(SWFeedItem *)feedItem showTag:(BOOL)showTag{
  CGFloat imageHeight = [feedItem.feed.imageHeight integerValue];
  CGFloat imageWidth  = [feedItem.feed.imageWidth integerValue];
  
  self.height = UIScreenWidth *imageHeight/imageWidth;

  _tagView.frame = self.bounds;
  [_tagView reloadData];
  
  _feedItem = feedItem;
  [self.tagView reloadData];
  [_tagView.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[feedItem.feed.picUrl stringByAppendingString:FEED_SMALL]]];
  self.backgroundColor = [UIColor whiteColor];
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
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedImageViewDidPressTag:)]) {
    [self.delegate feedImageViewDidPressTag:_feedItem.feed.tags[index]];
  }
}

- (void)onImageTapped:(UITapGestureRecognizer *)gesture{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedImageViewDidPressImage:)]) {
    [self.delegate feedImageViewDidPressImage:_feedItem];
  }
}
@end
