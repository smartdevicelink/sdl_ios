//
//  SDLTextField+ScreenManagerExtensions.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/20/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLTextField+ScreenManagerExtensions.h"

@implementation SDLTextField (ScreenManagerExtensions)

+ (NSArray<SDLTextFieldName> *)sdl_allTextFieldNames {
    return @[SDLTextFieldNameETA, SDLTextFieldNameMenuName, SDLTextFieldNameMenuTitle, SDLTextFieldNameStatusBar, SDLTextFieldNameAlertText1, SDLTextFieldNameAlertText2, SDLTextFieldNameAlertText3, SDLTextFieldNameMainField1, SDLTextFieldNameMainField2, SDLTextFieldNameMainField3, SDLTextFieldNameMainField4, SDLTextFieldNameMediaClock, SDLTextFieldNameMediaTrack, SDLTextFieldNamePhoneNumber, SDLTextFieldNameAddressLines, SDLTextFieldNameLocationName, SDLTextFieldNameSliderFooter, SDLTextFieldNameSliderHeader, SDLTextFieldNameTertiaryText, SDLTextFieldNameSecondaryText, SDLTextFieldNameTemplateTitle, SDLTextFieldNameTotalDistance, SDLTextFieldNameNavigationText1, SDLTextFieldNameNavigationText2, SDLTextFieldNameLocationDescription, SDLTextFieldNameScrollableMessageBody, SDLTextFieldNameInitialInteractionText, SDLTextFieldNameAudioPassThruDisplayText1, SDLTextFieldNameAudioPassThruDisplayText2];
}

+ (NSArray<SDLTextField *> *)allTextFields {
    NSMutableArray<SDLTextField *> *tempTextFields = [NSMutableArray array];
    for (SDLTextFieldName fieldName in [self sdl_allTextFieldNames]) {
        [tempTextFields addObject:[[SDLTextField alloc] initWithName:fieldName characterSet:SDLCharacterSetUtf8 width:500 rows:8]];
    }

    return tempTextFields;
}

@end
