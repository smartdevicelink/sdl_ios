//
//  SDLCloseApplicationResponse.h
//  SmartDeviceLink
//
//  Created by Nicole on 7/9/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Response to the request to close this app on the module
 */
@interface SDLCloseApplicationResponse : SDLRPCResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameCloseApplication]) {
    }
    return self;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
