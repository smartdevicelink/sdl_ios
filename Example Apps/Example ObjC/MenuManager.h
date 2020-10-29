//
//  MenuManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 5/15/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLPredefinedLayout.h"

@class PerformInteractionManager;
@class SDLManager;
@class SDLMenuCell;
@class SDLVoiceCommand;

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshTemplateHandler)(SDLPredefinedLayout);

@interface MenuManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRefreshTemplateHandler:(RefreshTemplateHandler)updateTemplate;
- (NSArray<SDLMenuCell *> *)allMenuItemsWithManager:(SDLManager *)manager performManager:(PerformInteractionManager *)performManager;
- (NSArray<SDLVoiceCommand *> *)allVoiceMenuItemsWithManager:(SDLManager *)manager;

@end

NS_ASSUME_NONNULL_END
