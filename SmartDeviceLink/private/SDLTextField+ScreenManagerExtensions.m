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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return @[SDLTextFieldNameAddressLines,
             SDLTextFieldNameAlertText1,
             SDLTextFieldNameAlertText2,
             SDLTextFieldNameAlertText3,
             SDLTextFieldNameAudioPassThruDisplayText1,
             SDLTextFieldNameAudioPassThruDisplayText2,
             SDLTextFieldNameETA,
             SDLTextFieldNameInitialInteractionText,
             SDLTextFieldNameLocationDescription,
             SDLTextFieldNameLocationName,
             SDLTextFieldNameMainField1,
             SDLTextFieldNameMainField2,
             SDLTextFieldNameMainField3,
             SDLTextFieldNameMainField4,
             SDLTextFieldNameMediaClock,
             SDLTextFieldNameMediaTrack,
             SDLTextFieldNameMenuCommandSecondaryText,
             SDLTextFieldNameMenuCommandTertiaryText,
             SDLTextFieldNameMenuName,
             SDLTextFieldNameMenuSubMenuSecondaryText,
             SDLTextFieldNameMenuSubMenuTertiaryText,
             SDLTextFieldNameMenuTitle,
             SDLTextFieldNameNavigationText1,
             SDLTextFieldNameNavigationText2,
             SDLTextFieldNamePhoneNumber,
             SDLTextFieldNameScrollableMessageBody,
             SDLTextFieldNameSecondaryText,
             SDLTextFieldNameSliderFooter,
             SDLTextFieldNameSliderHeader,
             SDLTextFieldNameStatusBar,
             SDLTextFieldNameSubtleAlertSoftButtonText,
             SDLTextFieldNameSubtleAlertText1,
             SDLTextFieldNameSubtleAlertText2,
             SDLTextFieldNameTemplateTitle,
             SDLTextFieldNameTertiaryText,
             SDLTextFieldNameTimeToDestination,
             SDLTextFieldNameTotalDistance,
             SDLTextFieldNameTurnText];
}
#pragma clang diagnostic pop

+ (NSArray<SDLTextField *> *)allTextFields {
    NSMutableArray<SDLTextField *> *tempTextFields = [NSMutableArray array];
    for (SDLTextFieldName fieldName in [self sdl_allTextFieldNames]) {
        [tempTextFields addObject:[[SDLTextField alloc] initWithName:fieldName characterSet:SDLCharacterSetUtf8 width:500 rows:8]];
    }

    return tempTextFields;
}

@end
