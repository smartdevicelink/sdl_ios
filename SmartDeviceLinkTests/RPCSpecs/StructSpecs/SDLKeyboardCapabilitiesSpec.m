//
//  SDLScreenParamsSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLConfigurableKeyboards.h"
#import "SDLKeyboardCapabilities.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLKeyboardCapabilitiesSpec)

NSNumber *maskInputCharactersSupported = @YES;
NSArray<SDLKeyboardLayout> *supportedKeyboardLayouts = @[SDLKeyboardLayoutNumeric];
NSArray<SDLConfigurableKeyboards *> *configurableKeys = @[[[SDLConfigurableKeyboards alloc] init]];

describe(@"getter/setter tests", ^{
    context(@"init", ^{
        SDLKeyboardCapabilities* testStruct = [[SDLKeyboardCapabilities alloc] init];

        it(@"should return nil if not set", ^{
            expect(testStruct.maskInputCharactersSupported).to(beNil());
            expect(testStruct.supportedKeyboardLayouts).to(beNil());
            expect(testStruct.configurableKeys).to(beNil());
        });
    });

    context(@"init and assign", ^{
        SDLKeyboardCapabilities* testStruct = [[SDLKeyboardCapabilities alloc] init];
        testStruct.maskInputCharactersSupported = maskInputCharactersSupported;
        testStruct.supportedKeyboardLayouts = supportedKeyboardLayouts;
        testStruct.configurableKeys = configurableKeys;

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.maskInputCharactersSupported).to(equal(maskInputCharactersSupported));
            expect(testStruct.supportedKeyboardLayouts).to(equal(supportedKeyboardLayouts));
            expect(testStruct.configurableKeys).to(equal(configurableKeys));
        });
    });

    context(@"initWithDictionary:", ^{
        NSDictionary<NSString *, id> *dict = @{
            SDLRPCParameterNameMaskInputCharactersSupported: maskInputCharactersSupported,
            SDLRPCParameterNameSupportedKeyboardLayouts: supportedKeyboardLayouts,
            SDLRPCParameterNameConfigurableKeys: configurableKeys,
        };
        SDLKeyboardCapabilities* testStruct = [[SDLKeyboardCapabilities alloc] initWithDictionary:dict];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.maskInputCharactersSupported).to(equal(maskInputCharactersSupported));
            expect(testStruct.supportedKeyboardLayouts).to(equal(supportedKeyboardLayouts));
            expect(testStruct.configurableKeys).to(equal(configurableKeys));
        });
    });

    context(@"initWithMaskInputCharactersSupported:supportedKeyboardLayouts:configurableKeys:", ^{
        SDLKeyboardCapabilities* testStruct = [[SDLKeyboardCapabilities alloc] initWithMaskInputCharactersSupported:maskInputCharactersSupported supportedKeyboardLayouts:supportedKeyboardLayouts configurableKeys:configurableKeys];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.maskInputCharactersSupported).to(equal(maskInputCharactersSupported));
            expect(testStruct.supportedKeyboardLayouts).to(equal(supportedKeyboardLayouts));
            expect(testStruct.configurableKeys).to(equal(configurableKeys));
        });
    });
});

QuickSpecEnd
