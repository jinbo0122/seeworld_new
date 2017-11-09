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
  _feedItem = feedItem;
  [self.tagView reloadData];
  __weak typeof(self)wSelf = self;
  [_tagView.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[feedItem.feed.picUrl stringByAppendingString:FEED_SMALL]]
                                  placeholderImage:nil
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           if (image.size.width>image.size.height) {
                                             CGFloat height = image.size.height * UIScreenWidth/image.size.width;
                                             wSelf.tagView.frame = CGRectMake(0, 0, wSelf.width, height);
                                           }else if (image.size.width<image.size.height){
                                             CGFloat width = image.size.width * UIScreenWidth/image.size.height;
                                             wSelf.tagView.frame = CGRectMake((wSelf.width-width)/2.0, 0, width, wSelf.height);
                                           }else{
                                             wSelf.tagView.frame = wSelf.bounds;
                                           }
                                           if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(feedImageViewDidNeedReloadCell:)]) {
                                             [wSelf.delegate feedImageViewDidNeedReloadCell:@(wSelf.tagView.height)];
                                           }
                                           [wSelf.tagView reloadData];
                                         }
   ];
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
