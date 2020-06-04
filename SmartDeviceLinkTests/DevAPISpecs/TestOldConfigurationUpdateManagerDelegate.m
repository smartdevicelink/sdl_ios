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

- (nullable SDLLifecycleConfigurationUpdate *)managerShouldUpdateLifecycleToLanguage:(SDLLanguage)language {
    return nil;
}

@end
