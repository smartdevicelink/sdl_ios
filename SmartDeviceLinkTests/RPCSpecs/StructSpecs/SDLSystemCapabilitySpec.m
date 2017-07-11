#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSystemCapability.h"

#import "SDLNavigationCapability.h"
#import "SDLPhoneCapability.h"
#import "SDLSystemCapabilityType.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSystemCapabilitySpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] init];

        testStruct.systemCapabilityType = [SDLSystemCapabilityType NAVIGATION];
        testStruct.navigationCapability = [[SDLNavigationCapability alloc] initWithSendLocation:YES waypoints:NO];
        testStruct.phoneCapability = [[SDLPhoneCapability alloc] initWithDialNumber:YES];

        expect(testStruct.systemCapabilityType).to(equal([SDLSystemCapabilityType NAVIGATION]));
        expect(testStruct.navigationCapability.sendLocationEnabled).to(equal(YES));
        expect(testStruct.navigationCapability.getWayPointsEnabled).to(equal(NO));
        expect(testStruct.phoneCapability.dialNumberEnabled).to(equal(YES));
    });
});

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSMutableDictionary* dict = [@{NAMES_systemCapabilityType: @"NAVIGATION",
                                       NAMES_navigationCapability: @{NAMES_getWayPointsEnabled: @(NO),
                                                                     NAMES_sendLocationEnabled: @(YES)},
                                       NAMES_phoneCapability: @{NAMES_dialNumberEnabled: @(YES)}} mutableCopy];
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithDictionary:dict];

        expect(testStruct.systemCapabilityType).to(equal([SDLSystemCapabilityType NAVIGATION]));
        expect(testStruct.navigationCapability.sendLocationEnabled).to(equal(YES));
        expect(testStruct.navigationCapability.getWayPointsEnabled).to(equal(NO));
        expect(testStruct.phoneCapability.dialNumberEnabled).to(equal(YES));
    });

    it(@"Should return nil if not set", ^ {
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] init];

        expect(testStruct.systemCapabilityType).to(beNil());
        expect(testStruct.navigationCapability).to(beNil());
        expect(testStruct.phoneCapability).to(beNil());
    });

    it(@"should initialize correctly with initWithPhoneCapability:", ^{
        SDLPhoneCapability *testPhoneStruct = [[SDLPhoneCapability alloc] initWithDialNumber:YES];
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithPhoneCapability:testPhoneStruct];

        expect(testStruct.systemCapabilityType).to(equal([SDLSystemCapabilityType PHONE_CALL]));
        expect(testStruct.phoneCapability.dialNumberEnabled).to(equal(YES));
        expect(testStruct.navigationCapability).to(beNil());
    });

    it(@"should initialize correctly with initWithNavigationCapability:", ^{
        SDLNavigationCapability *testNavStruct = [[SDLNavigationCapability alloc] initWithSendLocation:YES waypoints:YES];
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithNavigationCapability:testNavStruct];

        expect(testStruct.systemCapabilityType).to(equal([SDLSystemCapabilityType NAVIGATION]));
        expect(testStruct.navigationCapability.sendLocationEnabled).to(equal(YES));
        expect(testStruct.navigationCapability.getWayPointsEnabled).to(equal(YES));
        expect(testStruct.phoneCapability).to(beNil());
    });
});

QuickSpecEnd
