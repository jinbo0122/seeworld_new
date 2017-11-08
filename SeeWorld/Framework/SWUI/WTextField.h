
#import <UIKit/UIKit.h>

@interface WTextField : UITextField
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) CGPoint textInsetPoint;
@property (nonatomic,assign) CGPoint editingInsetPoint;

- (void)showClearButtonWithImage:(NSString *)imageName;

@end
