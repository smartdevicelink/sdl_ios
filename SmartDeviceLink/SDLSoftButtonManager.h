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

/**
 The handler run when the update has completed

 @param error An error if the update failed and an error occurred
 */
typedef void(^SDLSoftButtonUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLSoftButtonManager : NSObject

/**
 An array of soft button wrappers containing soft button states. This is the current set of soft buttons in the process of being displayed or that are currently displayed.
 */
@property (copy, nonatomic, readonly) NSArray<SDLSoftButtonObject *> *softButtonObjects;

@property (assign, nonatomic, readonly) BOOL isBatchingUpdates;

- (instancetype)init NS_UNAVAILABLE;

/**
 Create a soft button manager with a connection manager

 @param connectionManager The manager that forwards RPCs
 @param fileManager The manager that updates images
 @return A new instance of a soft button manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager;

/**
 Update a button with a particular name by replacing the current state with a new state. This immediately sends the update. If you have multiple changes to make, call `beginUpdates`, make the changes, then call `endUpdatesWithCompletionHandler`

 @param buttonName The name of the button to swap states
 @param stateName The state to become the current state
 @return If the update found a button named buttonName and a state is found named stateName. This will return YES even if currently batching updates.
 */
- (BOOL)updateButtonNamed:(NSString *)buttonName replacingCurrentStateWithState:(NSString *)stateName;

/**
 To display a new set of soft buttons, call this method. Calling this property will cause a Show to be sent with all of the soft buttons and their initial states as well as uploading any images of additional states (after the initial state is sent); this resets `isBatchingUpdates` and will ignore `beginBatchingUpdates` and `endBatchingUpdates`. If any soft buttons are image only, all soft buttons will wait to show until the images are uploaded, otherwise, text buttons will be sent, then buttons re-sent when images are uploaded. If updates are called during this process, they will be queued.

 @param softButtons The new soft button objects to use
 @return If two softbuttons are found with the same name, this will return NO and nothing will occur
 */
- (BOOL)setSoftButtons:(NSArray<SDLSoftButtonObject *> *)softButtons; // TODO: Probably a completion handler with error?

/**
 Begins waiting for `endUpdatesWithCompletionHandler:` and pauses soft button transitions until that method is called.
 */
- (void)beginUpdates;

/**
 Cause all transitions in between `beginUpdates` and this method call to occur in one RPC update.

 @param handler The handler called once the update is completed.
 */
- (void)endUpdatesWithCompletionHandler:(SDLSoftButtonUpdateCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END
