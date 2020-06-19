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
- (void)subscribeToPresetButtons;
- (void)unsubscribeToPresetButtons;

@end

NS_ASSUME_NONNULL_END
