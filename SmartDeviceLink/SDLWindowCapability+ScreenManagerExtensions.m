//
//  SDLWindowCapability+ShowManagerExtensions.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/28/18.
//  Updated by Kujtim Shala (Ford) on 13.09.19.
//    - Renamed and adapted for WindowCapability
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLWindowCapability+ScreenManagerExtensions.h"
#import "SDLImageField.h"
#import "SDLTextField.h"

@implementation SDLWindowCapability (ScreenManagerExtensions)

- (BOOL)hasTextFieldOfName:(SDLTextFieldName)name {
    for (SDLTextField *textField in self.textFields) {
        if ([textField.name isEqualToString:name]) {
            return YES;
        }
    }

    return NO;
}

- (NSUInteger)maxNumberOfMainFieldLines {
    NSInteger highestFound = 0;
    for (SDLTextField *textField in self.textFields) {
        if (![textField.name isKindOfClass:[NSString class]]) { continue; }
        if ([textField.name isEqualToString:SDLTextFieldNameMainField1]
            || [textField.name isEqualToString:SDLTextFieldNameMainField2]
            || [textField.name isEqualToString:SDLTextFieldNameMainField3]
            || [textField.name isEqualToString:SDLTextFieldNameMainField4]) {
            NSInteger fieldNumber = [[textField.name substringFromIndex:(textField.name.length - 1)] integerValue];
            highestFound = (highestFound < fieldNumber) ? fieldNumber : highestFound;

            if (highestFound == 4) { break; }
        }
    }

    return (NSUInteger)highestFound;
}

- (BOOL)hasImageFieldOfName:(SDLImageFieldName)name {
    for (SDLImageField *imageField in self.imageFields) {
        if ([imageField.name isEqualToString:name]) {
            return YES;
        }
    }

    return NO;
}

@end
