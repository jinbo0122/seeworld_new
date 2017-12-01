//
//  SWFeedCommentView.m
//  SeeWorld
//
//  Created by Albert Lee on 6/6/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWFeedCommentView.h"
#import "TTTAttributedLabel.h"
@interface SWFeedCommentView()<TTTAttributedLabelDelegate>
@end
@implementation SWFeedCommentView{
  NSArray   *_comments;
  UILabel   *_lblComment;
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    _lblComment = [UILabel initWithFrame:CGRectZero
                                 bgColor:[UIColor clearColor]
                               textColor:[UIColor colorWithRGBHex:0x8A9BAC]
                                    text:@""
                           textAlignment:NSTextAlignmentLeft
                                    font:[UIFont systemFontOfSize:13]];
    [self addSubview:_lblComment];
    
    [self addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)refreshWithFeedComments:(NSArray *)comments{
  _comments = comments;
  _lblComment.text = [NSString stringWithFormat:@"%@條留言",@(comments.count)];
  _lblComment.hidden = comments.count==0;
  self.frame = CGRectMake(0, 0, UIScreenWidth, comments.count?19:0);
  _lblComment.frame = CGRectMake(12, 0, self.width-24, self.height);
}

- (void)onTap:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentViewDidPressUser:)]) {
    [self.delegate feedCommentViewDidPressUser:[(SWFeedCommentItem*)[_comments safeObjectAtIndex:button.tag] user]];
  }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithURL:(NSURL *)url
                atPoint:(CGPoint)point{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentViewDidPressUrl:)]) {
    [self.delegate feedCommentViewDidPressUrl:url];
  }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentViewDidPressUrl:)]) {
    [self.delegate feedCommentViewDidPressUrl:url];
  }
}

+ (CGFloat)heightByFeedComments:(NSArray *)comments{
  return comments.count?19:0;
}
@end
