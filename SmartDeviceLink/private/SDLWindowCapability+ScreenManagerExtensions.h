//
//  SDLWindowCapability+ShowManagerExtensions.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/28/18.
//  Updated by Kujtim Shala (Ford) on 13.09.19.
//    - Renamed and adapted for WindowCapability
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLImageFieldName.h"
#import "SDLTextFieldName.h"
#import "SDLWindowCapability.h"

NS_ASSUME_NONNULL_BEGIN

static const int MaxMainFieldLineCount = 4;
static const int MaxAlertTextFieldLineCount = 3;

@interface SDLWindowCapability (ScreenManagerExtensions)

@property (assign, nonatomic, readonly) NSUInteger maxNumberOfMainFieldLines;
@property (assign, nonatomic, readonly) NSUInteger maxNumberOfAlertMainFieldLines;

- (BOOL)hasTextFieldOfName:(SDLTextFieldName)name;
- (BOOL)hasImageFieldOfName:(SDLImageFieldName)name;

@end

NS_ASSUME_NONNULL_END
