//
//  SDLAlertView.h
//  SmartDeviceLink
//
//  Created by Nicole on 11/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLAlertAudioData;
@class SDLArtwork;
@class SDLSoftButtonObject;

NS_ASSUME_NONNULL_BEGIN

/// Notifies the subscriber that the alert set should be cancelled.
typedef void (^SDLAlertCanceledHandler)(void);

@interface SDLAlertView : NSObject

/// Set this to change the default timeout for all alerts. If a timeout is not set on an individual alert object (or if it is set to 0.0), then it will use this timeout instead. See `timeout` for more details. If this is not set by you, it will default to 5 seconds. The minimum is 3 seconds, the maximum is 10 seconds. If this is set below the minimum, it will be capped at 3 seconds. If this is set above the maximum, it will be capped at 10 seconds.
@property (class, assign, nonatomic) NSTimeInterval defaultTimeout;

/// The primary line of text for display on the alert. If fewer than three alert lines are available on the head unit, the screen manager will automatically concatenate some of the lines together.
@property (nullable, strong, nonatomic) NSString *text;

/// The secondary line of text for display on the alert. If fewer than three alert lines are available on the head unit, the screen manager will automatically concatenate some of the lines together.
@property (nullable, strong, nonatomic) NSString *secondaryText;

/// The tertiary line of text for display on the alert. If fewer than three alert lines are available on the head unit, the screen manager will automatically concatenate some of the lines together.
@property (nullable, strong, nonatomic) NSString *tertiaryText;

/// Timeout in seconds. Defaults to `defaultTimeout`. If set to 0, it will use `defaultTimeout`. If this is set below the minimum, it will be capped at 3 seconds. Minimum 3 seconds, maximum 10 seconds. If this is set above the maximum, it will be capped at 10 seconds. Defaults to 0.
@property (assign, nonatomic) NSTimeInterval timeout;

/// Text spoken and/or tone played when the alert appears
@property (nullable, copy, nonatomic) NSArray<SDLAlertAudioData *> *audio;

/// If supported, the alert GUI will display some sort of indefinite waiting / refresh / loading indicator animation. Defaults to NO.
@property (assign, nonatomic) BOOL showWaitIndicator;

/// Soft buttons the user may select to perform actions. Only one `SDLSoftButtonState` per object is supported; if any soft button object contains multiple states, an exception will be thrown.
@property (nullable, copy, nonatomic) NSArray<SDLSoftButtonObject *> *softButtons;

/// An artwork that will be displayed when the icon appears. This will be uploaded prior to the appearance of the alert if necessary. This will not be uploaded if the head unit does not declare support for alertIcon.
@property (nullable, copy, nonatomic) SDLArtwork *icon;

/// Initialize a basic alert with a message and buttons
/// @param text The primary line of text for display on the alert
/// @param softButtons Soft buttons the user may select to perform actions
- (instancetype)initWithText:(NSString *)text buttons:(NSArray<SDLSoftButtonObject *> *)softButtons;

/// Initialize a alert with a text, image, buttons and sound
/// @param text The primary line of text for display on the alert
/// @param secondaryText The secondary line of text for display on the alert
/// @param tertiaryText The tertiary line of text for display on the alert
/// @param timeout Timeout in seconds
/// @param showWaitIndicator If supported, the alert GUI will display some sort of indefinite waiting / refresh / loading indicator animation
/// @param audio Text spoken and/or tone played when the alert appears
/// @param softButtons Soft buttons the user may select to perform actions
/// @param icon An artwork that will be displayed when the icon appears
- (instancetype)initWithText:(nullable NSString *)text secondaryText:(nullable NSString *)secondaryText tertiaryText:(nullable NSString *)tertiaryText timeout:(NSTimeInterval)timeout showWaitIndicator:(BOOL)showWaitIndicator audioIndication:(nullable NSArray<SDLAlertAudioData *> *)audio buttons:(nullable NSArray<SDLSoftButtonObject *> *)softButtons icon:(nullable SDLArtwork *)icon;

/// Cancels the alert. If the alert has not yet been sent to Core, it will not be sent. If the alert is already presented on Core, the alert will be immediately dismissed. Canceling an already presented alert will only work if connected to modules support RPC Spec v.6.0+. On older versions of Core, the alert will not be dismissed.
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
