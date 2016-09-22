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
        expect(SDLImageFieldNameVrHelpItem).to(equal(@"vrHelpItem"));
        expect(SDLImageFieldNameTurnIcon).to(equal(@"turnIcon"));
        expect(SDLImageFieldNameMenuIcon).to(equal(@"menuIcon"));
        expect(SDLImageFieldNameCmdIcon).to(equal(@"cmdIcon"));
        expect(SDLImageFieldNameAppIcon).to(equal(@"appIcon"));
        expect(SDLImageFieldNameGraphic).to(equal(@"graphic"));
        expect(SDLImageFieldNameShowConstantTbtIcon).to(equal(@"showConstantTBTIcon"));
        expect(SDLImageFieldNameShowConstantTbtNextTurnIcon).to(equal(@"showConstantTBTNextTurnIcon"));
        expect(SDLImageFieldNameLocationImage).to(equal(@"locationImage"));
    });
});

QuickSpecEnd
