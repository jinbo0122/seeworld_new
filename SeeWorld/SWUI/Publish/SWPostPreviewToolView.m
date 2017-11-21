//
//  SWPostPreviewToolView.m
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostPreviewToolView.h"
#import "SCFilter.h"
#define FILTER_COUNT 7
@implementation SWPostPreviewToolView{
  UIButton *_btnBack;
  UIScrollView *_scrollView;
  UIButton  *_btnFilters[FILTER_COUNT];
  NSArray   *_filters;
  NSArray   *_filterConfigs;
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor blackColor];
    _btnEdit = [[UIButton alloc] initWithFrame:CGRectMake((self.width-65)/2.0, 17, 65, 65)];
    [_btnEdit setImage:[UIImage imageNamed:@"edit_camera"] forState:UIControlStateNormal];
    [self addSubview:_btnEdit];
    
    
    _btnFilter = [[UIButton alloc] initWithFrame:CGRectMake((_btnEdit.left-65)/2.0, _btnEdit.top, 65, 65)];
    [self addSubview:_btnFilter];
    _btnFilter.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_btnFilter.width-38)/2.0, 10, 38, 38)];
    _btnFilter.customImageView.image = [UIImage imageNamed:@"Filter_camera"];
    [_btnFilter addSubview:_btnFilter.customImageView];
    _btnFilter.lblCustom = [UILabel initWithFrame:CGRectMake(0, _btnFilter.customImageView.bottom+5, _btnFilter.width, 15)
                                          bgColor:[UIColor clearColor]
                                        textColor:[UIColor whiteColor]
                                             text:@"濾鏡"
                                    textAlignment:NSTextAlignmentCenter
                                             font:[UIFont systemFontOfSize:15]];
    [_btnFilter addSubview:_btnFilter.lblCustom];
    
    [_btnFilter addTarget:self action:@selector(onFilterClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 50)];
    [_btnBack setImage:[UIImage imageNamed:@"filter_back"] forState:UIControlStateNormal];
    [self addSubview:_btnBack];
    _btnBack.hidden = YES;
    [_btnBack addTarget:self action:@selector(onBackClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_btnBack.right, 0, self.width-_btnBack.right, self.height)];
    [self addSubview:_scrollView];
    
    SCFilter *emptyFilter = [SCFilter emptyFilter];
    emptyFilter.name = @"#nofilter";
    _filters  = @[emptyFilter,
                  [SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"],
                  [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"],
                  [SCFilter filterWithCIFilterName:@"CIPhotoEffectTransfer"],
                  [SCFilter filterWithCIFilterName:@"CIPhotoEffectProcess"],
                  [SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"],
                  [SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"]];
    _filterConfigs = @[@{@"name":@"无",@"pic":@"img_xiaosp_wu.jpg"},
                            @{@"name":@"琥珀",@"pic":@"img_xiaosp_hupo.jpg"},
                            @{@"name":@"恋樱",@"pic":@"img_xiaosp_lianying.jpg"},
                            @{@"name":@"流年",@"pic":@"img_xiaosp_liunian.jpg"},
                            @{@"name":@"幽兰",@"pic":@"img_xiaosp_youlan.jpg"},
                            @{@"name":@"浣纱",@"pic":@"img_xiaosp_huansha.jpg"},
                            @{@"name":@"黑白",@"pic":@"img_xiaosp_heibai.jpg"}];
    for (NSInteger i=0; i<FILTER_COUNT; i++) {
      _btnFilters[i] = [[UIButton alloc] initWithFrame:CGRectMake(65*i, 0, 50, _scrollView.height)];
      _btnFilters[i].customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
      _btnFilters[i].customImageView.layer.masksToBounds = YES;
      _btnFilters[i].customImageView.layer.cornerRadius = 2;
      _btnFilters[i].customImageView.clipsToBounds = YES;
      _btnFilters[i].customImageView.backgroundColor = [UIColor whiteColor];
      _btnFilters[i].customImageView.image = [UIImage imageNamed:[_filterConfigs[i] safeStringObjectForKey:@"pic"]];
      [_btnFilters[i] addSubview:_btnFilters[i].customImageView];
      _btnFilters[i].tag = i;
      _btnFilters[i].lblCustom = [UILabel initWithFrame:CGRectMake(0, _btnFilters[i].customImageView.bottom+ 7.5, _btnFilters[i].width, 18.5)
                                                bgColor:[UIColor clearColor]
                                              textColor:[UIColor whiteColor]
                                                   text:[_filterConfigs[i] safeStringObjectForKey:@"name"]
                                          textAlignment:NSTextAlignmentCenter
                                                   font:[UIFont systemFontOfSize:13]];
      [_btnFilters[i] addSubview:_btnFilters[i].lblCustom];
      _btnFilters[i].customImageView.layer.borderColor   = [UIColor colorWithRGBHex:0x00cc55].CGColor;
      _btnFilters[i].customImageView.layer.borderWidth   = i==0?2:0;
      _btnFilters[i].tagString = @"filter";

      [_scrollView addSubview:_btnFilters[i]];
      
      [_btnFilters[i] addTarget:self action:@selector(onFilterClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    _scrollView.hidden = YES;
    _scrollView.contentSize = CGSizeMake(_btnFilters[FILTER_COUNT-1].right+10, _scrollView.height);
  }
  return self;
}

- (void)onBackClicked{
  _btnFilter.hidden = NO;
  _scrollView.hidden = _btnBack.hidden = YES;
}

- (void)onFilterClicked{
  _btnFilter.hidden = _btnEdit.hidden = YES;
  _btnBack.hidden = NO;
  _scrollView.hidden = NO;
}

- (void)onFilterClicked:(UIButton *)button{
  for (UIButton *button in [_scrollView subviews]) {
    if ([button isKindOfClass:[UIButton class]] && button.tagString.length>0) {
      button.customImageView.layer.borderWidth = 0;
      button.lblCustom.textColor = [UIColor colorWithRGBHex:0x7f7e80];
    }
  }
  
  button.customImageView.layer.borderWidth = 2.0;
  button.lblCustom.textColor = [UIColor colorWithRGBHex:0x00cc55];
  if (self.delegate && [self.delegate respondsToSelector:@selector(postPreviewDidUseFilter:)]) {
    [self.delegate postPreviewDidUseFilter:[_filters objectAtIndex:button.tag]];
  }
}

@end
