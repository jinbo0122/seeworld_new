//
//  SWCommentInputView.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWCommentInputView.h"
@interface SWCommentInputView()
@end

@implementation SWCommentInputView
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0xe5e7eb];
    self.btnPhoto = [[UIButton alloc] initWithFrame:CGRectMake(9, 12, 21, 24)];
    [self.btnPhoto setImage:[UIImage imageNamed:@"comment_btn_camera"] forState:UIControlStateNormal];
    [self addSubview:self.btnPhoto];
    
    self.txtField = [[SWCommentTextField alloc] initWithFrame:CGRectMake(self.btnPhoto.right+8, 10, UIScreenWidth-51, 28)];
    [self addSubview:self.txtField];
    
    [self registerForKeyboardNotifications];
  }
  return self;
}

- (void)keyboardWasShow:(NSNotification *)notification{
  CGRect keyboardBounds;
  [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
  NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationBeginsFromCurrentState:YES];
  [UIView setAnimationDuration:[duration doubleValue]];
  [UIView setAnimationCurve:[curve intValue]];
  self.top = self.superview.height-keyboardBounds.size.height-self.height+iphoneXBottomAreaHeight;
  [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification{
  self.top = self.superview.height-self.height;
}

- (void)registerForKeyboardNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)unregisterForKeyboardNotifications{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
}

- (void)dealloc{
  [self unregisterForKeyboardNotifications];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setReplyUser:(SWFeedUserItem *)replyUser{
  _replyUser = replyUser;
  
  if (replyUser) {
    self.txtField.placeholder = [NSString stringWithFormat:@"%@ %@：",SWStringReply,replyUser.name];
  }else{
    self.txtField.placeholder = SWStringAddComment;
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
