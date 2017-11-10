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
  NSArray                 *_users;
}
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    
    _lblTitle = [UILabel initWithFrame:CGRectMake(14, 0, self.width-28, 40)
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0x191d28]
                                  text:@"推薦關注"
                         textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    [self addSubview:_lblTitle];
    
//    _iconAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 32, 32)];
//    _iconAvatar.layer.masksToBounds = YES;
//    _iconAvatar.layer.cornerRadius  = _iconAvatar.width/2.0;
//    _iconAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
//    _iconAvatar.layer.borderWidth = 1.0;
//    [self addSubview:_iconAvatar];
//
//    _lblName = [UILabel initWithFrame:CGRectMake(_iconAvatar.right+12, _iconAvatar.top, UIScreenWidth-_iconAvatar.right-22-121, _iconAvatar.height)
//                              bgColor:[UIColor clearColor]
//                            textColor:[UIColor colorWithRGBHex:0x333333]
//                                 text:@""
//                        textAlignment:NSTextAlignmentLeft
//                                 font:[UIFont systemFontOfSize:16]];
//    [self addSubview:_lblName];
  }
  return self;
}

- (void)refreshWithUsers:(NSArray *)users{
  _users = [users copy];
//  [_iconAvatar sd_setImageWithURL:[NSURL URLWithString:user.picUrl]];
//  _lblName.text = user.name;
}

- (void)onAddClicked:(UIButton *)button{
//  [_btnAdd setImage:nil forState:UIControlStateNormal];
//  if (self.delegate && [self.delegate respondsToSelector:@selector(feedRecommandDidPressAdd:)]) {
//    [self.delegate feedRecommandDidPressAdd:_user];
//  }
}

- (void)onUserClicked:(UITapGestureRecognizer *)gesture{
//  if (self.delegate && [self.delegate respondsToSelector:@selector(feedRecommandDidPressUser:)]) {
//    [self.delegate feedRecommandDidPressUser:_user];
//  }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
