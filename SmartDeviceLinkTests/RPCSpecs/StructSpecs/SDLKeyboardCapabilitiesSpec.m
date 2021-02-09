//
//  SDLKeyboardCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeyboardCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "SDLKeyboardLayoutCapability.h"

QuickSpecBegin(SDLKeyboardCapabilitiesSpec)

NSNumber *maskInputCharactersSupported = @YES;
SDLKeyboardLayoutCapability *keyboardLayoutCapability = [[SDLKeyboardLayoutCapability alloc] init];
NSArray<SDLKeyboardLayoutCapability *> *supportedKeyboards = @[keyboardLayoutCapability];
__block SDLKeyboardCapabilities* testStruct = nil;

describe(@"getter/setter tests", ^{
    afterEach(^{
        testStruct = nil;
    });
    
    context(@"init", ^{
        beforeEach(^{
            testStruct = [[SDLKeyboardCapabilities alloc] init];
        });

        it(@"should return nil if not set", ^{
            expect(testStruct.maskInputCharactersSupported).to(beNil());
            expect(testStruct.supportedKeyboards).to(beNil());
        });
    });

    context(@"init and assign", ^{
        beforeEach(^{
            testStruct = [[SDLKeyboardCapabilities alloc] init];
            testStruct.maskInputCharactersSupported = maskInputCharactersSupported;
            testStruct.supportedKeyboards = supportedKeyboards;
        });

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.maskInputCharactersSupported).to(equal(maskInputCharactersSupported));
            expect(testStruct.supportedKeyboards).to(equal(supportedKeyboards));
        });
    });

    context(@"initWithDictionary:", ^{
        beforeEach(^{
            NSDictionary<NSString *, id> *dict = @{
                SDLRPCParameterNameMaskInputCharactersSupported: maskInputCharactersSupported,
                SDLRPCParameterNameSupportedKeyboards: supportedKeyboards,
            };
            testStruct = [[SDLKeyboardCapabilities alloc] initWithDictionary:dict];
        });

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.maskInputCharactersSupported).to(equal(maskInputCharactersSupported));
            expect(testStruct.supportedKeyboards).to(equal(supportedKeyboards));
        });
    });

    context(@"initWithMaskInputCharactersSupported:supportedKeyboards:", ^{
        beforeEach(^{
            testStruct = [[SDLKeyboardCapabilities alloc] initWithMaskInputCharactersSupported:maskInputCharactersSupported supportedKeyboards:supportedKeyboards];
        });

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.maskInputCharactersSupported).to(equal(maskInputCharactersSupported));
            expect(testStruct.supportedKeyboards).to(equal(supportedKeyboards));
        });
    });
});

QuickSpecEnd
