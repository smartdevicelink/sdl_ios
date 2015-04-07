//
//  SDLRequestTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRequestType.h"

QuickSpecBegin(SDLRequestTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLRequestType HTTP].value).to(equal(@"HTTP"));
        expect([SDLRequestType FILE_RESUME].value).to(equal(@"FILE_RESUME"));
        expect([SDLRequestType AUTH_REQUEST].value).to(equal(@"AUTH_REQUEST"));
        expect([SDLRequestType AUTH_CHALLENGE].value).to(equal(@"AUTH_CHALLENGE"));
        expect([SDLRequestType AUTH_ACK].value).to(equal(@"AUTH_ACK"));
        expect([SDLRequestType PROPRIETARY].value).to(equal(@"PROPRIETARY"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLRequestType valueOf:@"HTTP"]).to(equal([SDLRequestType HTTP]));
        expect([SDLRequestType valueOf:@"FILE_RESUME"]).to(equal([SDLRequestType FILE_RESUME]));
        expect([SDLRequestType valueOf:@"AUTH_REQUEST"]).to(equal([SDLRequestType AUTH_REQUEST]));
        expect([SDLRequestType valueOf:@"AUTH_CHALLENGE"]).to(equal([SDLRequestType AUTH_CHALLENGE]));
        expect([SDLRequestType valueOf:@"AUTH_ACK"]).to(equal([SDLRequestType AUTH_ACK]));
        expect([SDLRequestType valueOf:@"PROPRIETARY"]).to(equal([SDLRequestType PROPRIETARY]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLRequestType valueOf:nil]).to(beNil());
        expect([SDLRequestType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLRequestType values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLRequestType HTTP],
                        [SDLRequestType FILE_RESUME],
                        [SDLRequestType AUTH_REQUEST],
                        [SDLRequestType AUTH_CHALLENGE],
                        [SDLRequestType AUTH_ACK],
                        [SDLRequestType PROPRIETARY]] mutableCopy];
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