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

SDLImageResolution* resolution = [[SDLImageResolution alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLImageField* testStruct = [[SDLImageField alloc] init];
        
        testStruct.name = SDLImageFieldNameTurnIcon;
        testStruct.imageTypeSupported = [@[SDLFileTypePNG, SDLFileTypeJPEG] copy];
        testStruct.imageResolution = resolution;
        
        expect(testStruct.name).to(equal(SDLImageFieldNameTurnIcon));
        expect(testStruct.imageTypeSupported).to(equal([@[SDLFileTypePNG, SDLFileTypeJPEG] copy]));
        expect(testStruct.imageResolution).to(equal(resolution));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameName:SDLImageFieldNameTurnIcon,
                                       SDLRPCParameterNameImageTypeSupported:[@[SDLFileTypePNG, SDLFileTypeJPEG] copy],
                                       SDLRPCParameterNameImageResolution:resolution} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLImageField* testStruct = [[SDLImageField alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.name).to(equal(SDLImageFieldNameTurnIcon));
        expect(testStruct.imageTypeSupported).to(equal([@[SDLFileTypePNG, SDLFileTypeJPEG] copy]));
        expect(testStruct.imageResolution).to(equal(resolution));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLImageField* testStruct = [[SDLImageField alloc] init];
        
        expect(testStruct.name).to(beNil());
        expect(testStruct.imageTypeSupported).to(beNil());
        expect(testStruct.imageResolution).to(beNil());
    });
});

QuickSpecEnd
