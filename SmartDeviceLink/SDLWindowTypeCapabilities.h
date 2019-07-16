//
//  SDLWindowTypeCapabilities.h
//  SmartDeviceLink
//
//  Created by cssoeutest1 on 16.07.19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"
#import "SDLWindowType.h"



NS_ASSUME_NONNULL_BEGIN

@interface SDLWindowTypeCapabilities : SDLRPCStruct


/**
 *
 *
 */
@property (strong, nonatomic) SDLWindowType type;

/**
 *
 *
 */
@property (strong, nonatomic) NSNumber<SDLInt> *maximumNumberOfWindows;



@end

NS_ASSUME_NONNULL_END
