//
//  SubscribeButtonManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 6/19/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLManager;

NS_ASSUME_NONNULL_BEGIN

@interface SubscribeButtonManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithManager:(SDLManager *)manager;

/// Subscribe to all available preset buttons. An alert will be shown when a preset button is short pressed or long pressed.
- (void)subscribeToAllPresetButtons;

@end

NS_ASSUME_NONNULL_END
