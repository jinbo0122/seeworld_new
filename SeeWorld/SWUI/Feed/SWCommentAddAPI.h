//
//  SWCommentAddAPI.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWRequestApi.h"

@interface SWCommentAddAPI : SWRequestApi
@property(nonatomic, strong)NSNumber *fId;
@property(nonatomic, strong)NSString *text;
@end
