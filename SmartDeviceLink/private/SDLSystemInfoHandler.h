//
//  SDLSystemInfoHandler.h
//  SmartDeviceLink
//
//  Created by YL on 01/12/21.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLSystemInfo;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLSystemInfoHandler <NSObject>

- (BOOL)shouldProceedWithSystemInfo:(SDLSystemInfo *)systemInfo;

- (void)doDisconnectWithSystemInfo:(SDLSystemInfo *)systemInfo;

@end

NS_ASSUME_NONNULL_END
