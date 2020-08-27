//
//  SDLControlFramePayloadRegisterSecondaryTransportNak.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/03/16.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadRegisterSecondaryTransportNak : NSObject <SDLControlFramePayloadType>

@property (copy, nonatomic, readonly, nullable) NSString *reason;

- (instancetype)initWithReason:(nullable NSString *)reason;

@end

NS_ASSUME_NONNULL_END
