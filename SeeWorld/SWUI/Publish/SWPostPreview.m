//
//  SWPostPreview.m
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostPreview.h"
#import "SWAddTagViewVC.h"
#import "SWPostPreviewToolView.h"
@interface SWPostPreview()<WTTagViewDelegate,WTTagViewDataSouce,SWPostPreviewToolViewDelegate>
@property (nonatomic, assign)CGRect imageFrame;
@end

@implementation SWPostPreview{
  UILabel  *_lblAddTag;
  SWPostPreviewToolView *_toolView;
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    _tagView = [[WTTagView alloc] initWithFrame:CGRectMake(0, 20 + iOSNavHeight, UIScreenWidth, UIScreenWidth)];
    [self addSubview:_tagView];
    self.tagView.delegate = self;
    self.tagView.dataSource = self;
    self.tagView.backgroundColor = [UIColor blackColor];
    
    _lblAddTag = [UILabel initWithFrame:CGRectMake((self.width-130)/2.0, _tagView.bottom-20-36, 130, 36)
                                bgColor:[UIColor colorWithRGBHex:0x000000 alpha:0.7]
                              textColor:[UIColor colorWithRGBHex:0xffffff alpha:0.7]
                                   text:@"點擊圖片添加標籤"
                          textAlignment:NSTextAlignmentCenter
                                   font:[UIFont systemFontOfSize:13]];
    [self addSubview:_lblAddTag];
    _lblAddTag.layer.masksToBounds = YES;
    _lblAddTag.layer.cornerRadius = _lblAddTag.height/2.0;
    
    _toolView = [[SWPostPreviewToolView alloc] initWithFrame:CGRectMake(0, self.height-iphoneXBottomAreaHeight-100-iphoneXBottomAreaHeight,
                                                                        self.width, 100)];
    _toolView.btnEdit.hidden = YES;
    _toolView.btnFilter.left = (self.width-_toolView.btnFilter.width)/2.0;
    _toolView.delegate = self;
    [self addSubview:_toolView];
  }
  return self;
}

- (void)setImage:(UIImage *)image{
  _image = image;
  _tagView.backgroundImageView.image = image;
  
  CGFloat scale = [UIScreen mainScreen].scale;
  if (_image.size.width>_image.size.height) {
    CGFloat height = _image.size.height * UIScreenWidth/_image.size.width;
    self.tagView.height = height;
    self.tagView.top = iOSNavHeight + 20+(UIScreenWidth-height)/2.0;
    _imageFrame = CGRectMake(0, (UIScreenWidth-height)*scale/2.0,
                             self.tagView.width * scale, height * scale);
  }else if (_image.size.width<_image.size.height){
    CGFloat width = _image.size.width * UIScreenWidth/_image.size.height;
    self.tagView.width = width;
    self.tagView.left = (UIScreenWidth-width)/2.0;
    _imageFrame = CGRectMake((UIScreenWidth-width)*scale/2.0, 0,
                             width*scale, self.tagView.height*scale);
    
  }else{
    _imageFrame = CGRectMake(0, 0, self.tagView.width*scale, self.tagView.height*scale);
  }
}

- (NSMutableArray *)addedTags
{
  if (nil == _addedTags) {
    _addedTags = @[].mutableCopy;
  }
  return _addedTags;
}

- (NSArray *)tags{
  if (_addedTags.count==0) {
    return nil;
  }
  
  NSMutableArray *tags = [NSMutableArray array];
  for (int i = 0; i < _addedTags.count; i++){
    WTTag *tag = _addedTags[i];
    NSDictionary *coordDic = @{@"x":@(tag.tagCenterPointPercentage.x),@"y":@(tag.tagCenterPointPercentage.y),@"w":@(0),@"h":@(0)};
    NSDictionary *tagDic = @{@"tagId":@(i),
                             @"imageId":@(self.tag-1000),
                             @"tagName":tag.titleString,
                             @"direction":@(!tag.tagDirection),
                             @"coord":coordDic};
    
    [tags addObject:tagDic];
  }
  return tags;
}

#pragma mark - WTTagView DataSource

- (NSInteger)numberOfTagViewItemsInTagView:(WTTagView *)tagView
{
  return self.addedTags.count;
}

- (UIView<WTTagViewItemMethods> *)tagView:(WTTagView *)tagView tagViewItemAtIndex:(NSInteger)index
{
  WTTag *tag = self.addedTags[index];
  
  WTTagViewItem *tagViewItem = [[WTTagViewItem alloc] init];
  tagViewItem.titleText = tag.titleString;
  tagViewItem.tagViewItemDirection = tag.tagDirection;
  tagViewItem.centerPointPercentage = tag.tagCenterPointPercentage;
  return tagViewItem;
}

#pragma mark - WTTagView Delegate

- (void)tagView:(WTTagView *)tagView didTappedTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index{
//  __weak typeof(self)wSelf = self;
//  [[[SWAlertView alloc] initWithTitle:@"你確定要刪除標籤嗎"
//                           cancelText:SWStringCancel
//                          cancelBlock:^{
//
//                          } okText:SWStringOkay
//                              okBlock:^{
//                                [wSelf.addedTags removeObjectAtIndex:index];
//                                [wSelf.tagView reloadData];
//                                [wSelf.tagView makeTagItemsAnimated];
//                              }] show];
}

//editMode
- (void)tagView:(WTTagView *)tagView tagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem didChangedDirection:(WTTagViewItemDirection)tagViewItemDirection AtIndex:(NSInteger)index{
//  WTTag *misc = self.addedTags[index];
//  misc.tagDirection = tagViewItemDirection;
}

- (void)tagView:(WTTagView *)tagView didLongPressedTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index{
//  WTTag *misc = self.addedTags[index];
//  [tagViewItem reverseTagViewItemDirection];
//  misc.tagDirection = tagViewItem.tagViewItemDirection;
}

- (void)tagView:(WTTagView *)tagView didMoveTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index toNewPositonPercentage:(CGPoint)pointPercentage{
//  WTTag *misc = self.addedTags[index];
//  misc.tagCenterPointPercentage = pointPercentage;
}

- (void)tagView:(WTTagView *)tagView addNewTagViewItemTappedAtPosition:(CGPoint)ponit{
  if (self.delegate && [self.delegate respondsToSelector:@selector(postPreviewDidNeedAddTag:)]) {
    [self.delegate postPreviewDidNeedAddTag:self];
  }
}

#pragma mark Tool
- (void)postPreviewDidUseFilter:(SCFilter *)filter{
  CIImage *image = [filter imageByProcessingImage:[CIImage imageWithCGImage:_image.CGImage]];
  _tagView.backgroundImageView.image = [UIImage imageWithCIImage:image];
}
@end
