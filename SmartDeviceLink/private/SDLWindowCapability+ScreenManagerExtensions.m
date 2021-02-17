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
#import "SDLKeyboardCapabilities.h"
#import "SDLKeyboardLayoutCapability.h"
#import "SDLKeyboardProperties.h"
#import "SDLLogMacros.h"
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

- (SDLKeyboardProperties *__nullable)filterValidKeyboardProperties:(SDLKeyboardProperties *__nullable)inKeyboardProperties {
    if (!self.keyboardCapabilities || !inKeyboardProperties || !inKeyboardProperties.keyboardLayout) {
        return inKeyboardProperties;
    }
    SDLKeyboardLayoutCapability *selectedLayoutCapability = nil;
    if (inKeyboardProperties.keyboardLayout) {
        for (SDLKeyboardLayoutCapability *layoutCapability in self.keyboardCapabilities.supportedKeyboards) {
            if ([layoutCapability.keyboardLayout isEqualToEnum:inKeyboardProperties.keyboardLayout]) {
                selectedLayoutCapability = layoutCapability;
                break;
            }
        }
    }
    if (!selectedLayoutCapability) {
        SDLLogD(@"Keyboard layout is not supported: %@", inKeyboardProperties.keyboardLayout);
        return nil;
    }

    SDLKeyboardProperties *outKeyboardProperties = [inKeyboardProperties copy];

    if (!inKeyboardProperties.customKeys.count) {
        outKeyboardProperties.customKeys = nil;
    } else {
        const NSUInteger numConfigurableKeys = (NSUInteger)selectedLayoutCapability.numConfigurableKeys.integerValue;
        if (inKeyboardProperties.customKeys.count > numConfigurableKeys) {
            outKeyboardProperties.customKeys = [inKeyboardProperties.customKeys subarrayWithRange:NSMakeRange(0, numConfigurableKeys)];
            SDLLogD(@"Too many custom keys %d, only the first %d will be used and the rest will get dropped.", (int)inKeyboardProperties.customKeys.count, (int)numConfigurableKeys);
        }
    }

    if (!self.keyboardCapabilities.maskInputCharactersSupported.boolValue) {
        outKeyboardProperties.maskInputCharacters = nil;
    }

    return outKeyboardProperties;
}

@end
