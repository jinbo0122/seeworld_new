//
//  SWFeedLinkView.m
//  SeeWorld
//
//  Created by Albert Lee on 22/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWFeedLinkView.h"

@implementation SWFeedLinkView{
  UILabel *_lblTitle;
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0xf3f3f5];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 50, 50)];
    [self addSubview:_imageView];
    
    _lblTitle = [UILabel initWithFrame:CGRectMake(_imageView.right+6, 0, self.width-12-_imageView.right, self.height)
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0x191d28]
                                  text:@""
                         textAlignment:NSTextAlignmentLeft
                                  font:[UIFont systemFontOfSize:16] numberOfLines:2];
    [self addSubview:_lblTitle];
  }
  return self;
}

- (void)refreshWithTitle:(NSString *)title image:(NSString *)imageUrl{
  [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                placeholderImage:[UIImage imageNamed:@"link_default"]];
  _lblTitle.text = title;
}

@end
