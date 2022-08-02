//
//  MenuManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 5/15/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PerformInteractionManager;
@class RemoteControlManager;
@class SDLManager;
@class SDLMenuCell;
@class SDLVoiceCommand;

NS_ASSUME_NONNULL_BEGIN

@interface MenuManager : NSObject

+ (NSArray<SDLMenuCell *> *)allMenuItemsWithManager:(SDLManager *)manager performManager:(PerformInteractionManager *)performManager remoteManager:(RemoteControlManager *)remoteManager;
+ (NSArray<SDLVoiceCommand *> *)allVoiceMenuItemsWithManager:(SDLManager *)manager;

@end

NS_ASSUME_NONNULL_END
