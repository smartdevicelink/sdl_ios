#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPhoneCapability.h"
#import "SDLNames.h"

QuickSpecBegin(SDLPhoneCapabilitySpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPhoneCapability *testStruct = [[SDLPhoneCapability alloc] init];

        testStruct.dialNumberEnabled = @(YES);

        expect(testStruct.dialNumberEnabled).to(equal(YES));
    });
});

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSMutableDictionary* dict = [@{NAMES_dialNumberEnabled: @(YES)} mutableCopy];
        SDLPhoneCapability* testStruct = [[SDLPhoneCapability alloc] initWithDictionary:dict];

        expect(testStruct.dialNumberEnabled).to(equal(YES));
    });

    it(@"Should return nil if not set", ^ {
        SDLPhoneCapability* testStruct = [[SDLPhoneCapability alloc] init];

        expect(testStruct.dialNumberEnabled).to(beNil());
    });

    it(@"should initialize correctly with initWithDialNumber:", ^{
        SDLPhoneCapability *testStruct = [[SDLPhoneCapability alloc] initWithDialNumber:YES];

        expect(testStruct.dialNumberEnabled).to(equal(YES));
    });
});

QuickSpecEnd
