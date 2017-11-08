//
//  UrlDefine.h
//  SeeWorld
//
//  Created by  on 15/8/9.
//  Copyright (c) 2015年 SeeWorld
//

#ifndef SeeWorld_Define_h
#define SeeWorld_Define_h

#import "UrlDefine.h"
#import "SWFoundation.h"

#define DEFAULT_AREACODE @"+86"
#define DEFAULT_AREACODE_STR @"中國(+86)"

#define FEED_SMALL @"-feed640"
#define FEED_THUMB @"-feed300"

#define SWFONT(size) [UIFont systemFontOfSize:size]
#define IMAGEDPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/IMAGE/"]
#define IMAGEFPath(path) [IMAGEDPath stringByAppendingString:(path.length == 0? @"":path)]
#endif
