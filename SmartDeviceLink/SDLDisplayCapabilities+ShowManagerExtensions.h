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

@property (assign, nonatomic, readonly) NSUInteger maxNumberOfMainFieldLines;

- (BOOL)hasTextFieldOfName:(SDLTextFieldName)name;
- (BOOL)hasImageFieldOfName:(SDLImageFieldName)name;

@end
