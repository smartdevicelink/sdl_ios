//
//  SDLImageFieldNameSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLImageFieldName.h"

QuickSpecBegin(SDLImageFieldNameSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLImageFieldNameSoftButtonImage).to(equal(@"softButtonImage"));
        expect(SDLImageFieldNameChoiceImage).to(equal(@"choiceImage"));
        expect(SDLImageFieldNameChoiceSecondaryImage).to(equal(@"choiceSecondaryImage"));
        expect(SDLImageFieldNameVoiceRecognitionHelpItem).to(equal(@"vrHelpItem"));
        expect(SDLImageFieldNameTurnIcon).to(equal(@"turnIcon"));
        expect(SDLImageFieldNameMenuIcon).to(equal(@"menuIcon"));
        expect(SDLImageFieldNameCommandIcon).to(equal(@"cmdIcon"));
        expect(SDLImageFieldNameAppIcon).to(equal(@"appIcon"));
        expect(SDLImageFieldNameGraphic).to(equal(@"graphic"));
        expect(SDLImageFieldNameShowConstantTBTIcon).to(equal(@"showConstantTBTIcon"));
        expect(SDLImageFieldNameShowConstantTBTNextTurnIcon).to(equal(@"showConstantTBTNextTurnIcon"));
        expect(SDLImageFieldNameLocationImage).to(equal(@"locationImage"));
    });
});

QuickSpecEnd
