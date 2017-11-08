
//
//  SWCommentTextField.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWCommentTextField.h"

@implementation SWCommentTextField
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = 4.0;
    self.layer.borderColor   = [UIColor colorWithRGBHex:0xeceff2].CGColor;
    self.layer.borderWidth   = 0.5;
    self.font = [UIFont systemFontOfSize:14];
    self.backgroundColor = [UIColor whiteColor];
    self.returnKeyType = UIReturnKeySend;
    self.placeholder = SWStringAddComment;
  }
  return self;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
  return CGRectMake(10, 0, self.width-20, self.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
  return CGRectMake(10, 0, self.width-20, self.height);
}

- (CGRect)borderRectForBounds:(CGRect)bounds{
  return CGRectMake(10, 0, self.width-20, self.height);
}
//- (CGRect)textRectForBounds:(CGRect)bounds{
//  return CGRectMake(10, 0, self.width-20, self.height);
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
