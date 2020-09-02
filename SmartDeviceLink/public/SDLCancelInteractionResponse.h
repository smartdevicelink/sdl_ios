//
//  SDLCancelInteractionResponse.h
//  SmartDeviceLink
//
//  Created by Nicole on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Response to the request to dismiss a modal view. If no applicable request can be dismissed, the `resultCode` will be `IGNORED`.
 */
@interface SDLCancelInteractionResponse : SDLRPCResponse

@end

NS_ASSUME_NONNULL_END
