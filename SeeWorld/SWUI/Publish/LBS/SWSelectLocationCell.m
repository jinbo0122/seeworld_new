//
//  SWSelectLocationCell.m
//  SeeWorld
//
//  Created by Albert Lee on 17/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWSelectLocationCell.h"

@implementation SWSelectLocationCell{
  UILabel *_lblTitle;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins{
  return UIEdgeInsetsZero;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _lblTitle = [UILabel initWithFrame:CGRectMake(15, 0, 0, 0)
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0x191d28]
                                  text:@""
                         textAlignment:NSTextAlignmentLeft
                                  font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:_lblTitle];
  }
  return self;
}

- (void)refreshWithRow:(NSInteger)row text:(NSString *)text{
  if (row == 0) {
    _lblTitle.text = @"不顯示位置";
    _lblTitle.textColor = [UIColor colorWithRGBHex:0x60729a];
  }else{
    _lblTitle.text = text;
    _lblTitle.textColor = [UIColor colorWithRGBHex:0x191d28];
  }
  [_lblTitle sizeToFit];
  _lblTitle.top = (50-_lblTitle.height)/2.0;

}

@end
