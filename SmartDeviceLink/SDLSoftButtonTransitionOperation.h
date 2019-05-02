//
//  SDLSoftButtonTransitionOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"

@class SDLSoftButtonCapabilities;
@class SDLSoftButton;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonTransitionOperation : SDLAsynchronousOperation

@property (strong, nonatomic) NSString *mainField1;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager capabilities:(SDLSoftButtonCapabilities *)capabilities softButtons:(NSArray<SDLSoftButtonObject *> *)softButtons mainField1:(NSString *)mainField1;

@end

NS_ASSUME_NONNULL_END
