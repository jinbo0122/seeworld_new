//
//  AddTagCell.m
//  SeeWorld
//
//  Created by liufz on 15/9/12.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "AddTagCell.h"

@interface AddTagCell ()

@end

@implementation AddTagCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
    
    _hotTagLabelText = [UILabel initWithFrame:CGRectMake(15, 12, 0, 0)
                                      bgColor:[UIColor clearColor]
                                    textColor:[UIColor colorWithRGBHex:0x8B9CAD]
                                         text:@""
                                textAlignment:NSTextAlignmentLeft
                                         font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:_hotTagLabelText];
  }
  return self;
}

- (UIEdgeInsets)layoutMargins{
  return UIEdgeInsetsZero;
}
@end
