//
//  ButtonManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 5/11/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLManager;
@class SDLSoftButtonObject;

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshUIHandler)(void);

@interface ButtonManager : NSObject

@property (assign, nonatomic, getter=isTextEnabled, readonly) BOOL textEnabled;
@property (assign, nonatomic, getter=areImagesEnabled, readonly) BOOL imagesEnabled;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithManager:(SDLManager *)manager refreshUIHandler:(RefreshUIHandler)refreshUIHandler;

/// An array of all the soft buttons
- (NSArray<SDLSoftButtonObject *> *)allScreenSoftButtons;

@end

NS_ASSUME_NONNULL_END
