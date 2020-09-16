//
//  SDLLogTargetFile.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogTarget.h"


NS_ASSUME_NONNULL_BEGIN

/**
 The File log will log to a text file on the iPhone in Documents/smartdevicelink/log/#appName##datetime##.log. It will log up to 3 logs which will rollover.
 */
@interface SDLLogTargetFile : NSObject <SDLLogTarget>

@end

NS_ASSUME_NONNULL_END
