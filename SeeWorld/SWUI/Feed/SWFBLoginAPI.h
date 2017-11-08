//
//  SWFBLoginAPI.h
//  SeeWorld
//
//  Created by Albert Lee on 9/6/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWRequestApi.h"

@interface SWFBLoginAPI : SWRequestApi
@property(nonatomic, strong)NSString *openID;
@property(nonatomic, strong)NSString *token;
@end
