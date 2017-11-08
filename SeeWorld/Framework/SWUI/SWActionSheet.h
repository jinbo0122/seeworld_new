//
//  SWActionSheet.h
//  
//
//  Created by abc on 15/6/18.
//  
//

#import "SWUI.h"

typedef NS_ENUM(NSInteger, SWActionSheetType) {
    SWActionSheetTypeCommon,
    SWActionSheetTypeShare,
    SWActionSheetTypeShareWithEdit,
    SWActionSheetTypeNoCancel,
    SWActionSheetTypeMiddle,
};

@interface SWActionSheetItem : NSObject
+(instancetype)itemWithTitle:(NSString *)title block:(void(^)(void))block;
+(instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image block:(void(^)(void))block;
@end

@interface SWActionSheet : UIView
- (instancetype)initWithType:(SWActionSheetType)type items:(NSArray *)items title:(NSString *)title;
- (void)show;
@end