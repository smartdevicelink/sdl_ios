//
//  RemoteControlManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Beharry, Justin (J.S.) on 8/1/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLManager;
@class SDLSoftButtonObject;

NS_ASSUME_NONNULL_BEGIN

@interface RemoteControlManager : NSObject

@property (copy, nonatomic, readonly) NSString *climateDataString;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithManager:(SDLManager *)manager andButtons:(NSArray<SDLSoftButtonObject *> *)buttons;

- (void)start;
- (void)showClimateControl;

@end

NS_ASSUME_NONNULL_END
