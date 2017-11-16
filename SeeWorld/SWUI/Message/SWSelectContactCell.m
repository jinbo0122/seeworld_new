//
//  SWSelectContactCell.m
//  SeeWorld
//
//  Created by Albert Lee on 1/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWSelectContactCell.h"

@implementation SWSelectContactCell{
  UIImageView *_iconSelect;
  UIImageView *_iconAvatar;
  UILabel     *_lblName;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    
    _iconSelect = [[UIImageView alloc] initWithFrame:CGRectMake(30, 25, 20, 20)];
    _iconSelect.layer.masksToBounds = YES;
    _iconSelect.layer.cornerRadius  = 10.0;
    _iconSelect.layer.borderWidth   = 0.5;
    _iconSelect.layer.borderColor   = [[UIColor colorWithRGBHex:0xa2a2a2] CGColor];
    [self.contentView addSubview:_iconSelect];
    
    _iconAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(_iconSelect.right+10, 15, 40, 40)];
    _iconAvatar.layer.cornerRadius = 6.0;
    _iconAvatar.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconAvatar];
    
    _lblName = [UILabel initWithFrame:CGRectMake(_iconAvatar.right+10, 0, UIScreenWidth-_iconAvatar.right-10, 70)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_lblName];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (UIEdgeInsets)layoutMargins{
  return UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)refreshUser:(SWFeedUserItem *)item selected:(NSArray *)selectedContacts{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  [_iconAvatar sd_setImageWithURL:[NSURL URLWithString:item.picUrl]];
  _lblName.text = item.name;
  
  BOOL selected = NO;
  for (SWFeedUserItem *user in selectedContacts) {
    if ([user.uId isEqualToNumber:item.uId]) {
      selected = YES;
      break;
    }
  }
  _iconSelect.backgroundColor = [UIColor colorWithRGBHex:selected?0xa2a2a2:0xffffff];
}

@end
