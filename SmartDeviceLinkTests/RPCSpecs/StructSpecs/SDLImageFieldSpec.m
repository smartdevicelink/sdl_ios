//
//  SDLImageFieldSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFileType.h"
#import "SDLImageField.h"
#import "SDLImageFieldName.h"
#import "SDLImageResolution.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLImageFieldSpec)

describe(@"Getter/Setter Tests", ^ {
     __block SDLImageFieldName testName = nil;
     __block NSArray<SDLFileType> *testFileTypes = nil;
     __block SDLImageResolution *testResolution = nil;

    beforeEach(^{
        testName = SDLImageFieldNameAppIcon;
        testFileTypes = @[SDLFileTypePNG, SDLFileTypeJPEG];
        testResolution = [[SDLImageResolution alloc] initWithWidth:800 height:800];
    });

    it(@"Should set and get correctly", ^ {
        SDLImageField* testStruct = [[SDLImageField alloc] init];
        
        testStruct.name = testName;
        testStruct.imageTypeSupported = testFileTypes;
        testStruct.imageResolution = testResolution;
        
        expect(testStruct.name).to(equal(testName));
        expect(testStruct.imageTypeSupported).to(equal(testFileTypes));
        expect(testStruct.imageResolution).to(equal(testResolution));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameName: testName,
                               SDLRPCParameterNameImageTypeSupported: testFileTypes,
                               SDLRPCParameterNameImageResolution: testResolution};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLImageField* testStruct = [[SDLImageField alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.name).to(equal(testName));
        expect(testStruct.imageTypeSupported).to(equal(testFileTypes));
        expect(testStruct.imageResolution).to(equal(testResolution));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLImageField* testStruct = [[SDLImageField alloc] init];
        
        expect(testStruct.name).to(beNil());
        expect(testStruct.imageTypeSupported).to(beNil());
        expect(testStruct.imageResolution).to(beNil());
    });

    it(@"should initialize correctly with initWithName:imageTypeSupported:imageResolution:", ^{
        SDLImageField *testStruct = [[SDLImageField alloc] initWithName:testName imageTypeSupported:testFileTypes imageResolution:testResolution];

        expect(testStruct.name).to(equal(testName));
        expect(testStruct.imageTypeSupported).to(equal(testFileTypes));
        expect(testStruct.imageResolution).to(equal(testResolution));
    });
});

QuickSpecEnd
