//
//  TestOldConfigurationUpdateManagerDelegate.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 6/4/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "TestOldConfigurationUpdateManagerDelegate.h"

@implementation TestOldConfigurationUpdateManagerDelegate

- (void)hmiLevel:(nonnull SDLHMILevel)oldLevel didChangeToLevel:(nonnull SDLHMILevel)newLevel { }

- (void)managerDidDisconnect { }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (nullable SDLLifecycleConfigurationUpdate *)managerShouldUpdateLifecycleToLanguage:(SDLLanguage)language {
    return nil;
}
#pragma mark diagnostic pop

@end
