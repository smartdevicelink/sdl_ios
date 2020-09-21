//
//  SDLLogTargetASL.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogTarget.h"


NS_ASSUME_NONNULL_BEGIN

/**
 The Apple System Log target is an iOS 2.0+ compatible log target that logs to both the Console and to the System Log.

 Deprecated. Please use SDLLogTargetOSLog instead.
 */
__deprecated
@interface SDLLogTargetAppleSystemLog : NSObject <SDLLogTarget>

@end

NS_ASSUME_NONNULL_END
