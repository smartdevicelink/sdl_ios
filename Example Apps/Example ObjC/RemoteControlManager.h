//
//  RemoteControlManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Beharry, Justin (J.S.) on 8/1/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLManager;

NS_ASSUME_NONNULL_BEGIN

@interface RemoteControlManager : NSObject

- (instancetype)init NS_UNAVAILABLE;;
- (instancetype)initWithManager:(SDLManager *)manager;

- (void)showClimateControl;
- (NSString*)getClimateData;

@end

NS_ASSUME_NONNULL_END
