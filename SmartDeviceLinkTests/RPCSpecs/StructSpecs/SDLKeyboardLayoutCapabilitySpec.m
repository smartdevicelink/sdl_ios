//
//  SDLKeyboardLayoutCapabilitySpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeyboardCapabilities.h"
#import "SDLKeyboardLayout.h"
#import "SDLRPCParameterNames.h"
#import "SDLKeyboardLayoutCapability.h"

QuickSpecBegin(SDLKeyboardLayoutCapabilitySpec)

SDLKeyboardLayout keyboardLayout = SDLKeyboardLayoutNumeric;
UInt8 numConfigurableKeys = 9;
__block SDLKeyboardLayoutCapability* testStruct = nil;

describe(@"getter/setter tests", ^{
    context(@"init", ^{
        beforeEach(^{
            testStruct = [[SDLKeyboardLayoutCapability alloc] init];
        });

        it(@"should return nil if not set", ^{
            expect(testStruct.keyboardLayout).to(beNil());
            expect(testStruct.numConfigurableKeys).to(beNil());
        });
    });

    context(@"init and assign", ^{
        beforeEach(^{
            testStruct = [[SDLKeyboardLayoutCapability alloc] init];
            testStruct.numConfigurableKeys = @(numConfigurableKeys);
            testStruct.keyboardLayout = keyboardLayout;
        });

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.numConfigurableKeys).to(equal(@(numConfigurableKeys)));
            expect(testStruct.keyboardLayout).to(equal(keyboardLayout));
        });
    });

    context(@"initWithDictionary:", ^{
        beforeEach(^{
            NSDictionary<NSString *, id> *dict = @{
                SDLRPCParameterNameNumConfigurableKeys: @(numConfigurableKeys),
                SDLRPCParameterNameKeyboardLayout: keyboardLayout,
            };
            testStruct = [[SDLKeyboardLayoutCapability alloc] initWithDictionary:dict];
        });

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.numConfigurableKeys).to(equal(@(numConfigurableKeys)));
            expect(testStruct.keyboardLayout).to(equal(keyboardLayout));
        });
    });

    context(@"initWithKeyboardLayout:numConfigurableKeys:", ^{
        beforeEach(^{
            testStruct = [[SDLKeyboardLayoutCapability alloc] initWithKeyboardLayout:keyboardLayout numConfigurableKeys:numConfigurableKeys];
        });

        it(@"expect all properties to be set properly", ^{
            expect(testStruct).notTo(beNil());
            expect(testStruct.numConfigurableKeys).to(equal(@(numConfigurableKeys)));
            expect(testStruct.keyboardLayout).to(equal(keyboardLayout));
        });
    });
});

QuickSpecEnd
