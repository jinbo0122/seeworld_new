//
//  RelationshipCell.h
//  
//
//  Created by liufz on 15/10/11.
//
//

#import <UIKit/UIKit.h>
#import "PersonInfoData.h"

@interface RelationshipCell : UITableViewCell
@property (strong,nonatomic) PersonInfoData *personData;
@property (copy, nonatomic) void (^relationshipChangedBlock)(PersonInfoData *personData, NSString *action);
@end

