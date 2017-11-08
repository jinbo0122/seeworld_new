//
//  SWLoginFBAPI.h
//  SeeWorld
//
//  Created by Albert Lee on 6/9/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWRequestApi.h"

@interface SWLoginFBAPI : SWRequestApi
@property(nonatomic, strong)NSString *openid;
@property(nonatomic, strong)NSString *token;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *head;
@property(nonatomic, strong)NSNumber *gender;
@end
