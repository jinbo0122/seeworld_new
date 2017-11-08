//
//  RelationshipViewController.h
//  
//
//  Created by liufz on 15/10/11.
//
//

typedef enum : NSUInteger {
    eRelationshipTypeFollows,
    eRelationshipTypeFollowers,
} RelationshipType;

@interface RelationshipViewController : ALBaseVC
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) RelationshipType type;
@end
