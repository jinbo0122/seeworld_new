//
//  SWSettingCell.m
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWSettingCell.h"
#import "SWSetSecretAPI.h"
@implementation SWSettingCell{
  ALLineView *_divideLine;
  UIImageView *_avatarView;
  UILabel     *_lblName;
  UIButton    *_switch;
  UIView      *_dot;
  UILabel     *_lblTitle;
  UIImageView *_arrow;
  UILabel     *_lblContent;
  NSIndexPath *_indexPath;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 10, 70, 70)];
    _avatarView.layer.masksToBounds = YES;
    _avatarView.layer.cornerRadius = _avatarView.width/2.0;
    _avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarView.layer.borderWidth = 1.0;
    [self.contentView addSubview:_avatarView];
    _lblName = [UILabel initWithFrame:CGRectMake(_avatarView.right+20, 32, UIScreenWidth-_avatarView.width-40, 25)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor whiteColor]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:18]];
    [self.contentView addSubview:_lblName];
    
    _lblTitle = [UILabel initWithFrame:CGRectMake(16, 21, UIScreenWidth-32, 16)
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0xfbfcfc]
                                  text:@""
                         textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:_lblTitle];
    
    _lblContent = [UILabel initWithFrame:CGRectMake(UIScreenWidth-24-100, 21, 100, 16)
                                 bgColor:[UIColor clearColor]
                               textColor:[UIColor colorWithRGBHex:0xfbfcfc]
                                    text:@""
                           textAlignment:NSTextAlignmentRight
                                    font:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_lblContent];
    
    _switch = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-66, 7, 51, 31)];
    [self.contentView addSubview:_switch];
    _dot = [[UIView alloc] initWithFrame:CGRectMake(0, 3, 25, 25)];
    _dot.backgroundColor = [UIColor whiteColor];
    _dot.layer.masksToBounds = YES;_dot.layer.cornerRadius = _dot.width/2.0;
    [_switch addSubview:_dot];
    
    _dot.userInteractionEnabled = NO;
    
    [_switch addTarget:self action:@selector(onSwitchChanged) forControlEvents:UIControlEventTouchUpInside];
    
    _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-23-21, 21, 13, 21)];
    _arrow.image = [UIImage imageNamed:@"setting_btn_enter"];
    [self.contentView addSubview:_arrow];
  }
  return self;
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

- (void)refreshWithIndexPath:(NSIndexPath *)indexPath{
  self.contentView.backgroundColor = [UIColor colorWithRGBHex:indexPath.section==3?0x4a5b69:0x19415c];
  _indexPath = indexPath;
  if (indexPath.row>0) {
    [_divideLine removeFromSuperview];
    _divideLine = [ALLineView lineWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.5) colorHex:0x2a536e];
    [self.contentView addSubview:_divideLine];
  }
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  if (indexPath.section==0) {
    _avatarView.hidden = NO;
    _lblName.hidden = NO;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:[[SWConfigManager sharedInstance].user.picUrl stringByAppendingString:@"-avatar210"]]];
    _lblName.text = [SWConfigManager sharedInstance].user.name;
    _lblTitle.hidden = _lblContent.hidden = _switch.hidden = _arrow.hidden = YES;
  }else{
    _avatarView.hidden = YES;
    _lblName.hidden = YES;
    _lblTitle.hidden = NO;
    if (indexPath.section==1) {
      _switch.hidden = NO;
      _arrow.hidden = _lblContent.hidden = YES;
      if (indexPath.row==0) {
        _lblTitle.text = @"動態通知";
        _switch.tag = [[SWNoticeModel sharedInstance] pushOpenStatus];
      }else{
        _lblTitle.text = @"不公開賬號";
        _switch.tag = [[SWConfigManager sharedInstance].user.issecret boolValue];
      }
      [self switchUI];
    }else if (indexPath.section==2){
      _arrow.hidden = NO;
      _lblContent.hidden = _switch.hidden = YES;
      _lblTitle.text = indexPath.row==0?@"回報問題":@"關於SeeWorld+";
    }else{
      _lblContent.hidden = NO;
      _arrow.hidden = _switch.hidden = YES;
      _lblTitle.text = @"清除記錄";
      
      CGFloat size = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
      NSString *fileStr = [NSString stringWithFormat:@"%1.lfM", size];
      _lblContent.text = fileStr;
    }
    
  }
}

- (void)onSwitchChanged{
  _switch.tag = 1-_switch.tag;
  if (_indexPath.row==0) {
    [[SWNoticeModel sharedInstance] pushOpen:_switch.tag];
  }else{
    SWSetSecretAPI *api = [[SWSetSecretAPI alloc] init];
    api.isSecret = _switch.tag;
    BOOL isSecret = _switch.tag;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
      [SWConfigManager sharedInstance].user.issecret = isSecret?@1:@0;
    } failure:^(__kindof YTKBaseRequest *request) {
      
    }];
  }
  
  [self switchUI];
}

- (void)switchUI{
  [_switch setImage:[UIImage imageNamed:_switch.tag?@"chat_stting_bar_open":@"chat_stting_bar_close"]
           forState:UIControlStateNormal];
  _dot.left = _switch.tag?30:0.5;
}

@end
