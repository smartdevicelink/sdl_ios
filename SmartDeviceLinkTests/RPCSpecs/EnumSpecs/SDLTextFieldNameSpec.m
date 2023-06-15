//
//  SDLTextFieldNameSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLTextFieldName.h"

QuickSpecBegin(SDLTextFieldNameSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTextFieldNameMainField1).to(equal(@"mainField1"));
        expect(SDLTextFieldNameMainField2).to(equal(@"mainField2"));
        expect(SDLTextFieldNameMainField3).to(equal(@"mainField3"));
        expect(SDLTextFieldNameMainField4).to(equal(@"mainField4"));
        expect(SDLTextFieldNameTemplateTitle).to(equal(@"templateTitle"));
        expect(SDLTextFieldNameStatusBar).to(equal(@"statusBar"));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(SDLTextFieldNameMediaClock).to(equal(@"mediaClock"));
#pragma clang diagnostic pop
        expect(SDLTextFieldNameMediaTrack).to(equal(@"mediaTrack"));
        expect(SDLTextFieldNameAlertText1).to(equal(@"alertText1"));
        expect(SDLTextFieldNameAlertText2).to(equal(@"alertText2"));
        expect(SDLTextFieldNameAlertText3).to(equal(@"alertText3"));
        expect(SDLTextFieldNameScrollableMessageBody).to(equal(@"scrollableMessageBody"));
        expect(SDLTextFieldNameInitialInteractionText).to(equal(@"initialInteractionText"));
        expect(SDLTextFieldNameNavigationText1).to(equal(@"navigationText1"));
        expect(SDLTextFieldNameNavigationText2).to(equal(@"navigationText2"));
        expect(SDLTextFieldNameETA).to(equal(@"ETA"));
        expect(SDLTextFieldNameTotalDistance).to(equal(@"totalDistance"));
        expect(SDLTextFieldNameAudioPassThruDisplayText1).to(equal(@"audioPassThruDisplayText1"));
        expect(SDLTextFieldNameAudioPassThruDisplayText2).to(equal(@"audioPassThruDisplayText2"));
        expect(SDLTextFieldNameSliderHeader).to(equal(@"sliderHeader"));
        expect(SDLTextFieldNameSliderFooter).to(equal(@"sliderFooter"));
        expect(SDLTextFieldNameMenuName).to(equal(@"menuName"));
        expect(SDLTextFieldNameSecondaryText).to(equal(@"secondaryText"));
        expect(SDLTextFieldNameTertiaryText).to(equal(@"tertiaryText"));
        expect(SDLTextFieldNameMenuTitle).to(equal(@"menuTitle"));
        expect(SDLTextFieldNameLocationName).to(equal(@"locationName"));
        expect(SDLTextFieldNameLocationDescription).to(equal(@"locationDescription"));
        expect(SDLTextFieldNameAddressLines).to(equal(@"addressLines"));
        expect(SDLTextFieldNamePhoneNumber).to(equal(@"phoneNumber"));
        expect(SDLTextFieldNameSubtleAlertText1).to(equal(@"subtleAlertText1"));
        expect(SDLTextFieldNameSubtleAlertText2).to(equal(@"subtleAlertText2"));
        expect(SDLTextFieldNameSubtleAlertSoftButtonText).to(equal("subtleAlertSoftButtonText"));
        expect(SDLTextFieldNameTimeToDestination).to(equal(@"timeToDestination"));
        expect(SDLTextFieldNameTurnText).to(equal(@"turnText"));
        expect(SDLTextFieldNameMenuCommandSecondaryText).to(equal(@"menuCommandSecondaryText"));
        expect(SDLTextFieldNameMenuCommandTertiaryText).to(equal(@"menuCommandTertiaryText"));
        expect(SDLTextFieldNameMenuSubMenuSecondaryText).to(equal(@"menuSubMenuSecondaryText"));
        expect(SDLTextFieldNameMenuSubMenuTertiaryText).to(equal(@"menuSubMenuTertiaryText"));
    });
});

QuickSpecEnd
