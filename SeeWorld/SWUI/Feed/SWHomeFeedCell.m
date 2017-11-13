//
//  SWHomeFeedCell.m
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWHomeFeedCell.h"
#import "SWFeedUserInfoHeaderView.h"
#import "SWFeedLikeMemberView.h"
#import "SWFeedInteractView.h"
#import "SWFeedCommentView.h"
#import "TTTAttributedLabel.h"
#define ELEMENT_GAP_HEIGHT 10
@class SWFeedInfoItem;
@interface SWHomeFeedCell()<SWFeedLikeMemberViewDelegate,SWFeedImageViewDelegate,
SWFeedCommentViewDelegate,TTTAttributedLabelDelegate>
@property(nonatomic, strong)UIView *bgView;
@property(nonatomic, strong)SWFeedUserInfoHeaderView  *headerView;
@property(nonatomic, strong)SWFeedInteractView        *interactView;
@property(nonatomic, strong)TTTAttributedLabel        *lblContent;
@property(nonatomic, strong)SWFeedLikeMemberView      *likesView;
@property(nonatomic, strong)SWFeedCommentView         *commentView;

@property(nonatomic, strong)SWFeedItem                *feedItem;
@property(nonatomic, assign)NSInteger                 row;
@end

@implementation SWHomeFeedCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0xE8EDF3];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    [self.contentView addSubview:_bgView];
    
    _headerView = [[SWFeedUserInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 55)];
    [_bgView addSubview:_headerView];
  
    
    _lblContent = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _lblContent.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    _lblContent.delegate = self;
    _lblContent.textColor = [UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX];
    _lblContent.font = [UIFont systemFontOfSize:16];
    _lblContent.linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x00f8ff]};
    _lblContent.lineBreakMode = NSLineBreakByCharWrapping;
    _lblContent.numberOfLines = 0;
    [_bgView addSubview:_lblContent];
    
    _feedImageView = [[SWFeedImageView alloc] initWithFrame:CGRectMake(-0.5, _headerView.bottom, UIScreenWidth+1, UIScreenWidth)];
    [_bgView addSubview:_feedImageView];
    
    _interactView  = [[SWFeedInteractView alloc] initWithFrame:CGRectMake(0, _feedImageView.bottom, UIScreenWidth, 40)];
    [_bgView addSubview:_interactView];
    
    _likesView = [[SWFeedLikeMemberView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_likesView];
    
    _commentView = [[SWFeedCommentView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_commentView];
    
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)refreshHomeFeed:(SWFeedItem *)feed row:(NSInteger)row{
  self.selectionStyle = UITableViewCellSeparatorStyleNone;
  self.feedItem = feed;
  self.row      = row;
  _bgView.frame = CGRectMake(0, 7, UIScreenWidth, [SWHomeFeedCell heightByFeed:feed]-7);
  [_headerView refresshWithFeed:feed];
  [_headerView addTarget:self action:@selector(onHeaderClicked:) forControlEvents:UIControlEventTouchUpInside];

  NSAttributedString *content = [[NSAttributedString alloc] initWithString:feed.feed.content
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]}];
  CGSize contentSize = [TTTAttributedLabel sizeThatFitsAttributedString:content
                                                        withConstraints:CGSizeMake(UIScreenWidth-30, 1000)
                                                 limitedToNumberOfLines:50];
  [_lblContent setText:content];
  _lblContent.frame = feed.feed.content.length?CGRectMake(15, 55, contentSize.width, contentSize.height+5):CGRectZero;
  
  [_feedImageView refreshWithFeed:feed];
  _feedImageView.top = feed.feed.content.length?(_lblContent.bottom+10):55;
  _feedImageView.height = [feed.feed.imageHeight integerValue];
  _feedImageView.delegate = self;
  
  [_interactView refreshWithFeed:feed];
  [_interactView.btnLike addTarget:self action:@selector(onLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_interactView.btnReply addTarget:self action:@selector(onReplyClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_interactView.btnShare addTarget:self action:@selector(onShareClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  _interactView.top = _feedImageView.bottom;
  [_likesView refreshWithFeedLikes:feed.likes count:[feed.likeCount integerValue]];
  _likesView.delegate = self;
  _likesView.top = _interactView.bottom+ELEMENT_GAP_HEIGHT;
  [_commentView refreshWithFeedComments:feed.comments];
  _commentView.delegate = self;
  _commentView.top = MAX(_likesView.bottom+ELEMENT_GAP_HEIGHT, _interactView.bottom+ELEMENT_GAP_HEIGHT);
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithURL:(NSURL *)url
                atPoint:(CGPoint)point{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressUrl:row:)]) {
    [self.delegate homeFeedCellDidPressUrl:url row:self.row];
  }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressUrl:row:)]) {
    [self.delegate homeFeedCellDidPressUrl:url row:self.row];
  }
}


+ (CGFloat)heightByFeed:(SWFeedItem *)feed{
  NSAttributedString *content = [[NSAttributedString alloc] initWithString:feed.feed.content
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                                                             NSForegroundColorAttributeName:[UIColor whiteColor]}];

  CGSize contentSize = [TTTAttributedLabel sizeThatFitsAttributedString:content
                                                        withConstraints:CGSizeMake(UIScreenWidth-30, 1000)
                                                 limitedToNumberOfLines:50];
  NSInteger imageHeight = [feed.feed.imageHeight integerValue];
  NSLog(@"imageHeight:%@",@(imageHeight));
  CGFloat height = 7/*间隙*/+ 55/*头部*/ + imageHeight + 40 /*按钮*/;
  height+= (feed.feed.content.length>0?ELEMENT_GAP_HEIGHT:0);//文字空隙
  height+= (feed.feed.content.length>0?(contentSize.height+ELEMENT_GAP_HEIGHT):0);//文字高度
  height+= ((feed.likes.count>0&&feed.feed.content.length>0)?5:(feed.likes.count>0?ELEMENT_GAP_HEIGHT:0));//赞上部空隙
  height+= (feed.likes.count>0?25:0) /*赞成员*/;
  height+= ((feed.comments.count>0&&feed.feed.content.length>0&&feed.likes.count==0)?5:(feed.comments.count>0?ELEMENT_GAP_HEIGHT:0));//评论上部空隙
  height+= (feed.comments.count>0?[SWFeedCommentView heightByFeedComments:feed.comments]:0);//评论高度
  height+= ((feed.feed.content.length>0||feed.likes.count>0||feed.comments.count>0)?ELEMENT_GAP_HEIGHT:0);//底部空隙
  return height;
}

- (void)onHeaderClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressUser:)]) {
    [self.delegate homeFeedCellDidPressUser:self.feedItem.user];
  }
}

- (void)onLikeClicked:(UIButton *)button{
  __weak typeof(button)wButton = button;
  __weak typeof(self)wSelf = self;
  
  [UIView animateWithDuration:0.15
                   animations:^{
                     wButton.customImageView.transform = CGAffineTransformScale(wButton.transform, 1.5, 1.5);
                   } completion:^(BOOL finished) {
                     [UIView animateWithDuration:0.15
                                      animations:^{
                                        wButton.customImageView.transform = CGAffineTransformIdentity;
                                      }
                                      completion:^(BOOL finished) {
                                        if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(homeFeedCellDidPressLike:row:)]) {
                                          [wSelf.delegate homeFeedCellDidPressLike:wSelf.feedItem row:wSelf.row];
                                        }
                                      }];
                   }];
}

- (void)onReplyClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressReply:row:enableKeyboard:)]) {
    [self.delegate homeFeedCellDidPressReply:self.feedItem row:self.row enableKeyboard:YES];
  }
}

- (void)onShareClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressShare:row:)]) {
    [self.delegate homeFeedCellDidPressShare:self.feedItem row:self.row];
  }
}

- (void)feedLikeMemberViewDidPressMore:(SWFeedLikeMemberView *)view{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressReply:row:enableKeyboard:)]) {
    [self.delegate homeFeedCellDidPressReply:self.feedItem row:self.row enableKeyboard:NO];
  }
}

- (void)feedLikeMemberViewDidPressUser:(SWFeedUserItem *)userItem{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressLikeList:row:)]) {
    [self.delegate homeFeedCellDidPressLikeList:self.feedItem row:self.row];
  }
}

- (void)feedCommentViewDidPressUser:(SWFeedUserItem *)userItem{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressReply:row:enableKeyboard:)]) {
    [self.delegate homeFeedCellDidPressReply:self.feedItem row:self.row enableKeyboard:NO];
  }
}

- (void)feedCommentViewDidPressUrl:(NSURL *)url{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressUrl:row:)]) {
    [self.delegate homeFeedCellDidPressUrl:url row:self.row];
  }
}

- (void)feedImageViewDidPressTag:(SWFeedTagItem *)tagItem{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressTag:)]) {
    [self.delegate homeFeedCellDidPressTag:tagItem];
  }
}

- (void)feedImageViewDidPressImage:(SWFeedItem *)feedItem{
  CGRect rect = [_feedImageView convertRect:_feedImageView.bounds toView:[UIApplication sharedApplication].delegate.window];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidPressImage:rect:)]) {
    [self.delegate homeFeedCellDidPressImage:feedItem rect:rect];
  }
}

- (void)feedImageViewDidNeedReloadCell:(NSNumber *)imageHeight{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellDidNeedReload:row:)]) {
    [self.delegate homeFeedCellDidNeedReload:imageHeight row:self.row];
  }
}
@end
