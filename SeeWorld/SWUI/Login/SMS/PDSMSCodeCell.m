//
//  PDSMSCodeCell.m
//  pandora
//
//  Created by Albert Lee on 10/13/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "PDSMSCodeCell.h"

@implementation PDSMSCodeCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.lblCountry = [UILabel initWithFrame:CGRectMake(15, 0, UIScreenWidth-120, 45)
                                                 bgColor:[UIColor clearColor]
                                               textColor:[UIColor colorWithRGBHex:0x4c4c4c]
                                                    text:@""
                                           textAlignment:NSTextAlignmentLeft
                                                    font:[UIFont systemFontOfSize:16]];
    self.lblCode    = [UILabel initWithFrame:CGRectMake(UIScreenWidth-125, 0, 100, 45)
                                                 bgColor:[UIColor clearColor]
                                               textColor:[UIColor colorWithRGBHex:0x88888c]
                                                    text:@""
                                           textAlignment:NSTextAlignmentRight
                                                    font:[UIFont systemFontOfSize:14]];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, UIScreenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithRGBHex:0xd2d1d5];
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:self.lblCountry];
    [self.contentView addSubview:self.lblCode];
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

-(void)refreshSMSCodeCell:(NSDictionary *)source{
  self.lblCountry.text = [source safeStringObjectForKey:@"cn"];
  self.lblCode.text = [NSString stringWithFormat:@"+%@",[source safeObjectForKey:@"code"]];
}
@end
