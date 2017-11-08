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
  }
  return self;
}
@end
