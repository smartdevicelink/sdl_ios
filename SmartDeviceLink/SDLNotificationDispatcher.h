//
//  SDLnotificationDispatcher.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLProxyListener.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLNotificationDispatcher : NSObject <SDLProxyListener>

- (void)postNotification:(NSString *)name info:(nullable id)info;

@end

NS_ASSUME_NONNULL_END