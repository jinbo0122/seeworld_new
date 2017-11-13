//
//  SWHomeFeedRecommandView.m
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWHomeFeedRecommandView.h"
@interface SWHomeRecommandUserView : UIView
@property(nonatomic, strong)UIButton *btnAvatar;
@property(nonatomic, strong)UIButton *btnFollow;
@end

@implementation SWHomeRecommandUserView{
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0xfbfafa];
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRGBHex:0xe6e6e6].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 2.0;
    self.layer.shadowColor = [UIColor colorWithRGBHex:0xdbdbdb alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    
    _btnAvatar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 95)];
    [_btnAvatar setImage:nil text:@"" textColorHex:0x333333 fontSize:16];
    _btnAvatar.customImageView.frame = CGRectMake(37.5, 15, 35, 35);
    _btnAvatar.customImageView.layer.masksToBounds = YES;
    _btnAvatar.customImageView.layer.cornerRadius  = 17.5;

    [self addSubview:_btnAvatar];
    
    _btnFollow = [[UIButton alloc] initWithFrame:CGRectMake(20, _btnAvatar.bottom+2.5, self.width-40, 20)];
    _btnFollow.layer.masksToBounds = YES;
    _btnFollow.layer.cornerRadius = 1.0;
    _btnFollow.layer.borderColor = [UIColor colorWithRGBHex:0x55acef].CGColor;
    _btnFollow.layer.borderWidth = 1.0;
    [_btnFollow setTitle:@"追蹤" forState:UIControlStateNormal];
    [_btnFollow setTitleColor:[UIColor colorWithRGBHex:0x55acef] forState:UIControlStateNormal];
    [_btnFollow.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:_btnFollow];
  }
  return self;
}

- (void)refreshWithUser:(SWFeedUserItem *)user{
  [_btnAvatar.customImageView sd_setImageWithURL:[NSURL URLWithString:user.picUrl]];
  _btnAvatar.lblCustom.text = user.name;
  [_btnAvatar.lblCustom sizeToFit];
  _btnAvatar.lblCustom.width = MIN(_btnAvatar.width-10, _btnAvatar.lblCustom.width);
  _btnAvatar.lblCustom.frame = CGRectMake((_btnAvatar.width-_btnAvatar.lblCustom.width)/2.0,
                                          _btnAvatar.customImageView.bottom+10,
                                          _btnAvatar.lblCustom.width, _btnAvatar.lblCustom.height);
}
@end


@implementation SWHomeFeedRecommandView{
  UILabel                 *_lblTitle;
  UIView                  *_line;
  UIImageView             *_iconAvatar;
  UILabel                 *_lblName;
  UIButton                *_btnAdd;
  UITapGestureRecognizer  *_tapGesture;
  NSArray                 *_users;
  
  UIScrollView            *_scrollView;
  UIButton                *_btnMore;
}
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    
    _lblTitle = [UILabel initWithFrame:CGRectMake(14, 0, self.width-28, 40)
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]
                                  text:@"推薦關注"
                         textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    [self addSubview:_lblTitle];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _lblTitle.bottom, self.width, 134)];
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
  }
  return self;
}

- (void)refreshWithUsers:(NSArray *)users{
  _users = [users copy];

  for (UIView *view in [_scrollView subviews]) {
    if ([view isKindOfClass:[SWHomeRecommandUserView class]]) {
      [view removeFromSuperview];
    }
  }
  for (NSInteger i=0; i<users.count; i++) {
    SWFeedUserItem *user = [users safeObjectAtIndex:i];
    SWHomeRecommandUserView *userView = [[SWHomeRecommandUserView alloc] initWithFrame:CGRectMake(14 + 115 *i, 0, 110, 132.5)];
    [userView refreshWithUser:user];
    userView.btnAvatar.tag = userView.btnFollow.tag = i;
    [userView.btnAvatar addTarget:self action:@selector(onUserClicked:) forControlEvents:UIControlEventTouchUpInside];
    [userView.btnFollow addTarget:self action:@selector(onAddClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:userView];
  }
  
  [_btnMore removeFromSuperview];
  _btnMore = [[UIButton alloc] initWithFrame:CGRectMake(14 + users.count * 115 + 35, 0, 135, _scrollView.height)];
  [_btnMore setTitle:@"查看更多推薦好友" forState:UIControlStateNormal];
  [_btnMore setTitleColor:[UIColor colorWithRGBHex:0x55acef] forState:UIControlStateNormal];
  [_btnMore.titleLabel setFont:[UIFont systemFontOfSize:16]];
  [_btnMore addTarget:self action:@selector(onMoreClicked) forControlEvents:UIControlEventTouchUpInside];
  [_scrollView addSubview:_btnMore];
  _scrollView.contentSize = CGSizeMake(_btnMore.right + 35, _scrollView.height);
}

- (void)onAddClicked:(UIButton *)button{
  SWFeedUserItem *user = [_users safeObjectAtIndex:button.tag];
  [button removeFromSuperview];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedRecommandDidPressAdd:)]) {
    [self.delegate feedRecommandDidPressAdd:user];
  }
}

- (void)onUserClicked:(UIButton *)button{
  SWFeedUserItem *user = [_users safeObjectAtIndex:button.tag];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedRecommandDidPressUser:)]) {
    [self.delegate feedRecommandDidPressUser:user];
  }
}

- (void)onMoreClicked{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedRecommandDidPressMore:)]) {
    [self.delegate feedRecommandDidPressMore:self];
  }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
