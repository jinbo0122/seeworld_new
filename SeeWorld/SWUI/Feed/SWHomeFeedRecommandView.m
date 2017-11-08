//
//  SWHomeFeedRecommandView.m
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWHomeFeedRecommandView.h"

@implementation SWHomeFeedRecommandView{
  UILabel                 *_lblTitle;
  UIView                  *_line;
  UIImageView             *_iconAvatar;
  UILabel                 *_lblName;
  UIButton                *_btnAdd;
  UITapGestureRecognizer  *_tapGesture;
  SWFeedUserItem          *_user;
}
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0x17293d];
    
    _lblTitle = [UILabel initWithFrame:CGRectMake(10, 0, self.width-20, 29)
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                  text:@"可能感興趣的人"
                         textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:12]];
    [self addSubview:_lblTitle];
    
    [self addSubview:[ALLineView lineWithFrame:CGRectMake(0, 29, self.width, 0.5) colorHex:0x35485d]];
    
    _btnHide = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20*2+12, 7+11*2)];
    _btnHide.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 9, 12, 7)];
    _btnHide.customImageView.image = [UIImage imageNamed:@"more"];
    [_btnHide addSubview:_btnHide.customImageView];
    [self addSubview:_btnHide];
    [_btnHide addTarget:self action:@selector(onHideClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _iconAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 32, 32)];
    _iconAvatar.layer.masksToBounds = YES;
    _iconAvatar.layer.cornerRadius  = _iconAvatar.width/2.0;
    _iconAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconAvatar.layer.borderWidth = 1.0;
    [self addSubview:_iconAvatar];
    
    _lblName = [UILabel initWithFrame:CGRectMake(_iconAvatar.right+12, _iconAvatar.top, UIScreenWidth-_iconAvatar.right-22-121, _iconAvatar.height)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0xffffff]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:16]];
    [self addSubview:_lblName];
    
    _btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-15-106, 43, 106, 28)];
    [_btnAdd setImage:[UIImage imageNamed:@"home_btn_add_friend"] forState:UIControlStateNormal];
    [self addSubview:_btnAdd];
    
    [_btnAdd addTarget:self action:@selector(onAddClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserClicked:)];
    [self addGestureRecognizer:_tapGesture];
  }
  return self;
}

- (void)refreshWithUser:(SWFeedUserItem *)user{
  _user = user;
  [_iconAvatar sd_setImageWithURL:[NSURL URLWithString:user.picUrl]];
  _lblName.text = user.name;
  [_btnAdd setImage:[UIImage imageNamed:@"home_btn_add_friend"] forState:UIControlStateNormal];
}

- (void)onAddClicked:(UIButton *)button{
  [_btnAdd setImage:nil forState:UIControlStateNormal];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedRecommandDidPressAdd:)]) {
    [self.delegate feedRecommandDidPressAdd:_user];
  }
}

- (void)onUserClicked:(UITapGestureRecognizer *)gesture{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedRecommandDidPressUser:)]) {
    [self.delegate feedRecommandDidPressUser:_user];
  }
}

- (void)onHideClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedRecommandDidPressHide:)]) {
    [self.delegate feedRecommandDidPressHide:self];
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
