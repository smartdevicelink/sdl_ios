//
//  SDLLifecycleMobileHMIStateHandler.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLifecycleMobileHMIStateHandler : NSObject

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
