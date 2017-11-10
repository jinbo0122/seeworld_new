//
//  SWFeedInteractCommentCell.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedInteractCommentCell.h"
#import "TTTAttributedLabel.h"
@interface SWFeedInteractCommentCell()<TTTAttributedLabelDelegate>

@end

@implementation SWFeedInteractCommentCell{
  UIImageView *_iconAvatar;
  UILabel     *_lblName;
  UILabel     *_lblReply;
  UILabel     *_lblReplyName;
  UILabel     *_lblTime;
  TTTAttributedLabel  *_lblComment;
  SWFeedCommentItem   *_commentItem;
  SWFeedUserItem      *_replyUser;
  
  UIView      *_bgView;
  UIButton    *_btnImage;
  UITapGestureRecognizer    *_tapGesture;
  UISwipeGestureRecognizer  *_swipeGesture;
  UISwipeGestureRecognizer  *_swipeRightGesture;
  
  UIButton *_btnDelete;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    [self.contentView addSubview:_bgView];
    
    _iconAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    _iconAvatar.layer.masksToBounds = YES;
    _iconAvatar.layer.cornerRadius  = _iconAvatar.width/2.0;
    _iconAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconAvatar.layer.borderWidth = 1.0;
    [_bgView addSubview:_iconAvatar];
    
    _lblName = [UILabel initWithFrame:CGRectZero
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x34414e]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont boldSystemFontOfSize:14]];
    [_bgView addSubview:_lblName];
    
    _lblReply = [UILabel initWithFrame:CGRectZero
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0x9b9b9b]
                                  text:@"回复"
                         textAlignment:NSTextAlignmentLeft
                                  font:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_lblReply];
    
    _lblReplyName = [UILabel initWithFrame:CGRectZero
                                   bgColor:[UIColor clearColor]
                                 textColor:[UIColor colorWithRGBHex:0x838cda]
                                      text:@""
                             textAlignment:NSTextAlignmentLeft
                                      font:[UIFont boldSystemFontOfSize:14]];
    [_bgView addSubview:_lblReplyName];
    
    _lblTime = [UILabel initWithFrame:CGRectZero
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x999999 alpha:0.8]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:12]];
    [_bgView addSubview:_lblTime];
    
    _lblComment = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _lblComment.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    _lblComment.delegate = self;
    _lblComment.textColor = [UIColor colorWithRGBHex:0x191d28];
    _lblComment.font = [UIFont systemFontOfSize:12];
    _lblComment.linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x00f8ff]};
    _lblComment.lineBreakMode = NSLineBreakByCharWrapping;
    _lblComment.numberOfLines = 0;
    [_bgView addSubview:_lblComment];
    
    UITapGestureRecognizer *avatarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserTapped)];
    UITapGestureRecognizer *nameGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserTapped)];
    UITapGestureRecognizer *replyGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onReplyUserTapped)];
    
    _iconAvatar.userInteractionEnabled = YES;
    _lblName.userInteractionEnabled = YES;
    _lblReplyName.userInteractionEnabled = YES;
    [_iconAvatar addGestureRecognizer:avatarGesture];
    [_lblName addGestureRecognizer:nameGesture];
    [_lblReplyName addGestureRecognizer:replyGesture];
    
    _btnImage = [[UIButton alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_btnImage];
    _btnImage.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_btnImage addSubview:_btnImage.customImageView];
    _btnImage.customImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_btnImage addTarget:self action:@selector(onImageClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCellTapped:)];
    [_bgView addGestureRecognizer:_tapGesture];
    
    _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onCellSwiped:)];
    _swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_bgView addGestureRecognizer:_swipeGesture];
    
    _swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onCellSwiped:)];
    _swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [_bgView addGestureRecognizer:_swipeRightGesture];
    
  }
  return self;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithURL:(NSURL *)url
                atPoint:(CGPoint)point{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractCommentCellDidPressUrl:)]) {
    [self.delegate feedInteractCommentCellDidPressUrl:url];
  }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractCommentCellDidPressUrl:)]) {
    [self.delegate feedInteractCommentCellDidPressUrl:url];
  }
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins{
  return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)refreshComment:(SWFeedCommentItem *)commentItem{
  _commentItem = commentItem;
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  [_iconAvatar sd_setImageWithURL:[NSURL URLWithString:[commentItem.user.picUrl stringByAppendingString:@"-avatar120"]]];
  _lblName.text = commentItem.user.name;
  
  CGSize nameSize = [_lblName.text sizeWithAttributes:@{NSFontAttributeName:_lblName.font}
                                    constrainedToSize:CGSizeMake(UIScreenWidth-75, 19.5)];
  _lblName.frame = CGRectMake(_iconAvatar.right+10, 16, nameSize.width, nameSize.height);
  
  _lblTime.text = [NSString time:[commentItem.time doubleValue] format:MHPrettyDateShortRelativeTime];
  [_lblTime sizeToFit];
  
  BOOL isReply = [[[commentItem.text safeJsonDicFromJsonString] safeNumberObjectForKey:@"isReply"] boolValue];
  if (isReply) {
    _lblReply.hidden = NO;
    _lblReplyName.hidden = NO;
    
    CGSize replySize = [_lblReply.text sizeWithAttributes:@{NSFontAttributeName:_lblReply.font}];
    _lblReply.frame = CGRectMake(_lblName.right+5, _lblName.top, replySize.width, replySize.height);
    
    _replyUser = [SWFeedUserItem feedUserItemByDic:[[commentItem.text safeJsonDicFromJsonString] safeDicObjectForKey:@"replyUser"]];
    _lblReplyName.text = _replyUser.name;
    CGRect replyNameRect = [_lblReplyName.text boundingRectWithSize:CGSizeMake(UIScreenWidth-230, 19.5)
                                                            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                         attributes:@{NSFontAttributeName:_lblReplyName.font}
                                                            context:nil];
    _lblReplyName.frame = CGRectMake(_lblReply.right+5, _lblName.top, replyNameRect.size.width, replyNameRect.size.height);
    
  }else{
    _lblReply.hidden = YES;
    _lblReplyName.hidden = YES;
  }
  
  BOOL isImage = [[[commentItem.text safeJsonDicFromJsonString] safeNumberObjectForKey:@"isImage"] boolValue];
  if (isImage) {
    [_btnImage.customImageView sd_setImageWithURL:[NSURL URLWithString:[[commentItem.text safeJsonDicFromJsonString] safeStringObjectForKey:@"text"]]];
    CGSize imageSize = [SWFeedInteractCommentCell imageSizeByCommentItem:commentItem];
    _btnImage.frame = CGRectMake(_lblName.left, _lblName.bottom+6.5, imageSize.width, imageSize.height);
    _btnImage.customImageView.frame = _btnImage.bounds;
    _lblComment.hidden = YES;
    _btnImage.hidden = NO;
    _lblTime.frame = CGRectMake(_lblName.left, _btnImage.bottom+7, _lblTime.width, _lblTime.height);
    _bgView.frame = CGRectMake(0, 0, self.contentView.width, [SWFeedInteractCommentCell heightOfComment:commentItem]);
  }else{
    NSString *comment = [[commentItem.text safeJsonDicFromJsonString] safeStringObjectForKey:@"text"];
    NSAttributedString *content = [[NSAttributedString alloc] initWithString:comment
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                               NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x191d28]}];
    CGSize contentSize = [TTTAttributedLabel sizeThatFitsAttributedString:content
                                                          withConstraints:CGSizeMake(UIScreenWidth-75, 1000)
                                                   limitedToNumberOfLines:50];
    [_lblComment setText:content];
    _lblComment.frame = CGRectMake(_lblName.left, _lblName.bottom+5, contentSize.width, contentSize.height);
    _lblComment.hidden = NO;
    _btnImage.hidden = YES;
    _lblTime.frame = CGRectMake(_lblName.left, _lblComment.bottom+7, _lblTime.width, _lblTime.height);
    _bgView.frame = CGRectMake(0, 0, self.contentView.width, [SWFeedInteractCommentCell heightOfComment:commentItem]);
  }
  
  
  
  if (_btnDelete && _btnDelete.left==0) {
    __weak typeof(_btnDelete)btnDelete = _btnDelete;
    [UIView animateWithDuration:0.2
                     animations:^{
                       btnDelete.alpha = 0;
                     } completion:^(BOOL finished) {
                       btnDelete.alpha = 1;
                       btnDelete.left = UIScreenWidth;
                     }];
  }
  

}

- (void)onImageClicked{
  CGRect rect = [_btnImage convertRect:_btnImage.bounds toView:[UIApplication sharedApplication].delegate.window];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractCommentCellDidPressImage:rect:)]) {
    [self.delegate feedInteractCommentCellDidPressImage:[[_commentItem.text safeJsonDicFromJsonString] safeStringObjectForKey:@"text"]
                                                   rect:rect];
  }
}

+ (CGSize)imageSizeByCommentItem:(SWFeedCommentItem *)commentItem{
  NSDictionary *info = [commentItem.text safeJsonDicFromJsonString];
  CGFloat width = [[info safeNumberObjectForKey:@"width"] doubleValue];
  CGFloat height = [[info safeNumberObjectForKey:@"height"] doubleValue];
  CGSize size;
  if (width<=290) {
    if (height<=217) {
      size = CGSizeMake(width, height);
    }else{
      size = CGSizeMake(217*width/height, 217);
    }
  }else{
    if (width>=height) {
      size = CGSizeMake(290, 290*height/width);
    }else{
      size = CGSizeMake(217*width/height, 217);
    }
  }
  //  size = CGSizeMake(MIN(290, size.width), MIN(217, size.height));
  return size;
}

+ (CGFloat)heightOfComment:(SWFeedCommentItem *)commentItem{
  BOOL isImage = [[[commentItem.text safeJsonDicFromJsonString] safeNumberObjectForKey:@"isImage"] boolValue];
  if (isImage) {
    CGSize imageSize = [SWFeedInteractCommentCell imageSizeByCommentItem:commentItem];
    return 48+MAX(12, imageSize.height)+24;
  }else{
    NSString *comment = [[commentItem.text safeJsonDicFromJsonString] safeStringObjectForKey:@"text"];
    CGSize commentSize = [comment sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                   constrainedToSize:CGSizeMake(UIScreenWidth-75, 1000)];
    return 48+MAX(12, commentSize.height)+24;
  }
}


- (void)onUserTapped{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractCommentCellDidNeedEnterUser:)]) {
    [self.delegate feedInteractCommentCellDidNeedEnterUser:_commentItem.user];
  }
}

- (void)onReplyUserTapped{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractCommentCellDidNeedEnterUser:)]) {
    [self.delegate feedInteractCommentCellDidNeedEnterUser:_replyUser];
  }
}

- (void)onCellTapped:(UITapGestureRecognizer*)gesture{
  CGPoint location = [gesture locationInView:_lblComment];
  TTTAttributedLabelLink *link = [_lblComment linkAtPoint:location];
  if (link) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractCommentCellDidPressUrl:)]) {
      [self.delegate feedInteractCommentCellDidPressUrl:link.result.URL];
    }
  }else{
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractCommentCellDidPressed:)]) {
      [self.delegate feedInteractCommentCellDidPressed:_commentItem];
    }
  }
}

- (void)onCellSwiped:(UISwipeGestureRecognizer *)gesture{
  if ([gesture isEqual:_swipeGesture]) {
    if (gesture.state == UIGestureRecognizerStateEnded) {
      if (_btnDelete && _btnDelete.left==0) {
        __weak typeof(_btnDelete)btnDelete = _btnDelete;
        [UIView animateWithDuration:0.2
                         animations:^{
                           btnDelete.left = -UIScreenWidth;
                         } completion:^(BOOL finished) {
                           btnDelete.left = UIScreenWidth;
                         }];
      }else{
        [self showDeleteButton];
      }
    }
  }else{
    if (gesture.state == UIGestureRecognizerStateEnded) {
      if (_btnDelete && _btnDelete.left==0) {
        __weak typeof(_btnDelete)btnDelete = _btnDelete;
        [UIView animateWithDuration:0.2
                         animations:^{
                           btnDelete.left = UIScreenWidth;
                         }];
      }
    }
  }
  
}

- (void)showDeleteButton{
  if ([_commentItem.user.uId isEqualToNumber:@0]||
      [[_commentItem.user.uId stringValue] isEqualToString:[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"]]||
      [_commentItem.user.relation integerValue]==SWUserRelationTypeSelf||
      ([(SWFeedInteractVC*)self.delegate isMyPic])){
    if (!_btnDelete) {
      _btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth, 0, UIScreenWidth, _bgView.height)];
      [_btnDelete setBackgroundColor:[UIColor colorWithRGBHex:0x000000 alpha:0.8]];
      [_btnDelete setImage:[UIImage imageNamed:@"comment_list_btn_delete"] forState:UIControlStateNormal];
      [_bgView addSubview:_btnDelete];
      [_btnDelete addTarget:self action:@selector(onDeleteClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    __weak typeof(_btnDelete)btnDelete = _btnDelete;
    [UIView animateWithDuration:0.2
                     animations:^{
                       btnDelete.left = 0;
                     }];
  }
}

- (void)onDeleteClicked{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractCommentCellDidSwiped:)]) {
    [self.delegate feedInteractCommentCellDidSwiped:_commentItem];
  }
}
@end
