//
//  LoginRequestApi.h
//  SeeWorld
//
//  Created by  on 15/8/9.
//  Copyright (c) 2015年 SeeWorld
//

#import "SWRequestApi.h"

typedef NS_ENUM(NSUInteger, LoginType) {
    LoginTypeLogin,
    LoginTypeRegist,
    LoginTypeRestPassWord,
};

@interface LoginRequestApi:SWRequestApi
- (id)initWithUsername:(NSString *)username password:(NSString *)password;
- (id)initWithDic:(NSDictionary *)dic;
@property LoginType requestType;
@end
