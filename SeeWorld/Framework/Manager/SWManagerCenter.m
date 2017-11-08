//
//
//
//  Created by abc on 15/4/18.
//  Copyright (c) 2015年 Abc
//

#import "SWManagerCenter.h"
#import "Reachability.h"

@interface SWManageCenter ()
@property (nonatomic, strong) NSMutableArray *managers;
@end

@implementation SWManageCenter

+ (SWManageCenter *)defaultCenter
{
    static dispatch_once_t once;
    static SWManageCenter *managerCenter;
    dispatch_once(&once, ^{
        managerCenter = [[[self class] alloc] init];
        managerCenter.managers = [[NSMutableArray alloc] init];
        [managerCenter startNetReachabilityMonitor];
    });
    return managerCenter;
}


- (void)registerManager:(SWManager<SWManager> *)manager
{
    @synchronized([self managers])
    {
        [[self managers] addObject:manager];
    }
    [manager initSource];
    return;
}

- (void)unregisterAllManager
{
    NSArray *allManager = nil;
    @synchronized([self managers])
    {
        allManager = [self.managers copy];
    }

    for (SWManager *manager in allManager)
    {
        [manager clearSource];
    }

    @synchronized(self.managers)
    {
        [self.managers removeAllObjects];
    }
    return;
}

- (void)notifyAppLogined:(NSDictionary *)loginInfo
{
    NSArray *allManager = nil;
    @synchronized([self managers])
    {
        allManager = [self.managers copy];
    }

    for (SWManager *manager in allManager)
    {
        [manager appDidLogin:loginInfo];
    }

    return;
}

- (void)notifyAppLogouted
{
    NSArray *allManager = nil;
    @synchronized([self managers])
    {
        allManager = [self.managers copy];
    }

    for (SWManager *manager in allManager)
    {
        [manager appDidLogout];
    }
    return;
}

- (void)notityNetStateChanged:(NSNotification *)notification
{
    NSArray *allManager = nil;
    @synchronized([self managers])
    {
        allManager = [self.managers copy];
    }

    for (SWManager *manager in allManager)
    {
        if ([manager respondsToSelector:@selector(netStateDidChange:)])
        {
            [manager netStateDidChange:notification];
        }
    }
}

- (void)startNetReachabilityMonitor
{
    [[Reachability reachabilityWithHostName:@"www.baidu.com"] startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notityNetStateChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

@end
