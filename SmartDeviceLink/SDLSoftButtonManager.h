//
//  SDLSoftButtonManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDLConnectionManagerType;

@class SDLFileManager;
@class SDLSoftButtonObject;
@class SDLSoftButtonState;

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonManager : NSObject

/**
 An array of soft button wrappers containing soft button states. This is the current set of soft buttons in the process of being displayed or that are currently displayed. To display a new set of soft buttons, set this property.
 */
@property (copy, nonatomic) NSArray<SDLSoftButtonObject *> *softButtons;

- (instancetype)init NS_UNAVAILABLE;

/**
 Create a soft button manager with a connection manager

 @param connectionManager The manager that forwards RPCs
 @param fileManager The manager that updates images
 @return A new instance of a soft button manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager;

/**
 Update a button with a particular name by replacing the current state with a new state.

 @param buttonName The name of the button to swap states
 @param state The state to become the current state
 */
- (void)updateButtonNamed:(NSString *)buttonName replacingCurrentStateWithState:(SDLSoftButtonState *)state;

@end

NS_ASSUME_NONNULL_END
