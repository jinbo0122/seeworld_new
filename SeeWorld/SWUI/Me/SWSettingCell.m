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
  UISwitch    *_switchControl;
  UILabel     *_lblTitle;
  UIImageView *_arrow;
  UILabel     *_lblContent;
  NSIndexPath *_indexPath;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];

    _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 10, 70, 70)];
    _avatarView.layer.masksToBounds = YES;
    _avatarView.layer.cornerRadius = _avatarView.width/2.0;
    _avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarView.layer.borderWidth = 1.0;
    [self.contentView addSubview:_avatarView];
    _lblName = [UILabel initWithFrame:CGRectMake(_avatarView.right+20, 32, UIScreenWidth-_avatarView.width-40, 25)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x191d28]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:18]];
    [self.contentView addSubview:_lblName];
    
    _lblTitle = [UILabel initWithFrame:CGRectMake(16, 21, UIScreenWidth-32, 16)
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0x191d28]
                                  text:@""
                         textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:17]];
    [self.contentView addSubview:_lblTitle];
    
    _lblContent = [UILabel initWithFrame:CGRectMake(UIScreenWidth-24-100, 21, 100, 16)
                                 bgColor:[UIColor clearColor]
                               textColor:[UIColor colorWithRGBHex:0x8a9bac]
                                    text:@""
                           textAlignment:NSTextAlignmentRight
                                    font:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_lblContent];
    
    _switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(UIScreenWidth-66, 7, 51, 31)];
    [self.contentView addSubview:_switchControl];
    
    [_switchControl addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
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
  return UIEdgeInsetsMake(0, 15, 0, 0);
}

- (void)refreshWithIndexPath:(NSIndexPath *)indexPath{
  _indexPath = indexPath;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  if (indexPath.section==0) {
    _avatarView.hidden = NO;
    _lblName.hidden = NO;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:[[SWConfigManager sharedInstance].user.picUrl stringByAppendingString:@"-avatar210"]]];
    _lblName.text = [SWConfigManager sharedInstance].user.name;
    _lblTitle.hidden = _lblContent.hidden = _switchControl.hidden = _arrow.hidden = YES;
  }else{
    _avatarView.hidden = YES;
    _lblName.hidden = YES;
    _lblTitle.hidden = NO;
    if (indexPath.section==1) {
      _switchControl.hidden = NO;
      _arrow.hidden = _lblContent.hidden = YES;
      if (indexPath.row==0) {
        _lblTitle.text = @"動態通知";
        _switchControl.on = [[SWNoticeModel sharedInstance] pushOpenStatus];
      }else{
        _lblTitle.text = @"不公開賬號";
        _switchControl.on = [[SWConfigManager sharedInstance].user.issecret boolValue];
      }
    }else if (indexPath.section==2){
      _arrow.hidden = NO;
      _lblContent.hidden = _switchControl.hidden = YES;
      _lblTitle.text = indexPath.row==0?@"回報問題":@"關於SeeWorld+";
    }else{
      _lblContent.hidden = NO;
      _arrow.hidden = _switchControl.hidden = YES;
      _lblTitle.text = @"清除記錄";
      
      CGFloat size = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
      NSString *fileStr = [NSString stringWithFormat:@"%1.lfM", size];
      _lblContent.text = fileStr;
    }
    
  }
}

- (void)onSwitchChanged:(UISwitch *)switchControl{
  if (_indexPath.row==0) {
    [[SWNoticeModel sharedInstance] pushOpen:_switchControl.on];
  }else{
    SWSetSecretAPI *api = [[SWSetSecretAPI alloc] init];
    api.isSecret = _switchControl.on;
    BOOL isSecret = _switchControl.on;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
      [SWConfigManager sharedInstance].user.issecret = isSecret?@1:@0;
    } failure:^(__kindof YTKBaseRequest *request) {
      
    }];
  }
}
@end
