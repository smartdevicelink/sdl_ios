//
//  SDLComponentVolumeStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLComponentVolumeStatus.h"

QuickSpecBegin(SDLComponentVolumeStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLComponentVolumeStatus UNKNOWN].value).to(equal(@"UNKNOWN"));
        expect([SDLComponentVolumeStatus NORMAL].value).to(equal(@"NORMAL"));
        expect([SDLComponentVolumeStatus LOW].value).to(equal(@"LOW"));
        expect([SDLComponentVolumeStatus FAULT].value).to(equal(@"FAULT"));
        expect([SDLComponentVolumeStatus ALERT].value).to(equal(@"ALERT"));
        expect([SDLComponentVolumeStatus NOT_SUPPORTED].value).to(equal(@"NOT_SUPPORTED"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLComponentVolumeStatus valueOf:@"UNKNOWN"]).to(equal([SDLComponentVolumeStatus UNKNOWN]));
        expect([SDLComponentVolumeStatus valueOf:@"NORMAL"]).to(equal([SDLComponentVolumeStatus NORMAL]));
        expect([SDLComponentVolumeStatus valueOf:@"LOW"]).to(equal([SDLComponentVolumeStatus LOW]));
        expect([SDLComponentVolumeStatus valueOf:@"FAULT"]).to(equal([SDLComponentVolumeStatus FAULT]));
        expect([SDLComponentVolumeStatus valueOf:@"ALERT"]).to(equal([SDLComponentVolumeStatus ALERT]));
        expect([SDLComponentVolumeStatus valueOf:@"NOT_SUPPORTED"]).to(equal([SDLComponentVolumeStatus NOT_SUPPORTED]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLComponentVolumeStatus valueOf:nil]).to(beNil());
        expect([SDLComponentVolumeStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLComponentVolumeStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLComponentVolumeStatus UNKNOWN],
                        [SDLComponentVolumeStatus NORMAL],
                        [SDLComponentVolumeStatus LOW],
                        [SDLComponentVolumeStatus FAULT],
                        [SDLComponentVolumeStatus ALERT],
                        [SDLComponentVolumeStatus NOT_SUPPORTED]] copy];
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
