//
//  SDLDisplayCapabilitySpec.m
//  SmartDeviceLinkTests

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLWindowTypeCapabilities.h"
#import "SDLWindowCapability.h"
#import "SDLDisplayCapability.h"
#import "SDLTextField.h"
#import "SDLImageField.h"
#import "SDLImageType.h"
#import "SDLButtonCapabilities.h"
#import "SDLSoftButtonCapabilities.h"

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
        testImageField.name = testTextName;
        
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
        SDLDisplayCapability* testStruct = [[SDLDisplayCapability alloc] init];
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
});

QuickSpecEnd
