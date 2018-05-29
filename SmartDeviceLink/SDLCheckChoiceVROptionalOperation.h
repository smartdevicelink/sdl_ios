//
//  SDLCheckChoiceVROptionalOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/24/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousOperation.h"

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN


@interface SDLCheckChoiceVROptionalOperation : SDLAsynchronousOperation

@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager;

@end

NS_ASSUME_NONNULL_END
