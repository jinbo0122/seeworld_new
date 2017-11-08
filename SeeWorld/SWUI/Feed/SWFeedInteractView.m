//
//  SWFeedInteractView.m
//  SeeWorld
//
//  Created by Albert Lee on 9/1/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedInteractView.h"
@implementation SWFeedInteractButton
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.customImageView];
    
    self.lblCustom = [UILabel initWithFrame:CGRectZero
                                    bgColor:[UIColor clearColor]
                                  textColor:[UIColor colorWithRGBHex:0xc4c4c8]
                                       text:@""
                              textAlignment:NSTextAlignmentLeft
                                       font:[UIFont systemFontOfSize:11]];
    [self addSubview:self.lblCustom];
  }
  return self;
}

- (void)setImageName:(NSString *)imageName title:(NSString *)title num:(NSInteger)num{
  self.lblCustom.text = [title stringByAppendingString:num>0?[[NSNumber numberWithInteger:num] stringValue]:@""];
  CGSize textSize = [self.lblCustom.text sizeWithAttributes:@{NSFontAttributeName:self.lblCustom.font}];
  UIImage *image = [UIImage imageNamed:imageName];
  self.lblCustom.textColor = [UIColor colorWithRGBHex:[imageName isEqualToString:@"home_btn_like_press"]?0x00f8ff:0xffffff];
  self.customImageView.image = image;
  self.customImageView.frame = CGRectMake((self.width-image.size.width- (textSize.width>0?(3+textSize.width):0))/2.0,
                                          (self.height-image.size.height)/2.0,
                                          image.size.width, image.size.height);
  
  self.lblCustom.frame = CGRectMake(self.customImageView.right+3, (self.height-textSize.height)/2.0,
                                    textSize.width, textSize.height);
}
@end

@implementation SWFeedInteractView{
}
- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithRGBHex:0x17293d];
    [self addSubview:[ALLineView lineWithFrame:CGRectMake(2.0*self.width/3.0, 12, 0.5, 14) colorHex:0x2a3847]];
    [self addSubview:[ALLineView lineWithFrame:CGRectMake(self.width/3.0, 12, 0.5, 14) colorHex:0x2a3847]];
    [self addSubview:[ALLineView lineWithFrame:CGRectMake(15, self.height-0.5, self.width-30, 0.5) colorHex:0x2a3847]];
    
    
    _btnLike = [[SWFeedInteractButton alloc] initWithFrame:CGRectMake(0, 0, self.width/3.0, self.height)];
    [self addSubview:_btnLike];
    
    _btnReply = [[SWFeedInteractButton alloc] initWithFrame:CGRectMake(self.width/3.0, 0, self.width/3.0, self.height)];
    [self addSubview:_btnReply];
    
    _btnShare = [[SWFeedInteractButton alloc] initWithFrame:CGRectMake(2*self.width/3.0, 0, self.width/3.0, self.height)];
    [self addSubview:_btnShare];
  }
  return self;
}

- (void)refreshWithFeed:(SWFeedItem *)feedItem{
  [_btnLike setImageName:[feedItem.isLiked boolValue]?@"home_btn_like_press":@"home_btn_like" title:@"" num:[feedItem.likeCount integerValue]];
  [_btnReply setImageName:@"home_btn_comment" title:@"" num:[feedItem.commentCount integerValue]];
  [_btnShare setImageName:@"home_share" title:@"" num:0];
}
@end
