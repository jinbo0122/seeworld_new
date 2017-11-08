#import <UIKit/UIKit.h>

extern NSString *const kTextViewCell;
@interface TextViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *userTextView; //用户反馈输入框
@property (weak, nonatomic) IBOutlet UILabel *fontLabel; //用户已输入的文字

@end
