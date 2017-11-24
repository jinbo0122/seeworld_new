//
//  SWFeedUserInfoHeaderView.m
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedUserInfoHeaderView.h"
#import "UIButton+WebCache.h"
@implementation SWFeedUserInfoHeaderView{
  UIButton    *_btnAvatar;
  UILabel     *_lblName;
  UILabel     *_lblTime;
  UILabel     *_lblLocation;
}
- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    
    _btnAvatar = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
    _btnAvatar.layer.masksToBounds = YES;
    _btnAvatar.layer.cornerRadius  = _btnAvatar.width/2.0;
    [self addSubview:_btnAvatar];
    
    _lblName    = [UILabel initWithFrame:CGRectZero
                                 bgColor:[UIColor clearColor]
                               textColor:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]
                                    text:@""
                           textAlignment:NSTextAlignmentLeft
                                    font:[UIFont systemFontOfSize:16.2]];
    [self addSubview:_lblName];
    
    _lblTime    = [UILabel initWithFrame:CGRectZero
                                 bgColor:[UIColor clearColor]
                               textColor:[UIColor colorWithRGBHex:0x8A9BAC]
                                    text:@""
                           textAlignment:NSTextAlignmentLeft
                                    font:[UIFont systemFontOfSize:13]];
    [self addSubview:_lblTime];
    
    _lblLocation    = [UILabel initWithFrame:CGRectZero
                                 bgColor:[UIColor clearColor]
                               textColor:[UIColor colorWithRGBHex:0x8A9BAC]
                                    text:@""
                           textAlignment:NSTextAlignmentLeft
                                    font:[UIFont systemFontOfSize:13]];
    [self addSubview:_lblLocation];
    
    [_btnAvatar addTarget:self action:@selector(onAvatarClicked) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)onAvatarClicked{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedUserInfoHeaderViewDidPressAvatar:)]) {
    [self.delegate feedUserInfoHeaderViewDidPressAvatar:self];
  }
}


- (void)refresshWithFeed:(SWFeedItem *)feedItem{
  [_btnAvatar sd_setImageWithURL:[NSURL URLWithString:[feedItem.user.picUrl stringByAppendingString:@"-avatar120"]]
                        forState:UIControlStateNormal];
  if ([feedItem.feed.time doubleValue]/1000.0>[NSDate currentTime]) {
    _lblTime.text = @"剛剛";
  }else{
    _lblTime.text = [NSString time:[feedItem.feed.time doubleValue] format:MHPrettyDateShortRelativeTime];
  }
  
  CGSize timeSize = [_lblTime.text sizeWithAttributes:@{NSFontAttributeName:_lblTime.font}];
  _lblTime.frame = CGRectMake(self.width-15-timeSize.width, (self.height-timeSize.height)/2.0, timeSize.width, timeSize.height);
  
  _lblName.text = feedItem.user.name;
  CGRect nameRect = [_lblName.text boundingRectWithSize:CGSizeMake(_lblName.left-10-_btnAvatar.right-10, self.height)
                                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName:_lblName.font}
                                                context:nil];
  if (feedItem.feed.location.length) {
    _lblLocation.hidden = NO;
    _lblLocation.text = feedItem.feed.location;
    [_lblLocation sizeToFit];
    _lblName.frame = CGRectMake(_btnAvatar.right+10, 10, CGRectGetWidth(nameRect), CGRectGetHeight(nameRect));
    _lblLocation.frame = CGRectMake(_lblName.left, _lblName.bottom+2, _lblLocation.width, _lblLocation.height);
  }else{
    _lblLocation.hidden = YES;
    _lblName.frame = CGRectMake(_btnAvatar.right+10, (self.height-CGRectGetHeight(nameRect))/2.0, CGRectGetWidth(nameRect), CGRectGetHeight(nameRect));
  }
}
@end
