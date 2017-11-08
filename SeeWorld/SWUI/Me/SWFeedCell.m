//
//  SWFeedCell.m
//  SeeWorld
//
//  Created by Albert Lee on 5/23/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWFeedCell.h"

@implementation SWFeedCell{
  UIButton    *_thumb[2];
  NSArray     *_feeds;
  NSInteger   _row;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    CGFloat width = ((UIScreenWidth-2)/2.0);
    
    for (NSInteger i=0; i<2; i++) {
      _thumb[i] = [[UIButton alloc] initWithFrame:CGRectMake((width+1)*i, 0, width, width)];
      _thumb[i].customImageView = [[UIImageView alloc] initWithFrame:_thumb[i].bounds];
      _thumb[i].customImageView.contentMode = UIViewContentModeScaleAspectFill;
      _thumb[i].customImageView.backgroundColor     = [UIColor colorWithRGBHex:0x1e252e];
      _thumb[i].clipsToBounds = YES;
      [_thumb[i] addSubview:_thumb[i].customImageView];
      [self.contentView addSubview:_thumb[i]];
      _thumb[i].tag = i;
      [_thumb[i] addTarget:self action:@selector(onThumbClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
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
    [self.delegate feedCellDidPressThumb:[_feeds safeObjectAtIndex:button.tag] index:_row*2+button.tag];
  }
}

- (void)refreshThumbCell:(NSArray *)feeds row:(NSInteger)row{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  _row = row;
  _feeds = feeds;
  for (NSInteger i =0 ; i<2; i++) {
    SWFeedItem *feedItem = [feeds safeObjectAtIndex:i];
    if ([feedItem isKindOfClass:[SWFeedItem class]]) {
      [_thumb[i].customImageView sd_setImageWithURL:[NSURL URLWithString:[feedItem.feed.picUrl stringByAppendingString:FEED_SMALL]]];
      _thumb[i].hidden = NO;
    }else{
      _thumb[i].hidden = YES;
    }
  }
}

+ (CGFloat)height{
  return ((UIScreenWidth-2)/2.0)+1.5;
}
@end
