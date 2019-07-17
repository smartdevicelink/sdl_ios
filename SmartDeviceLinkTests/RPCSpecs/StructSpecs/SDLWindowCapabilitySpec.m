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
    
    it(@"Should set and get correctly", ^ {
        SDLWindowCapability* testStruct = [[SDLWindowCapability alloc] init];
        
        testStruct.windowID = @444;
        
        SDLTextField *testTextField = [[SDLTextField alloc] init];
        testTextField.name = @"test text field";
        testStruct.textFields = @[testTextField];
        
        SDLImageField *testImageField = [[SDLImageField alloc] init];
        testImageField.name = @"test Image field";
        testStruct.imageFields = @[testImageField];
        
        SDLImageType imageType = SDLImageTypeDynamic;
        testStruct.imageTypeSupported = @[imageType];
        
        testStruct.numCustomPresetsAvailable = @10;
        
        SDLButtonCapabilities *buttonCapabilities = [[SDLButtonCapabilities alloc] init];
        buttonCapabilities.name = SDLButtonNameOk;
        buttonCapabilities.shortPressAvailable = @YES;
        buttonCapabilities.longPressAvailable = @YES;
        buttonCapabilities.upDownAvailable = @YES;
        testStruct.buttonCapabilities = @[buttonCapabilities];
        
        SDLSoftButtonCapabilities *capabilities = [[SDLSoftButtonCapabilities alloc] init];
        capabilities.imageSupported = @YES;
        
        testStruct.softButtonCapabilities = @[capabilities];
        
        expect(testStruct.windowID).to(equal(@444));
        
        expect(testStruct.textFields.firstObject.name).to(equal(@"test text field"));
        expect(testStruct.imageFields.firstObject.name).to(equal(@"test Image field"));
        
        expect(testStruct.numCustomPresetsAvailable).to(equal(@10));
        
        expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
        expect(testStruct.buttonCapabilities.firstObject.shortPressAvailable).to(equal(@YES));
        expect(testStruct.buttonCapabilities.firstObject.longPressAvailable).to(equal(@YES));
        expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
        
        expect(testStruct.softButtonCapabilities.firstObject.imageSupported).to(equal(@YES));
    });
    
});

QuickSpecEnd
