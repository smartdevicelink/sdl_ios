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
    
    
    it(@"Should set and get correctly", ^ {
        SDLDisplayCapability* testStruct = [[SDLDisplayCapability alloc] init];
        
        testStruct.displayName = @"Display Name";
        
        SDLWindowTypeCapabilities* testWindowTypeCapabilities = [[SDLWindowTypeCapabilities alloc] initWithType:SDLWindowTypeMain maximumNumberOfWindows:4];
        testStruct.windowTypeSupported = @[testWindowTypeCapabilities];
        
        
        SDLWindowCapability* WindowCapability = [[SDLWindowCapability alloc] init];
        
        WindowCapability.windowID = @444;
        
        SDLTextField *testTextField = [[SDLTextField alloc] init];
        testTextField.name = @"test text field";
        WindowCapability.textFields = @[testTextField];
        
        SDLImageField *testImageField = [[SDLImageField alloc] init];
        testImageField.name = @"test Image field";
        WindowCapability.imageFields = @[testImageField];
        
        SDLImageType imageType = SDLImageTypeDynamic;
        WindowCapability.imageTypeSupported = @[imageType];
        
        WindowCapability.numCustomPresetsAvailable = @10;
        
        SDLButtonCapabilities *buttonCapabilities = [[SDLButtonCapabilities alloc] init];
        buttonCapabilities.name = SDLButtonNameOk;
        buttonCapabilities.shortPressAvailable = @YES;
        buttonCapabilities.longPressAvailable = @YES;
        buttonCapabilities.upDownAvailable = @YES;
        WindowCapability.buttonCapabilities = @[buttonCapabilities];
        
        SDLSoftButtonCapabilities *capabilities = [[SDLSoftButtonCapabilities alloc] init];
        capabilities.imageSupported = @YES;
        
        WindowCapability.softButtonCapabilities = @[buttonCapabilities];
        
        testStruct.windowCapabilities = @[WindowCapability];
        

        expect(testStruct.displayName).to(equal(@"Display Name"));
        
        expect(testStruct.windowTypeSupported.firstObject.type).to(equal(SDLWindowTypeMain));
        expect(testStruct.windowTypeSupported.firstObject.maximumNumberOfWindows).to(equal(@4));
        
        expect(testStruct.windowCapabilities.firstObject.windowID).to(equal(444));
        
        expect(testStruct.windowCapabilities.firstObject.textFields.firstObject.name).to(equal(@"test text field"));
        expect(testStruct.windowCapabilities.firstObject.imageFields.firstObject.name).to(equal(@"test Image field"));
        
        expect(testStruct.windowCapabilities.firstObject.numCustomPresetsAvailable).to(equal(@10));
        
        expect(testStruct.windowCapabilities.firstObject.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
        expect(testStruct.windowCapabilities.firstObject.buttonCapabilities.firstObject.shortPressAvailable).to(equal(@YES));
        expect(testStruct.windowCapabilities.firstObject.buttonCapabilities.firstObject.longPressAvailable).to(equal(@YES));
        expect(testStruct.windowCapabilities.firstObject.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
    });
});

QuickSpecEnd
