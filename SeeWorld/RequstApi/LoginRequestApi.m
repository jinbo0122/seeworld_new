//
//  LoginRequestApi.m
//  SeeWorld
//
//  Created by  on 15/8/9.
//  Copyright (c) 2015年 SeeWorld
//

#import "LoginRequestApi.h"

@implementation LoginRequestApi
{
  NSString *_username;
  NSString *_password;
  NSString *_header;
  NSString *_name;
  NSString *_gender;
}

- (id)initWithDic:(NSDictionary *)dic
{
  self = [super init];
  if (self) {
    _username = dic[@"username"];
    _password = dic[@"password"];
    _header = dic[@"header"];
    _name = dic[@"name"];
    _gender = dic[@"gender"];
  }
  return self;
  
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
  self = [super init];
  if (self) {
    _username = username;
    _password = password;
  }
  return self;
}

- (NSString *)requestUrl {
  if (_requestType == LoginTypeLogin) {
    return @"/login";
  }
  else if (_requestType == LoginTypeRegist) {
    return @"/registertel";
  }
  else if (_requestType == LoginTypeRestPassWord) {
  }
  return @"";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument {
  if (_requestType == LoginTypeLogin) {
    return @{
             @"account": _username,
             @"password": _password,
             };
  }
  else if (_requestType == LoginTypeRegist) {
    return @{
             @"tel": _username,
             @"password": _password,
             @"head": _header,
             @"name": _name,
             @"gender": _gender
             };
  }
  return @"";
}
@end
