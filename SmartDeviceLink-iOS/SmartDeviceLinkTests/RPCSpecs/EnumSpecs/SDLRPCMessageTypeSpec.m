//
//  SDLRPCMessageTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCMessageType.h"

QuickSpecBegin(SDLRPCMessageTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLRPCMessageType request].value).to(equal(@"request"));
        expect([SDLRPCMessageType response].value).to(equal(@"response"));
        expect([SDLRPCMessageType notification].value).to(equal(@"notification"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLRPCMessageType valueOf:@"request"]).to(equal([SDLRPCMessageType request]));
        expect([SDLRPCMessageType valueOf:@"response"]).to(equal([SDLRPCMessageType response]));
        expect([SDLRPCMessageType valueOf:@"notification"]).to(equal([SDLRPCMessageType notification]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLRPCMessageType valueOf:nil]).to(beNil());
        expect([SDLRPCMessageType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLRPCMessageType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLRPCMessageType request],
                           [SDLRPCMessageType response],
                           [SDLRPCMessageType notification]] copy];
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