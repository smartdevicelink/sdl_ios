//
//  SDLRCButtonPress.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

@class SDLButtonName;
@class SDLButtonPressMode;
@class SDLInteriorZone;
@class SDLModuleType;


NS_ASSUME_NONNULL_BEGIN

@interface SDLButtonPress : SDLRPCRequest

/**
 * @abstract Constructs a new SDLResetGlobalProperties object
 */
- (instancetype)init;

/**
 * @abstract Constructs a new SDLResetGlobalProperties object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 *  The zone where the button press should occur
 */
@property (strong, nonatomic) SDLInteriorZone *zone;

/**
 *  The module where the button should be pressed
 */
@property (strong, nonatomic) SDLModuleType *moduleType;

@property (strong, nonatomic) SDLButtonName *buttonName;

/**
 *  An indication of whether this is a LONG or SHORT button press event
 */
@property (strong, nonatomic) SDLButtonPressMode *buttonPressMode;

@end

NS_ASSUME_NONNULL_END
