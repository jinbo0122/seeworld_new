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
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
    
    _iconSelect = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 20, 20)];
    _iconSelect.layer.masksToBounds = YES;
    _iconSelect.layer.cornerRadius  = 10.0;
    _iconSelect.layer.borderWidth   = 0.5;
    _iconSelect.layer.borderColor   = [[UIColor colorWithRGBHex:0xa2a2a2] CGColor];
    [self.contentView addSubview:_iconSelect];
    
    _iconAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(_iconSelect.right+15, 10, 40, 40)];
    _iconAvatar.layer.cornerRadius = _iconAvatar.width/2.0;
    _iconAvatar.layer.masksToBounds = YES;
    _iconAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconAvatar.layer.borderWidth = 1.0;
    [self.contentView addSubview:_iconAvatar];
    
    _lblName = [UILabel initWithFrame:CGRectMake(_iconAvatar.right+10, 0, UIScreenWidth-120, 60)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x838cda]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_lblName];
    
    _btnChat = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-55, 20, 30, 30)];
    [_btnChat setImage:[UIImage imageNamed:@"chat_btn_chat"] forState:UIControlStateNormal];
    [self.contentView addSubview:_btnChat];
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
  
  _iconSelect.image = [UIImage imageNamed:selected?@"chat_btn_select":@""];
}

@end
