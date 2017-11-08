#import <UIKit/UIKit.h>

extern NSString *const kTextFieldCell;
@interface TextFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *userNumTextField; //用户电话

@end
