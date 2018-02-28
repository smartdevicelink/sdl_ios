//
//  SDLDisplayCapabilities+ShowManagerExtensions.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/28/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLDisplayCapabilities+ShowManagerExtensions.h"
#import "SDLImageField.h"
#import "SDLTextField.h"

@implementation SDLDisplayCapabilities (ShowManagerExtensions)

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
