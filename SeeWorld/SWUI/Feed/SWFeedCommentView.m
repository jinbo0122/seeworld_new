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
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
  }
  return self;
}

- (void)refreshWithFeedComments:(NSArray *)comments{
  for (UIButton *button in self.subviews) {
    [button removeFromSuperview];
  }
  _comments = comments;
  CGFloat top = 0;
  for (NSInteger i=0; i<MIN(5, comments.count); i++) {
    SWFeedCommentItem *comment = [comments safeObjectAtIndex:i];
    NSString *name = comment.user.name;
    NSDictionary *info = [comment.text safeJsonDicFromJsonString];
    NSString *content = [[info safeNumberObjectForKey:@"isImage"] boolValue]?SWStringMsgPic:[info safeStringObjectForKey:@"text"];
    
    NSString *display = [NSString stringWithFormat:@"%@   %@",name,content];
    NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:display
                                                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    if ([content isEqualToString:SWStringMsgPic]) {
      [mut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0xffffff]
                  range:[display rangeOfString:content]];
    }else{
      [mut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0xffffff]
                  range:[display rangeOfString:content
                                       options:NSRegularExpressionSearch
                                         range:NSMakeRange(name.length, display.length-name.length)]];
    }
    [mut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0xacccf0] range:[display rangeOfString:name]];
    
    CGSize size = [display sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                            constrainedToSize:CGSizeMake(UIScreenWidth-40, 1000)];
    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    TTTAttributedLabel *lblCustom = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(20, top,size.width, size.height+10)];
    lblCustom.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    [lblCustom setText:mut];
    lblCustom.delegate = self;
    lblCustom.nameWidth = nameSize.width;
    lblCustom.linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x00f8ff]};
    lblCustom.lineBreakMode = NSLineBreakByCharWrapping;
    lblCustom.numberOfLines = 0;
    [self addSubview:lblCustom];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, top, nameSize.width, nameSize.height+10)];
    [self addSubview:button];
    button.tag = i;
    [button addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
    top+=(lblCustom.height);
  }
  if (comments.count>5) {
    UIButton *btnMore = [[UIButton alloc] initWithFrame:CGRectMake(20, top, 43, 28)];
    [btnMore setTitle:@"....更多" forState:UIControlStateNormal];
    [btnMore setTitleColor:[UIColor colorWithRGBHex:0x00f8ff] forState:UIControlStateNormal];
    [btnMore.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btnMore addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMore];
  }
  self.frame = CGRectMake(0, 0, UIScreenWidth, (comments.count>5?28:0)+top);
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
  CGFloat top = 0;
  for (NSInteger i=0; i<MIN(5, comments.count); i++) {
    SWFeedCommentItem *comment = [comments safeObjectAtIndex:i];
    NSString *name = comment.user.name;
    NSDictionary *info = [comment.text safeJsonDicFromJsonString];
    NSString *content = [[info safeNumberObjectForKey:@"isImage"] boolValue]?SWStringMsgPic:[info safeStringObjectForKey:@"text"];
    NSString *display = [NSString stringWithFormat:@"%@   %@",name,content];
    CGSize size = [display sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                            constrainedToSize:CGSizeMake(UIScreenWidth-40, 1000)];
    top+=(size.height+10);
  }
  return top+(comments.count>5?28:0);
}
@end
