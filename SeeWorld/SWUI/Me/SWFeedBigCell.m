//
//  SWFeedBigCell.m
//  SeeWorld
//
//  Created by Albert Lee on 5/23/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWFeedBigCell.h"

@implementation SWFeedBigCell{
  UIButton    *_thumb;
  SWFeedItem  *_feed;
  NSInteger   _row;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    CGFloat width = UIScreenWidth;
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
    _thumb = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    _thumb.customImageView = [[UIImageView alloc] initWithFrame:_thumb.bounds];
    _thumb.customImageView.contentMode = UIViewContentModeScaleAspectFill;
    _thumb.customImageView.backgroundColor     = [UIColor colorWithRGBHex:0x1e252e];
    _thumb.clipsToBounds = YES;
    [_thumb addSubview:_thumb.customImageView];
    [self.contentView addSubview:_thumb];
    [_thumb addTarget:self action:@selector(onThumbClicked:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)onThumbClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedCellDidPressThumb:index:)]) {
    [self.delegate feedCellDidPressThumb:_feed index:_row];
  }
}

- (void)refreshThumbCell:(SWFeedItem *)feed row:(NSInteger)row{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  _row = row;
  _feed = feed;
  [_thumb.customImageView sd_setImageWithURL:[NSURL URLWithString:[feed.feed.picUrl stringByAppendingString:FEED_SMALL]]];
}

+ (CGFloat)height{
  return UIScreenWidth+1.5;
}
@end
