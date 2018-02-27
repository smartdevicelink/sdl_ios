//
//  SDLSoftButtonState.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLSystemAction.h"

@class SDLArtwork;
@class SDLSoftButton;

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonState : NSObject

/**
 The name of this soft button state
 */
@property (copy, nonatomic, readonly) NSString *name;

/**
 The artwork to be used with this button or nil if it is text-only
 */
@property (strong, nonatomic, readonly, nullable) SDLArtwork *artwork;

/**
 The text to be used with this button or nil if it is image-only
 */
@property (copy, nonatomic, readonly, nullable) NSString *text;

/**
 Whether or not the button should be highlighted on the UI
 */
@property (assign, nonatomic, getter=isHighlighted) BOOL highlighted;

/**
 A special system action
 */
@property (strong, nonatomic) SDLSystemAction systemAction;

/**
 An SDLSoftButton describing this state
 */
@property (strong, nonatomic, readonly) SDLSoftButton *softButton;

- (instancetype)init NS_UNAVAILABLE;

/**
 Create the soft button state. Either the text or artwork or both may be set.

 @param stateName The name of this state for the button
 @param text The text to be displayed on the button
 @param image The image to be displayed on the button. This is assumed to be a PNG, non-persistant. The name will be the same as the state name.
 @return A new soft button state
 */
- (instancetype)initWithStateName:(NSString *)stateName text:(nullable NSString *)text image:(nullable UIImage *)image;

/**
 Create the soft button state. Either the text or artwork or both may be set.

 @param stateName The name of this state for the button
 @param text The text to be displayed on the button
 @param artwork The artwork to be displayed on the button
 @return A new soft button state
 */
- (instancetype)initWithStateName:(NSString *)stateName text:(nullable NSString *)text artwork:(nullable SDLArtwork *)artwork;

@end

NS_ASSUME_NONNULL_END
