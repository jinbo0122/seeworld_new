
#import "TextFieldTableViewCell.h"

NSString *const kTextFieldCell = @"textfield";
@implementation TextFieldTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
