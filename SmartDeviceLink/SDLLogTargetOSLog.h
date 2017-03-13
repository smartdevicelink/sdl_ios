//
//  SDLLogTargetOSLog.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogTarget.h"


NS_ASSUME_NONNULL_BEGIN

/**
 OS_LOG is an iOS 10+ only logging system that logs to the Console and the Apple system console. This is an improved replacement for Apple SysLog (SDLLogTargetAppleSystemLog). 
 
 https://developer.apple.com/reference/os/logging
 */
@interface SDLLogTargetOSLog : NSObject <SDLLogTarget>

@end

NS_ASSUME_NONNULL_END
