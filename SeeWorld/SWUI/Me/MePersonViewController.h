//
//  MePersonViewController.h
//  SeeWorld
//
//  Created by  on 15/8/11.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "SWBaseViewController.h"
#import "PersonInfoData.h"

@interface MePersonViewController : ALBaseVC
@property (nonatomic,strong)PersonInfoData *person;
@property (nonatomic,assign)BOOL isMe;
@end
