//
//  SWFeedLikeMemberView.m
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedLikeMemberView.h"

@implementation SWFeedLikeMemberView{
  UIImageView *_iconLike;
  UILabel     *_lblCount;
  UIImageView *_iconMore;
  UIButton    *_iconUser[7];
  NSArray     *_feedLikes;
}
- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    _iconLike = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, 16.5, 18)];
    _iconLike.image = [UIImage imageNamed:@"home_icon_like"];
    [self addSubview:_iconLike];
    
    _lblCount = [UILabel initWithFrame:CGRectMake(_iconLike.right+5, _iconLike.top, 0, 0)
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0x4d6c8e]
                                  text:@""
                         textAlignment:NSTextAlignmentLeft
                                  font:[UIFont systemFontOfSize:14]];
    [self addSubview:_lblCount];
    
    _iconMore = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-15-33, _iconLike.top, 23.7, 18)];
    _iconMore.image = [UIImage imageNamed:@"home_btn_wholike_other"];
    _iconMore.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_iconMore];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [self addGestureRecognizer:_tapGesture];
    
    for (NSInteger i=0; i<7; i++) {
      _iconUser[i] = [[UIButton alloc] initWithFrame:CGRectMake(64+30*i, 0, 22, 22)];
      _iconUser[i].customImageView = [[UIImageView alloc] initWithFrame:_iconUser[i].bounds];
      _iconUser[i].customImageView.layer.masksToBounds = YES;
      _iconUser[i].customImageView.layer.cornerRadius  = _iconUser[i].customImageView.width/2.0;
      _iconUser[i].customImageView.backgroundColor = [UIColor whiteColor];
      [_iconUser[i] addSubview:_iconUser[i].customImageView];
      _iconUser[i].tag = i;
      [self addSubview:_iconUser[i]];
    }
  }
  return self;
}

- (void)refreshWithFeedLikes:(NSArray *)feedLikes count:(NSInteger)count{
  self.hidden      = !feedLikes.count;
  _iconMore.hidden = feedLikes.count<7;
  _lblCount.text = [@(count) stringValue];
  [_lblCount sizeToFit];
  _feedLikes = feedLikes;
  self.frame = feedLikes.count>0?CGRectMake(0, 0, UIScreenWidth, 25):CGRectZero;
  
  for (NSInteger i=0; i<7; i++) {
    SWFeedLikeItem *likeItem = [feedLikes safeObjectAtIndex:i];
    if ([likeItem isKindOfClass:[SWFeedLikeItem class]]) {
      _iconUser[i].hidden = NO;
      [_iconUser[i].customImageView sd_setImageWithURL:[NSURL URLWithString:[likeItem.user.picUrl stringByAppendingString:@"-avatar66"]] placeholderImage:nil];
      [_iconUser[i] addTarget:self action:@selector(onUserClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else{
      _iconUser[i].hidden = YES;
    }
  }
}

- (void)onTapped:(UITapGestureRecognizer *)gesture{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedLikeMemberViewDidPressMore:)]) {
    [self.delegate feedLikeMemberViewDidPressMore:self];
  }
}

- (void)onUserClicked:(UIButton *)button{
  SWFeedLikeItem *likeItem = [_feedLikes safeObjectAtIndex:button.tag];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedLikeMemberViewDidPressUser:)]
      &&[likeItem isKindOfClass:[SWFeedLikeItem class]]) {
    [self.delegate feedLikeMemberViewDidPressUser:likeItem.user];
  }
}
@end
