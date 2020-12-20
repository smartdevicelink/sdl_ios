//
//  SDLScreenParamsSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLConfigurableKeyboards.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLConfigurableKeyboardsSpec)

SDLKeyboardLayout keyboardLayout = SDLKeyboardLayoutNumeric;
NSNumber *numConfigurableKeys = @123;

describe(@"getter/setter tests", ^{
    context(@"init", ^{
        SDLConfigurableKeyboards* testStruct = [[SDLConfigurableKeyboards alloc] init];

        it(@"should return nil if not set", ^{
            expect(testStruct.keyboardLayout).to(beNil());
            expect(testStruct.numConfigurableKeys).to(beNil());
        });
    });

    context(@"init and assign", ^{
        SDLConfigurableKeyboards* testStruct = [[SDLConfigurableKeyboards alloc] init];
        testStruct.keyboardLayout = keyboardLayout;
        testStruct.numConfigurableKeys = numConfigurableKeys;

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.keyboardLayout).to(equal(keyboardLayout));
            expect(testStruct.numConfigurableKeys).to(equal(numConfigurableKeys));
        });
    });

    context(@"initWithDictionary:", ^{
        NSDictionary<NSString *, id> *dict = @{
            SDLRPCParameterNameKeyboardLayout: keyboardLayout,
            SDLRPCParameterNameNumConfigurableKeys: numConfigurableKeys,
        };
        SDLConfigurableKeyboards* testStruct = [[SDLConfigurableKeyboards alloc] initWithDictionary:dict];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.keyboardLayout).to(equal(keyboardLayout));
            expect(testStruct.numConfigurableKeys).to(equal(numConfigurableKeys));
        });
    });

    context(@"initWithKeyboardLayout:numConfigurableKeys:", ^{
        SDLConfigurableKeyboards* testStruct = [[SDLConfigurableKeyboards alloc] initWithKeyboardLayout:keyboardLayout numConfigurableKeys:numConfigurableKeys.intValue];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.keyboardLayout).to(equal(keyboardLayout));
            expect(testStruct.numConfigurableKeys).to(equal(numConfigurableKeys));
        });
    });
});

QuickSpecEnd
