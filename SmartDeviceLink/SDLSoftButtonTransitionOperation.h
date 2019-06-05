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
@class SDLSoftButtonObject;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 This operation handles changing a set of soft button objects when some of those objects have changed state.
 */
@interface SDLSoftButtonTransitionOperation : SDLAsynchronousOperation

/**
 The primary text field on the system template. This is necessary to HAX a workaround for Sync 3.
 */
@property (strong, nonatomic) NSString *mainField1;

/**
 Initialize the transition operation

 @param connectionManager The manager that will send the resultant RPCs
 @param capabilities The capabilites of the soft buttons on the current template
 @param softButtons The soft buttons that should be sent
 @param mainField1 The primary text field of the system template
 @return The transition operation
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager capabilities:(SDLSoftButtonCapabilities *)capabilities softButtons:(NSArray<SDLSoftButtonObject *> *)softButtons mainField1:(NSString *)mainField1;

@end

NS_ASSUME_NONNULL_END
