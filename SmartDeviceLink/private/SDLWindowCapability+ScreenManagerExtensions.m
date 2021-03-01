//
//  SDLWindowCapability+ScreenManagerExtensions.m
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

            if (highestFound == MaxMainFieldLineCount) { break; }
        }
    }

    return (NSUInteger)highestFound;
}

- (NSUInteger)maxNumberOfAlertFieldLines {
    NSInteger highestFound = 0;
    for (SDLTextField *textField in self.textFields) {
        if (![textField.name isKindOfClass:[NSString class]]) { continue; }
        if ([textField.name isEqualToString:SDLTextFieldNameAlertText1]
            || [textField.name isEqualToString:SDLTextFieldNameAlertText2]
            || [textField.name isEqualToString:SDLTextFieldNameAlertText3]) {
            NSInteger fieldNumber = [[textField.name substringFromIndex:(textField.name.length - 1)] integerValue];
            highestFound = (highestFound < fieldNumber) ? fieldNumber : highestFound;

            if (highestFound == MaxAlertTextFieldLineCount) { break; }
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

- (nullable SDLKeyboardProperties *)createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:(nullable SDLKeyboardProperties *)keyboardConfiguration {
    // If there are no keyboard capabilities, if there is no passed keyboard configuration, or if there is no layout to the passed keyboard configuration, just pass back the passed in configuration
    if ((self.keyboardCapabilities == nil) || (keyboardConfiguration == nil) || (keyboardConfiguration.keyboardLayout == nil)) {
        return keyboardConfiguration;
    }

    // Find the capability for the keyboard configuration's layout
    SDLKeyboardLayoutCapability *selectedLayoutCapability = nil;
    for (SDLKeyboardLayoutCapability *layoutCapability in self.keyboardCapabilities.supportedKeyboards) {
        if ([layoutCapability.keyboardLayout isEqualToEnum:keyboardConfiguration.keyboardLayout]) {
            selectedLayoutCapability = layoutCapability;
            break;
        }
    }
    if (selectedLayoutCapability == nil) {
        SDLLogE(@"Configured keyboard layout is not supported: %@", keyboardConfiguration.keyboardLayout);
        return nil;
    }

    // Modify the keyboard configuration if there are fewer customKeys allowed than were set, or if an empty array was set.
    SDLKeyboardProperties *modifiedKeyboardConfiguration = [keyboardConfiguration copy];
    if (keyboardConfiguration.customKeys.count == 0) {
        modifiedKeyboardConfiguration.customKeys = nil;
    } else {
        NSUInteger numConfigurableKeys = selectedLayoutCapability.numConfigurableKeys.unsignedIntegerValue;
        if (modifiedKeyboardConfiguration.customKeys.count > numConfigurableKeys) {
            SDLLogW(@"%lu custom keys set, but the selected layout: %@ only supports %lu. Dropping the rest.", (unsigned long)modifiedKeyboardConfiguration.customKeys.count, modifiedKeyboardConfiguration.keyboardLayout, (unsigned long)numConfigurableKeys);
            // If there are more custom keys than are allowed for the selected keyboard layout, we need to trim the number of keys to only use the first n number of custom keys, where n is the number of allowed custom keys for that layout.
            modifiedKeyboardConfiguration.customKeys = [modifiedKeyboardConfiguration.customKeys subarrayWithRange:NSMakeRange(0, numConfigurableKeys)];
        }
    }

    // If the keyboard does not support masking input characters, we will remove it from the keyboard configuration
    if (!self.keyboardCapabilities.maskInputCharactersSupported.boolValue) {
        modifiedKeyboardConfiguration.maskInputCharacters = nil;
    }

    return modifiedKeyboardConfiguration;
}

@end
