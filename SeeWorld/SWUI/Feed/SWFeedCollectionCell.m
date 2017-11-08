//
//  SWFeedCollectionCell.m
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedCollectionCell.h"
#import "SWFeedUserInfoHeaderView.h"
#import "SWFeedLikeMemberView.h"
#import "SWFeedInteractView.h"
#import "SWFeedCommentView.h"
#import "TTTAttributedLabel.h"
@interface SWFeedCollectionCell()<SWFeedLikeMemberViewDelegate,SWFeedImageViewDelegate,
SWFeedCommentViewDelegate,TTTAttributedLabelDelegate>
@property(nonatomic, strong)UIScrollView *bgView;
@property(nonatomic, strong)SWFeedUserInfoHeaderView  *headerView;
@property(nonatomic, strong)SWFeedInteractView        *interactView;
@property(nonatomic, strong)TTTAttributedLabel        *lblContent;
@property(nonatomic, strong)SWFeedLikeMemberView      *likesView;
@property(nonatomic, strong)SWFeedCommentView         *commentView;

@property(nonatomic, strong)SWFeedItem                *feedItem;
@property(nonatomic, assign)NSInteger                 row;
@end

@implementation SWFeedCollectionCell
- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    _bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, UIScreenWidth, UIScreenHeight-64)];
    _bgView.backgroundColor = [UIColor colorWithRGBHex:0x17293d];
    [self.contentView addSubview:_bgView];
    
    _headerView = [[SWFeedUserInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 55)];
    [_bgView addSubview:_headerView];
    
    _feedImageView = [[SWFeedImageView alloc] initWithFrame:CGRectMake(-0.5, _headerView.bottom, UIScreenWidth+1, UIScreenWidth)];
    [_bgView addSubview:_feedImageView];
    
    _interactView  = [[SWFeedInteractView alloc] initWithFrame:CGRectMake(0, _feedImageView.bottom, UIScreenWidth, 40)];
    [_bgView addSubview:_interactView];
    
    _lblContent = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _lblContent.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    _lblContent.delegate = self;
    _lblContent.textColor = [UIColor whiteColor];
    _lblContent.font = [UIFont systemFontOfSize:12];
    _lblContent.linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x00f8ff]};
    _lblContent.lineBreakMode = NSLineBreakByCharWrapping;
    _lblContent.numberOfLines = 0;
    [_bgView addSubview:_lblContent];
    
    _likesView = [[SWFeedLikeMemberView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_likesView];
    
    _commentView = [[SWFeedCommentView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_commentView];
  }
  return self;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithURL:(NSURL *)url
                atPoint:(CGPoint)point{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressUrl:row:)]) {
    [self.delegate feedDetailViewDidPressUrl:url row:self.row];
  }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressUrl:row:)]) {
    [self.delegate feedDetailViewDidPressUrl:url row:self.row];
  }
}

- (void)refreshFeedView:(SWFeedItem *)feed row:(NSInteger)row{
  self.feedItem = feed;
  self.row      = row;
  
  _bgView.contentSize = CGSizeMake(UIScreenWidth, [SWFeedCollectionCell heightByFeed:feed]);
  [_headerView refresshWithFeed:feed];
  [_feedImageView refreshWithFeed:feed];
  _feedImageView.delegate = self;
  
  [_interactView refreshWithFeed:feed];
  
  NSAttributedString *content = [[NSAttributedString alloc] initWithString:feed.feed.content
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                             NSForegroundColorAttributeName:[UIColor whiteColor]}];
  CGSize contentSize = [TTTAttributedLabel sizeThatFitsAttributedString:content
                                                        withConstraints:CGSizeMake(UIScreenWidth-30, 1000)
                                                 limitedToNumberOfLines:50];
  [_lblContent setText:content];
  _lblContent.frame = feed.feed.content.length?CGRectMake(15, _interactView.bottom+15, contentSize.width, contentSize.height+10):CGRectZero;
  
  [_headerView addTarget:self action:@selector(onHeaderClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_interactView.btnLike addTarget:self action:@selector(onLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_interactView.btnReply addTarget:self action:@selector(onReplyClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_interactView.btnShare addTarget:self action:@selector(onShareClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  [_likesView refreshWithFeedLikes:feed.likes count:[feed.likeCount integerValue]];
  _likesView.delegate = self;  
  _likesView.top = MAX(_interactView.bottom, _lblContent.bottom) +10;

  
  [_commentView refreshWithFeedComments:feed.comments];
  _commentView.delegate = self;
  _commentView.top = MAX(MAX(_likesView.bottom, _lblContent.bottom+15), _interactView.bottom+15);

}

+ (CGFloat)heightByFeed:(SWFeedItem *)feed{
  CGSize contentSize = [feed.feed.content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                           constrainedToSize:CGSizeMake(UIScreenWidth-30, 1000)];
  return 10/*间隙*/+ 55/*头部*/ + UIScreenWidth + 40 /*按钮*/
  + (feed.feed.content.length>0?(contentSize.height+15):0)
  + [SWFeedCommentView heightByFeedComments:feed.comments]+
  + (feed.likes.count>0?30:0) /*赞成员*/ + ((feed.feed.content.length>0||feed.likes.count>0||feed.comments.count>0)?15:0);
}

- (void)onHeaderClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressUser:)]) {
    [self.delegate feedDetailViewDidPressUser:self.feedItem.user];
  }
}

- (void)onLikeClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressLike:row:)]) {
    [self.delegate feedDetailViewDidPressLike:self.feedItem row:self.row];
  }
}

- (void)onReplyClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressReply:row:)]) {
    [self.delegate feedDetailViewDidPressReply:self.feedItem row:self.row];
  }
}

- (void)feedCommentViewDidPressUser:(SWFeedUserItem *)userItem{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressReply:row:)]) {
    [self.delegate feedDetailViewDidPressReply:self.feedItem row:self.row];
  }
}

- (void)feedCommentViewDidPressUrl:(NSURL *)url{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressUrl:row:)]) {
    [self.delegate feedDetailViewDidPressUrl:url row:self.row];
  }
}

- (void)onShareClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressShare:row:)]) {
    [self.delegate feedDetailViewDidPressShare:self.feedItem row:self.row];
  }
}

- (void)feedLikeMemberViewDidPressMore:(SWFeedLikeMemberView *)view{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressLikeList:row:)]) {
    [self.delegate feedDetailViewDidPressLikeList:self.feedItem row:self.row];
  }
}

- (void)feedLikeMemberViewDidPressUser:(SWFeedUserItem *)userItem{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressUser:)]) {
    [self.delegate feedDetailViewDidPressUser:userItem];
  }
}

- (void)feedImageViewDidPressTag:(SWFeedTagItem *)tagItem{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressTag:)]) {
    [self.delegate feedDetailViewDidPressTag:tagItem];
  }
}

- (void)feedImageViewDidPressImage:(SWFeedItem *)feedItem{
  CGRect rect = [_feedImageView convertRect:_feedImageView.bounds toView:[UIApplication sharedApplication].delegate.window];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressImage:rect:)]) {
    [self.delegate feedDetailViewDidPressImage:feedItem rect:rect];
  }
}
@end
