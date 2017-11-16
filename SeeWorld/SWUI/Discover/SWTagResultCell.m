//
//  SWTagResultCell.m
//  SeeWorld
//
//  Created by Albert Lee on 9/11/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWTagResultCell.h"

@implementation SWTagResultCell{
  UILabel *_lblTag;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _lblTag = [UILabel initWithFrame:CGRectZero
                             bgColor:[UIColor clearColor]
                           textColor:[UIColor colorWithRGBHex:0x4a4a4a]
                                text:@""
                       textAlignment:NSTextAlignmentLeft
                                font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:_lblTag];
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
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

- (UIEdgeInsets)layoutMargins{
  return UIEdgeInsetsZero;
}


- (void)refreshTag:(SWFeedTagItem *)tagItem{
  _lblTag.text = [NSString stringWithFormat:@"# %@",tagItem.tagName];
  
  CGSize tagSize = [_lblTag.text sizeWithAttributes:@{NSFontAttributeName:_lblTag.font}];
  _lblTag.frame = CGRectMake(18, (38-tagSize.height)/2.0, tagSize.width, tagSize.height);
}
@end
