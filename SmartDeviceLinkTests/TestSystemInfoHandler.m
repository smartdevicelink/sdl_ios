//
//  TestSystemInfoHandler.m
//  SmartDeviceLinkTests
//
//  Created by Leonid Lokhmatov on 17.02.2021.
//  Copyright © 2021 Luxoft. All rights reserved
//

#import "TestSystemInfoHandler.h"
#import "SDLSystemInfo.h"

@implementation TestSystemInfoHandler

- (BOOL)didReceiveSystemInfo:(SDLSystemInfo *)systemInfo {
    self.lastSystemInfo = systemInfo;
    return self.boolResponse;
}

- (void)doDisconnectWithSystemInfo:(SDLSystemInfo *)systemInfo {
    self.lastSystemInfo = systemInfo;
}

@end
