#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNavigationCapability.h"
#import "SDLNames.h"

QuickSpecBegin(SDLNavigationCapabilitySpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLNavigationCapability *testStruct = [[SDLNavigationCapability alloc] init];

        testStruct.getWayPointsEnabled = @(YES);
        testStruct.sendLocationEnabled = @(YES);

        expect(testStruct.getWayPointsEnabled).to(equal(YES));
        expect(testStruct.sendLocationEnabled).to(equal(YES));

    });
});

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{SDLNameGetWayPointsEnabled: @(YES),
                                       SDLNameSendLocationEnabled: @(YES)};
        SDLNavigationCapability* testStruct = [[SDLNavigationCapability alloc] initWithDictionary:dict];

        expect(testStruct.getWayPointsEnabled).to(equal(YES));
        expect(testStruct.sendLocationEnabled).to(equal(YES));
    });

    it(@"Should return nil if not set", ^ {
        SDLNavigationCapability* testStruct = [[SDLNavigationCapability alloc] init];

        expect(testStruct.getWayPointsEnabled).to(beNil());
        expect(testStruct.sendLocationEnabled).to(beNil());
    });

    it(@"should initialize correctly with initWithSendLocation:waypoints:", ^{
        SDLNavigationCapability *testStruct = [[SDLNavigationCapability alloc] initWithSendLocation:YES waypoints:YES];

        expect(testStruct.getWayPointsEnabled).to(equal(YES));
        expect(testStruct.sendLocationEnabled).to(equal(YES));
    });
});

QuickSpecEnd

