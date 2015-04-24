//
//  SDLTBTStateSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTBTState.h"

QuickSpecBegin(SDLTBTStateSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLTBTState ROUTE_UPDATE_REQUEST].value).to(equal(@"ROUTE_UPDATE_REQUEST"));
        expect([SDLTBTState ROUTE_ACCEPTED].value).to(equal(@"ROUTE_ACCEPTED"));
        expect([SDLTBTState ROUTE_REFUSED].value).to(equal(@"ROUTE_REFUSED"));
        expect([SDLTBTState ROUTE_CANCELLED].value).to(equal(@"ROUTE_CANCELLED"));
        expect([SDLTBTState ETA_REQUEST].value).to(equal(@"ETA_REQUEST"));
        expect([SDLTBTState NEXT_TURN_REQUEST].value).to(equal(@"NEXT_TURN_REQUEST"));
        expect([SDLTBTState ROUTE_STATUS_REQUEST].value).to(equal(@"ROUTE_STATUS_REQUEST"));
        expect([SDLTBTState ROUTE_SUMMARY_REQUEST].value).to(equal(@"ROUTE_SUMMARY_REQUEST"));
        expect([SDLTBTState TRIP_STATUS_REQUEST].value).to(equal(@"TRIP_STATUS_REQUEST"));
        expect([SDLTBTState ROUTE_UPDATE_REQUEST_TIMEOUT].value).to(equal(@"ROUTE_UPDATE_REQUEST_TIMEOUT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLTBTState valueOf:@"ROUTE_UPDATE_REQUEST"]).to(equal([SDLTBTState ROUTE_UPDATE_REQUEST]));
        expect([SDLTBTState valueOf:@"ROUTE_ACCEPTED"]).to(equal([SDLTBTState ROUTE_ACCEPTED]));
        expect([SDLTBTState valueOf:@"ROUTE_REFUSED"]).to(equal([SDLTBTState ROUTE_REFUSED]));
        expect([SDLTBTState valueOf:@"ROUTE_CANCELLED"]).to(equal([SDLTBTState ROUTE_CANCELLED]));
        expect([SDLTBTState valueOf:@"ETA_REQUEST"]).to(equal([SDLTBTState ETA_REQUEST]));
        expect([SDLTBTState valueOf:@"NEXT_TURN_REQUEST"]).to(equal([SDLTBTState NEXT_TURN_REQUEST]));
        expect([SDLTBTState valueOf:@"ROUTE_STATUS_REQUEST"]).to(equal([SDLTBTState ROUTE_STATUS_REQUEST]));
        expect([SDLTBTState valueOf:@"ROUTE_SUMMARY_REQUEST"]).to(equal([SDLTBTState ROUTE_SUMMARY_REQUEST]));
        expect([SDLTBTState valueOf:@"TRIP_STATUS_REQUEST"]).to(equal([SDLTBTState TRIP_STATUS_REQUEST]));
        expect([SDLTBTState valueOf:@"ROUTE_UPDATE_REQUEST_TIMEOUT"]).to(equal([SDLTBTState ROUTE_UPDATE_REQUEST_TIMEOUT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLTBTState valueOf:nil]).to(beNil());
        expect([SDLTBTState valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLTBTState values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLTBTState ROUTE_UPDATE_REQUEST],
                        [SDLTBTState ROUTE_ACCEPTED],
                        [SDLTBTState ROUTE_REFUSED],
                        [SDLTBTState ROUTE_CANCELLED],
                        [SDLTBTState ETA_REQUEST],
                        [SDLTBTState NEXT_TURN_REQUEST],
                        [SDLTBTState ROUTE_STATUS_REQUEST],
                        [SDLTBTState ROUTE_SUMMARY_REQUEST],
                        [SDLTBTState TRIP_STATUS_REQUEST],
                        [SDLTBTState ROUTE_UPDATE_REQUEST_TIMEOUT]] copy];
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