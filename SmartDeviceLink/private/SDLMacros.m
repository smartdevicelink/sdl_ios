//
//  SDLMacros.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/8/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLMacros.h"

NSUInteger const NSUIntBitCell = (CHAR_BIT * sizeof(NSUInteger));
NSUInteger NSUIntRotateCell(NSUInteger val, NSUInteger howMuch) {
    return ((((NSUInteger)val) << howMuch) | (((NSUInteger)val) >> (NSUIntBitCell - howMuch)));
}
