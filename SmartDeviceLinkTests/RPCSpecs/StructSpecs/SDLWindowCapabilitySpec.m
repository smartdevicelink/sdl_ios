//
//  SDLWindowCapabilitySpec.m
//  SmartDeviceLinkTests

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLWindowCapability.h"
#import "SDLRPCParameterNames.h"
#import "SDLTextField.h"
#import "SDLImageField.h"
#import "SDLImageType.h"
#import "SDLButtonCapabilities.h"
#import "SDLSoftButtonCapabilities.h"

QuickSpecBegin(SDLWindowCapabilitySpec)

describe(@"Getter/Setter Tests", ^ {
    
    __block SDLTextField *testTextField = nil;
    __block SDLImageField *testImageField = nil;
    __block SDLButtonCapabilities *testButtonCapabilities = nil;
    __block SDLSoftButtonCapabilities *testSoftButtonscapabilities = nil;
    __block SDLImageType testImageType = nil;
    __block NSString *testTextName = nil;
    __block NSString *testImageName = nil;
    
    beforeEach(^{
        testImageType = SDLImageTypeDynamic;
        testTextName = @"test Text field";
        testImageName = @"test Image field";
        
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
    });
    
    it(@"Should set and get correctly", ^ {
        SDLWindowCapability* testStruct = testStruct = [[SDLWindowCapability alloc] init];
        testStruct.windowID = @444;
        testStruct.numCustomPresetsAvailable = @10;
        testStruct.textFields = @[testTextField];
        testStruct.imageFields = @[testImageField];
        testStruct.imageTypeSupported = @[testImageType];
        testStruct.buttonCapabilities = @[testButtonCapabilities];
        testStruct.softButtonCapabilities = @[testSoftButtonscapabilities];
        
        expect(testStruct.windowID).to(equal(@444));
        expect(testStruct.textFields.firstObject.name).to(equal(testTextName));
        expect(testStruct.imageFields.firstObject.name).to(equal(testImageName));
        expect(testStruct.numCustomPresetsAvailable).to(equal(@10));
        expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
        expect(testStruct.buttonCapabilities.firstObject.shortPressAvailable).to(equal(@YES));
        expect(testStruct.buttonCapabilities.firstObject.longPressAvailable).to(equal(@YES));
        expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
        expect(testStruct.softButtonCapabilities.firstObject.imageSupported).to(equal(@YES));
    });
    
});

QuickSpecEnd
