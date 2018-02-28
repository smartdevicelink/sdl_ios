//
//  SDLDisplayCapabilities+ShowManagerExtensions.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/28/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLDisplayCapabilities.h"
#import "SDLImageFieldName.h"
#import "SDLTextFieldName.h"

@interface SDLDisplayCapabilities (ShowManagerExtensions)

- (BOOL)hasTextFieldOfName:(SDLTextFieldName)name;
- (NSUInteger)maxNumberOfMainFieldLines;

- (BOOL)hasImageFieldOfName:(SDLImageFieldName)name;

@end
