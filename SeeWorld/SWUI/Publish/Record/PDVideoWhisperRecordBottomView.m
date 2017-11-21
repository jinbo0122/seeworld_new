//
//  PDVideoWhisperRecordBottomView.m
//  pandora
//
//  Created by Albert Lee on 27/10/2016.
//  Copyright © 2016 Albert Lee. All rights reserved.
//

#import "PDVideoWhisperRecordBottomView.h"

@implementation PDVideoWhisperRecordBottomView

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor blackColor];
    
    CGFloat gap   = (self.width-175)/4.0;
    CGFloat initX = gap;
    _btnAlbum = [[UIButton alloc] initWithFrame:CGRectMake(initX, 35, 50, 65)];
    _btnAlbum.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _btnAlbum.width, 50)];
    [_btnAlbum.customImageView setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperAlbum]];
    [_btnAlbum addSubview:_btnAlbum.customImageView];
    [self addSubview:_btnAlbum];
    
    _btnDelete = [[UIButton alloc] initWithFrame:_btnAlbum.frame];
    _btnDelete.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _btnDelete.width, 50)];
    [_btnDelete.customImageView setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperDelete]];
    [_btnDelete addSubview:_btnDelete.customImageView];
    [self addSubview:_btnDelete];
    
    _btnRecord = [[UIButton alloc] initWithFrame:CGRectMake(_btnAlbum.right+gap, 20, 75, 75)];
    [self addSubview:_btnRecord];
    
    _btnFlipCamera = [[UIButton alloc] initWithFrame:CGRectMake(_btnRecord.right+gap, 35, 50, 65)];
    _btnFlipCamera.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _btnFlipCamera.width, 50)];
    [_btnFlipCamera.customImageView setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperFlipCamera]];
    [_btnFlipCamera addSubview:_btnFlipCamera.customImageView];
    [self addSubview:_btnFlipCamera];
    
    _btnOkay = [[UIButton alloc] initWithFrame:_btnFlipCamera.frame];
    _btnOkay.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _btnOkay.width, 50)];
    [_btnOkay.customImageView setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperOkayDisable]];
    [_btnOkay addSubview:_btnOkay.customImageView];
    [self addSubview:_btnOkay];
  }
  return self;
}
@end

