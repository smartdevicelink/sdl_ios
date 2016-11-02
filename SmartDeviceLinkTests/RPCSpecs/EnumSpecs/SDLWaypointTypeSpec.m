//  SDLWaypointTypeSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLWaypointType.h"

QuickSpecBegin(SDLWaypointTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLWaypointType ALL].value).to(equal(@"ALL"));
        expect([SDLWaypointType DESTINATION].value).to(equal(@"DESTINATION"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLWaypointType valueOf:@"ALL"]).to(equal([SDLWaypointType ALL]));
        expect([SDLWaypointType valueOf:@"DESTINATION"]).to(equal([SDLWaypointType DESTINATION]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLWaypointType valueOf:nil]).to(beNil());
        expect([SDLWaypointType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLWaypointType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLWaypointType ALL],
                           [SDLWaypointType DESTINATION]] copy];
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
