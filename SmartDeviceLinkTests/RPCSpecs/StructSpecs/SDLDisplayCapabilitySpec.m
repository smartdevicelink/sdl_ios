//
//  SDLDisplayCapabilitySpec.m
//  SmartDeviceLinkTests

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapability.h"
#import "SDLImageField.h"
#import "SDLImageType.h"
#import "SDLRPCParameterNames.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLTextField.h"
#import "SDLWindowCapability.h"
#import "SDLWindowTypeCapabilities.h"

QuickSpecBegin(SDLDisplayCapabilitySpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLWindowCapability* testWindowCapability = nil;
    __block SDLWindowTypeCapabilities* testWindowTypeCapabilities = nil;
    __block SDLTextField *testTextField = nil;
    __block SDLImageField *testImageField = nil;
    __block SDLButtonCapabilities *testButtonCapabilities = nil;
    __block SDLSoftButtonCapabilities *testSoftButtonscapabilities = nil;
    __block SDLImageType testImageType = nil;
    __block NSString *testDisplayName = nil;
    __block NSString *testTextName = nil;
    __block NSString *testImageName = nil;
    __block int testMaximunNumberOfWindows = 4;
    
    beforeEach(^{
        testImageType = SDLImageTypeDynamic;
        testDisplayName = @"Display Name";
        testTextName = @"test Text field";
        testImageName = @"test Image field";
        
        testWindowTypeCapabilities = [[SDLWindowTypeCapabilities alloc] initWithType:testImageType maximumNumberOfWindows:testMaximunNumberOfWindows];
        
        testTextField = [[SDLTextField alloc] init];
        testTextField.name = testTextName;
        
        testImageField = [[SDLImageField alloc] init];
        testImageField.name = testImageName;
        
        testButtonCapabilities = [[SDLButtonCapabilities alloc] init];
        testButtonCapabilities.name = SDLButtonNameOk;
        testButtonCapabilities.shortPressAvailable = @YES;
        testButtonCapabilities.longPressAvailable = @YES;
        testButtonCapabilities.upDownAvailable = @YES;
        
        testSoftButtonscapabilities = [[SDLSoftButtonCapabilities alloc] init];
        testSoftButtonscapabilities.imageSupported = @YES;
        
        testWindowCapability = [[SDLWindowCapability alloc] init];
        testWindowCapability.windowID = @444;
        testWindowCapability.numCustomPresetsAvailable = @10;
        testWindowCapability.textFields = @[testTextField];
        testWindowCapability.imageFields = @[testImageField];
        testWindowCapability.imageTypeSupported = @[testImageType];
        testWindowCapability.buttonCapabilities = @[testButtonCapabilities];
        testWindowCapability.softButtonCapabilities = @[testSoftButtonscapabilities];
    });

    it(@"Should set and get correctly", ^ {
        SDLDisplayCapability *testStruct = [[SDLDisplayCapability alloc] init];
        testStruct.displayName = testDisplayName;
        testStruct.windowCapabilities = @[testWindowCapability];
        testStruct.windowTypeSupported = @[testWindowTypeCapabilities];
        
        expect(testStruct.displayName).to(equal(testDisplayName));
        expect(testStruct.windowTypeSupported.firstObject.type).to(equal(testImageType));
        expect(testStruct.windowTypeSupported.firstObject.maximumNumberOfWindows).to(equal(testMaximunNumberOfWindows));
        expect(testStruct.windowCapabilities.firstObject.windowID).to(equal(444));
        expect(testStruct.windowCapabilities.firstObject.textFields.firstObject.name).to(equal(testTextName));
        expect(testStruct.windowCapabilities.firstObject.imageFields.firstObject.name).to(equal(testImageName));
        expect(testStruct.windowCapabilities.firstObject.numCustomPresetsAvailable).to(equal(@10));
        expect(testStruct.windowCapabilities.firstObject.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
        expect(testStruct.windowCapabilities.firstObject.buttonCapabilities.firstObject.shortPressAvailable).to(equal(@YES));
        expect(testStruct.windowCapabilities.firstObject.buttonCapabilities.firstObject.longPressAvailable).to(equal(@YES));
        expect(testStruct.windowCapabilities.firstObject.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
    });

    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameDisplayName: testDisplayName,
                               SDLRPCParameterNameWindowCapabilities: @[testWindowCapability],
                               SDLRPCParameterNameWindowTypeSupported: @[testWindowTypeCapabilities]};
        SDLDisplayCapability *testStruct = [[SDLDisplayCapability alloc] initWithDictionary:dict];

        expect(testStruct.displayName).to(equal(testDisplayName));
        expect(testStruct.windowCapabilities).to(equal(@[testWindowCapability]));
        expect(testStruct.windowTypeSupported).to(equal(@[testWindowTypeCapabilities]));
    });

    it(@"Should initialize correctly with initWithDisplayName:", ^{
        SDLDisplayCapability *testStruct = [[SDLDisplayCapability alloc] initWithDisplayName:testDisplayName];

        expect(testStruct.displayName).to(equal(testDisplayName));
        expect(testStruct.windowCapabilities).to(beNil());
        expect(testStruct.windowTypeSupported).to(beNil());
    });

    it(@"Should initialize correctly with initWithDisplayName:windowCapabilities:windowTypeSupported:", ^{
        SDLDisplayCapability *testStruct = [[SDLDisplayCapability alloc] initWithDisplayName:testDisplayName windowCapabilities:@[testWindowCapability] windowTypeSupported:@[testWindowTypeCapabilities]];

        expect(testStruct.displayName).to(equal(testDisplayName));
        expect(testStruct.windowCapabilities).to(equal(@[testWindowCapability]));
        expect(testStruct.windowTypeSupported).to(equal(@[testWindowTypeCapabilities]));
    });

    it(@"Should be nil if not set", ^{
        SDLDisplayCapability *testStruct = [[SDLDisplayCapability alloc] init];

        expect(testStruct.displayName).to(beNil());
        expect(testStruct.windowCapabilities).to(beNil());
        expect(testStruct.windowTypeSupported).to(beNil());
    });
});

QuickSpecEnd
