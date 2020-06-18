//
//  TestNewConfigurationUpdateManagerDelegate.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 6/4/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "TestNewConfigurationUpdateManagerDelegate.h"

@implementation TestNewConfigurationUpdateManagerDelegate

- (void)hmiLevel:(nonnull SDLHMILevel)oldLevel didChangeToLevel:(nonnull SDLHMILevel)newLevel { }

- (void)managerDidDisconnect { }

- (nullable SDLLifecycleConfigurationUpdate *)managerShouldUpdateLifecycleToLanguage:(SDLLanguage)language hmiLanguage:(SDLLanguage)hmiLanguage {
    return nil;
}

@end
