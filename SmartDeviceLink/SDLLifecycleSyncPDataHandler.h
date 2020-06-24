//
//  SDLLifecycleSyncPDataHandler.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/8/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLConnectionManagerType;

@interface SDLLifecycleSyncPDataHandler : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
