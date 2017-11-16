//
//  SWPostPhotoView.m
//  SeeWorld
//
//  Created by Albert Lee on 17/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostPhotoView.h"
#import <objc/runtime.h>
static char UIButtonUserProfilePhotoIndex;

@implementation UIButton (UserProfilePhotoList)
@dynamic photoIndex;
-(void)setPhotoIndex:(NSNumber *)photoIndex
{
  objc_setAssociatedObject(self, &UIButtonUserProfilePhotoIndex, photoIndex, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)photoIndex
{
  return objc_getAssociatedObject(self, &UIButtonUserProfilePhotoIndex);
}

@end

@implementation SWPostPhotoView{
  UIButton *_btnPhotos[10];
}
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    CGFloat space = 10;
    CGFloat photoWidth = (UIScreenWidth-space*5)/4.0;
    for (NSInteger i=0; i<3; i++) {
      for(NSInteger j=0; j<4; j++){
        if (i*4+j>8) {
          break;
        }
        NSInteger index = i*4+j;
        _btnPhotos[index] = [[UIButton alloc] initWithFrame:CGRectMake(space+(space+photoWidth)*j, space+(space+photoWidth)*i, photoWidth, photoWidth)];
        _btnPhotos[index].customImageView = [[UIImageView alloc] initWithFrame:_btnPhotos[index].bounds];
        _btnPhotos[index].customImageView.clipsToBounds = YES;
        _btnPhotos[index].customImageView.layer.masksToBounds = YES;
        _btnPhotos[index].customImageView.layer.borderColor = [UIColor colorWithRGBHex:0xc1c0c0].CGColor;
        [_btnPhotos[index] addSubview:_btnPhotos[index].customImageView];
        [self addSubview:_btnPhotos[index]];
      }
    }
  }
  return self;
}


- (void)refreshWithPhotos:(NSArray *)array{
  for (NSInteger i=0; i<3; i++) {
    for(NSInteger j=0; j<4; j++){
      if (i*4+j>8) {
        break;
      }
      NSInteger index = i*4+j;

      UIImage *image = [array safeObjectAtIndex:index];
      _btnPhotos[index].tagString = nil;
      _btnPhotos[index].tag = 0;
      _btnPhotos[index].hidden = NO;
      if (image) {
        [_btnPhotos[index].customImageView setImage:image];
        _btnPhotos[index].customImageView.contentMode = UIViewContentModeScaleAspectFill;
        _btnPhotos[index].customImageView.layer.borderWidth = 0;
      }else{
        [_btnPhotos[index].customImageView setImage:[UIImage imageNamed:@""]];
        _btnPhotos[index].customImageView.contentMode = UIViewContentModeCenter;
        _btnPhotos[index].customImageView.layer.borderWidth = 0.5;
        if (index>0 && !_btnPhotos[index-1].customImageView.image) {
          _btnPhotos[index].hidden = YES;
        }
        _btnPhotos[index].photoIndex = @0;
      }
      _btnPhotos[index].customImageView.backgroundColor = [UIColor colorWithRGBHex:0xdedede];
      _btnPhotos[index].tag = index;
      [_btnPhotos[index] addTarget:self action:@selector(onPhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
  }
}

- (void)onPhotoClicked:(UIButton *)button{
  
}

@end
