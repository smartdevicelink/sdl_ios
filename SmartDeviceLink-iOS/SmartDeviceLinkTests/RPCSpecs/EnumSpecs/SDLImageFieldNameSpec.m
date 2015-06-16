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
        expect([SDLImageFieldName softButtonImage].value).to(equal(@"softButtonImage"));
        expect([SDLImageFieldName choiceImage].value).to(equal(@"choiceImage"));
        expect([SDLImageFieldName choiceSecondaryImage].value).to(equal(@"choiceSecondaryImage"));
        expect([SDLImageFieldName vrHelpItem].value).to(equal(@"vrHelpItem"));
        expect([SDLImageFieldName turnIcon].value).to(equal(@"turnIcon"));
        expect([SDLImageFieldName menuIcon].value).to(equal(@"menuIcon"));
        expect([SDLImageFieldName cmdIcon].value).to(equal(@"cmdIcon"));
        expect([SDLImageFieldName appIcon].value).to(equal(@"appIcon"));
        expect([SDLImageFieldName graphic].value).to(equal(@"graphic"));
        expect([SDLImageFieldName showConstantTBTIcon].value).to(equal(@"showConstantTBTIcon"));
        expect([SDLImageFieldName showConstantTBTNextTurnIcon].value).to(equal(@"showConstantTBTNextTurnIcon"));
        expect([SDLImageFieldName locationImage].value).to(equal(@"locationImage"));
    });
});

describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLImageFieldName valueOf:@"softButtonImage"]).to(equal([SDLImageFieldName softButtonImage]));
        expect([SDLImageFieldName valueOf:@"choiceImage"]).to(equal([SDLImageFieldName choiceImage]));
        expect([SDLImageFieldName valueOf:@"choiceSecondaryImage"]).to(equal([SDLImageFieldName choiceSecondaryImage]));
        expect([SDLImageFieldName valueOf:@"vrHelpItem"]).to(equal([SDLImageFieldName vrHelpItem]));
        expect([SDLImageFieldName valueOf:@"turnIcon"]).to(equal([SDLImageFieldName turnIcon]));
        expect([SDLImageFieldName valueOf:@"menuIcon"]).to(equal([SDLImageFieldName menuIcon]));
        expect([SDLImageFieldName valueOf:@"cmdIcon"]).to(equal([SDLImageFieldName cmdIcon]));
        expect([SDLImageFieldName valueOf:@"appIcon"]).to(equal([SDLImageFieldName appIcon]));
        expect([SDLImageFieldName valueOf:@"graphic"]).to(equal([SDLImageFieldName graphic]));
        expect([SDLImageFieldName valueOf:@"showConstantTBTIcon"]).to(equal([SDLImageFieldName showConstantTBTIcon]));
        expect([SDLImageFieldName valueOf:@"showConstantTBTNextTurnIcon"]).to(equal([SDLImageFieldName showConstantTBTNextTurnIcon]));
        expect([SDLImageFieldName valueOf:@"locationImage"]).to(equal([SDLImageFieldName locationImage]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLImageFieldName valueOf:nil]).to(beNil());
        expect([SDLImageFieldName valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});

describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLImageFieldName values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLImageFieldName softButtonImage],
                        [SDLImageFieldName choiceImage],
                        [SDLImageFieldName choiceSecondaryImage],
                        [SDLImageFieldName vrHelpItem],
                        [SDLImageFieldName turnIcon],
                        [SDLImageFieldName menuIcon],
                        [SDLImageFieldName cmdIcon],
                        [SDLImageFieldName appIcon],
                        [SDLImageFieldName graphic],
                        [SDLImageFieldName showConstantTBTIcon],
                        [SDLImageFieldName locationImage],
                        [SDLImageFieldName showConstantTBTNextTurnIcon]] copy];
        
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd