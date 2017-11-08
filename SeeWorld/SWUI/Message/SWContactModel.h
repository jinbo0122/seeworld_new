//
//  SWContactModel.h
//  SeeWorld
//
//  Created by Albert Lee on 1/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SWContactModelDelegate;
@interface SWContactModel : NSObject
@property(nonatomic, weak  )id<SWContactModelDelegate>delegate;
@property(nonatomic, strong)NSMutableArray *selectedContacts;
@property(nonatomic, strong)NSMutableArray *contacts;
@property(nonatomic, strong)NSMutableArray *searchedContacts;
- (void)getContacts;
- (void)dealUser:(SWFeedUserItem *)item;
- (void)searchUser:(NSString *)text;
@end


@protocol SWContactModelDelegate <NSObject>

- (void)contactModelDidLoadContacts:(SWContactModel *)model;
- (void)contactModelDidSearchContacts:(SWContactModel *)model;
@end
