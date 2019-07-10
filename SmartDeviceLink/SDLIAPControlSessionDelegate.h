//
//  SDLIAPControlSessionDelegate.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 5/13/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLIAPControlSession;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLIAPControlSessionDelegate <NSObject>

- (void)controlSessionShouldRetry;
- (void)controlSession:(SDLIAPControlSession *)controlSession didReceiveProtocolString:(NSString *)protocolString;

@end

NS_ASSUME_NONNULL_END

