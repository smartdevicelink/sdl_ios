//
//  MenuManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 5/15/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLManager;
@class SDLMenuCell;
@class SDLVoiceCommand;

NS_ASSUME_NONNULL_BEGIN

@interface MenuManager : NSObject

+ (NSArray<SDLMenuCell *> *)allMenuItemsWithManager:(SDLManager *)manager;
+ (NSArray<SDLVoiceCommand *> *)allVoiceMenuItemsWithManager:(SDLManager *)manager;

@end

NS_ASSUME_NONNULL_END
