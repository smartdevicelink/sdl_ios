//
//  SDLButtonNameSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonName.h"

QuickSpecBegin(SDLButtonNameSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLButtonName OK].value).to(equal(@"OK"));
        expect([SDLButtonName SEEKLEFT].value).to(equal(@"SEEKLEFT"));
        expect([SDLButtonName SEEKRIGHT].value).to(equal(@"SEEKRIGHT"));
        expect([SDLButtonName TUNEUP].value).to(equal(@"TUNEUP"));
        expect([SDLButtonName TUNEDOWN].value).to(equal(@"TUNEDOWN"));
        expect([SDLButtonName PRESET_0].value).to(equal(@"PRESET_0"));
        expect([SDLButtonName PRESET_1].value).to(equal(@"PRESET_1"));
        expect([SDLButtonName PRESET_2].value).to(equal(@"PRESET_2"));
        expect([SDLButtonName PRESET_3].value).to(equal(@"PRESET_3"));
        expect([SDLButtonName PRESET_4].value).to(equal(@"PRESET_4"));
        expect([SDLButtonName PRESET_5].value).to(equal(@"PRESET_5"));
        expect([SDLButtonName PRESET_6].value).to(equal(@"PRESET_6"));
        expect([SDLButtonName PRESET_7].value).to(equal(@"PRESET_7"));
        expect([SDLButtonName PRESET_8].value).to(equal(@"PRESET_8"));
        expect([SDLButtonName PRESET_9].value).to(equal(@"PRESET_9"));
        expect([SDLButtonName CUSTOM_BUTTON].value).to(equal(@"CUSTOM_BUTTON"));
        expect([SDLButtonName SEARCH].value).to(equal(@"SEARCH"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLButtonName valueOf:@"OK"]).to(equal([SDLButtonName OK]));
        expect([SDLButtonName valueOf:@"SEEKLEFT"]).to(equal([SDLButtonName SEEKLEFT]));
        expect([SDLButtonName valueOf:@"SEEKRIGHT"]).to(equal([SDLButtonName SEEKRIGHT]));
        expect([SDLButtonName valueOf:@"TUNEUP"]).to(equal([SDLButtonName TUNEUP]));
        expect([SDLButtonName valueOf:@"TUNEDOWN"]).to(equal([SDLButtonName TUNEDOWN]));
        expect([SDLButtonName valueOf:@"PRESET_0"]).to(equal([SDLButtonName PRESET_0]));
        expect([SDLButtonName valueOf:@"PRESET_1"]).to(equal([SDLButtonName PRESET_1]));
        expect([SDLButtonName valueOf:@"PRESET_2"]).to(equal([SDLButtonName PRESET_2]));
        expect([SDLButtonName valueOf:@"PRESET_3"]).to(equal([SDLButtonName PRESET_3]));
        expect([SDLButtonName valueOf:@"PRESET_4"]).to(equal([SDLButtonName PRESET_4]));
        expect([SDLButtonName valueOf:@"PRESET_5"]).to(equal([SDLButtonName PRESET_5]));
        expect([SDLButtonName valueOf:@"PRESET_6"]).to(equal([SDLButtonName PRESET_6]));
        expect([SDLButtonName valueOf:@"PRESET_7"]).to(equal([SDLButtonName PRESET_7]));
        expect([SDLButtonName valueOf:@"PRESET_8"]).to(equal([SDLButtonName PRESET_8]));
        expect([SDLButtonName valueOf:@"PRESET_9"]).to(equal([SDLButtonName PRESET_9]));
        expect([SDLButtonName valueOf:@"CUSTOM_BUTTON"]).to(equal([SDLButtonName CUSTOM_BUTTON]));
        expect([SDLButtonName valueOf:@"SEARCH"]).to(equal([SDLButtonName SEARCH]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLButtonName valueOf:nil]).to(beNil());
        expect([SDLButtonName valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLButtonName values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLButtonName OK],
                        [SDLButtonName SEEKLEFT],
                        [SDLButtonName SEEKRIGHT],
                        [SDLButtonName TUNEUP],
                        [SDLButtonName TUNEDOWN],
                        [SDLButtonName PRESET_0],
                        [SDLButtonName PRESET_1],
                        [SDLButtonName PRESET_2],
                        [SDLButtonName PRESET_3],
                        [SDLButtonName PRESET_4],
                        [SDLButtonName PRESET_5],
                        [SDLButtonName PRESET_6],
                        [SDLButtonName PRESET_7],
                        [SDLButtonName PRESET_8],
                        [SDLButtonName PRESET_9],
                        [SDLButtonName CUSTOM_BUTTON],
                        [SDLButtonName SEARCH]] copy];
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