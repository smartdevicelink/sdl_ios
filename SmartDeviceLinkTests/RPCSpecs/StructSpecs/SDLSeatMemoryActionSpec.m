//
//  SDLSeatMemoryActionSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLRPCParameterNames.h"
#import "SDLSeatMemoryAction.h"

QuickSpecBegin(SDLSeatMemoryActionSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSeatMemoryAction* testStruct = [[SDLSeatMemoryAction alloc] init];

        testStruct.id = @12;
        testStruct.action = SDLSeatMemoryActionTypeSave;
        testStruct.label = @"Save";

        expect(testStruct.id).to(equal(@12));
        expect(testStruct.action).to(equal(SDLSeatMemoryActionTypeSave));
        expect(testStruct.label).to(equal(@"Save"));

    });

    it(@"Should set and get correctly", ^ {
        SDLSeatMemoryAction* testStruct = [[SDLSeatMemoryAction alloc] initWithId:23 label:@"restore" action:SDLSeatMemoryActionTypeRestore];

        expect(testStruct.id).to(equal(@23));
        expect(testStruct.action).to(equal(SDLSeatMemoryActionTypeRestore));
        expect(testStruct.label).to(equal(@"restore"));

    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameId:@54,
                                       SDLRPCParameterNameLabel:@"none",
                                       SDLRPCParameterNameAction: SDLSeatMemoryActionTypeNone
                                       } mutableCopy];
        SDLSeatMemoryAction *testStruct = [[SDLSeatMemoryAction alloc] initWithDictionary:dict];

        expect(testStruct.id).to(equal(@54));
        expect(testStruct.action).to(equal(SDLSeatMemoryActionTypeNone));
        expect(testStruct.label).to(equal(@"none"));
    });

    it(@"Should return nil if not set", ^ {
        SDLSeatMemoryAction* testStruct = [[SDLSeatMemoryAction alloc] init];

        expect(testStruct.id).to(beNil());
        expect(testStruct.action).to(beNil());
        expect(testStruct.label).to(beNil());
    });
});

QuickSpecEnd
