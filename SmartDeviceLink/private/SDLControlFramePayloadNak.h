//
//  SDLControlFramePayloadNak.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/20/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadNak : NSObject <SDLControlFramePayloadType>

/// An array of rejected parameters such as: [`hashId`]
@property (copy, nonatomic, readonly, nullable) NSArray<NSString *> *rejectedParams;

/// A string describing the failure
@property (copy, nonatomic, readonly, nullable) NSString *reason;

- (instancetype)initWithRejectedParams:(nullable NSArray<NSString *> *)rejectedParams reason:(nullable NSString *)reason;

@end

NS_ASSUME_NONNULL_END
