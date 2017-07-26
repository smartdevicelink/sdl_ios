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

- (instancetype)initWithRejectedParams:(nullable NSArray<NSString *> *)rejectedParams;

@end

NS_ASSUME_NONNULL_END
