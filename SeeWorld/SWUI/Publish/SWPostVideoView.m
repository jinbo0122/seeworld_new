//
//  SWPostVideoView.m
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostVideoView.h"

@implementation SWPostVideoView{
  UIImageView *_thumbImageView;
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    _thumbImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_thumbImageView];
    _thumbImageView.clipsToBounds = YES;
    
    self.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-40)/2.0, (self.height-40)/2.0, 40, 40)];
    [self addSubview:self.customImageView];
    self.customImageView.image = [UIImage imageNamed:@"PLAY"];
  }
  return self;
}

- (void)refreshWithAsset:(ALAsset *)asset thumb:(UIImage *)thumbImage{
  _thumbImageView.image = thumbImage;
}

@end
