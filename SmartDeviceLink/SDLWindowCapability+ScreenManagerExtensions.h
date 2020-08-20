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

@interface SDLWindowCapability (ScreenManagerExtensions)

@property (assign, nonatomic, readonly) NSUInteger maxNumberOfMainFieldLines;

- (BOOL)hasTextFieldOfName:(SDLTextFieldName)name;
- (BOOL)hasImageFieldOfName:(SDLImageFieldName)name;

@end

NS_ASSUME_NONNULL_END
