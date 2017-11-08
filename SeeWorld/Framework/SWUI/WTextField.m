
#import "WTextField.h"

@implementation WTextField

- (void)awakeFromNib{
  [super awakeFromNib];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , _textInsetPoint.x , _textInsetPoint.y );
}

// 控制文本的位置，左右缩 20
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , _editingInsetPoint.x , _editingInsetPoint.y );
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)showClearButtonWithImage:(NSString *)imageName
{
    
}

@end
