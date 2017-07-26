//
//  SDLControlFramePayloadEndService.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadEndService : NSObject <SDLControlFramePayloadType>

/// Hash ID supplied in the StartServiceACK for this service type
@property (assign, nonatomic, readonly) int32_t hashId;

- (instancetype)initWithHashId:(int32_t)hashId;

@end

NS_ASSUME_NONNULL_END
