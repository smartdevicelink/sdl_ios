//
//  SDLDisplayCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDisplayCapabilities.h"
#import "SDLDisplayType.h"
#import "SDLImageField.h"
#import "SDLMediaClockFormat.h"
#import "SDLNames.h"
#import "SDLScreenParams.h"
#import "SDLTextField.h"


QuickSpecBegin(SDLDisplayCapabilitiesSpec)

SDLScreenParams* screenParams = [[SDLScreenParams alloc] init];
SDLTextField* textField = [[SDLTextField alloc] init];
SDLImageField* imageField = [[SDLImageField alloc] init];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDisplayCapabilities* testStruct = [[SDLDisplayCapabilities alloc] init];
        
        testStruct.displayType = SDLDisplayTypeGen26DMA;
        testStruct.displayName = @"test";
        testStruct.textFields = [@[textField] mutableCopy];
        testStruct.imageFields = [@[imageField] mutableCopy];
        testStruct.mediaClockFormats = [@[SDLMediaClockFormatClockText1, SDLMediaClockFormatClock3, SDLMediaClockFormatClockText3] copy];
        testStruct.graphicSupported = @YES;
        testStruct.templatesAvailable = [@[@"String", @"String", @"String"] mutableCopy];
        testStruct.screenParams = screenParams;
        testStruct.numCustomPresetsAvailable = @43;
        
        expect(testStruct.displayType).to(equal(SDLDisplayTypeGen26DMA));
        expect(testStruct.displayName).to(equal(@"test"));
        expect(testStruct.textFields).to(equal([@[textField] mutableCopy]));
        expect(testStruct.imageFields).to(equal([@[imageField] mutableCopy]));
        expect(testStruct.mediaClockFormats).to(equal([@[SDLMediaClockFormatClockText1, SDLMediaClockFormatClock3, SDLMediaClockFormatClockText3] copy]));
        expect(testStruct.graphicSupported).to(equal(@YES));
        expect(testStruct.templatesAvailable).to(equal([@[@"String", @"String", @"String"] mutableCopy]));
        expect(testStruct.screenParams).to(equal(screenParams));
        expect(testStruct.numCustomPresetsAvailable).to(equal(@43));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameDisplayType:SDLDisplayTypeGen26DMA,
                                       SDLNameDisplayName: @"test",
                                       SDLNameTextFields:[@[textField] mutableCopy],
                                       SDLNameImageFields:[@[imageField] mutableCopy],
                                       SDLNameMediaClockFormats:[@[SDLMediaClockFormatClockText1, SDLMediaClockFormatClock3, SDLMediaClockFormatClockText3] copy],
                                       SDLNameGraphicSupported:@YES,
                                       SDLNameTemplatesAvailable:[@[@"String", @"String", @"String"] mutableCopy],
                                       SDLNameScreenParams:screenParams,
                                       SDLNameNumberCustomPresetsAvailable:@43} mutableCopy];
        SDLDisplayCapabilities* testStruct = [[SDLDisplayCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.displayType).to(equal(SDLDisplayTypeGen26DMA));
        expect(testStruct.displayName).to(equal(@"test"));
        expect(testStruct.textFields).to(equal([@[textField] mutableCopy]));
        expect(testStruct.imageFields).to(equal([@[imageField] mutableCopy]));
        expect(testStruct.mediaClockFormats).to(equal([@[SDLMediaClockFormatClockText1, SDLMediaClockFormatClock3, SDLMediaClockFormatClockText3] copy]));
        expect(testStruct.graphicSupported).to(equal(@YES));
        expect(testStruct.templatesAvailable).to(equal([@[@"String", @"String", @"String"] mutableCopy]));
        expect(testStruct.screenParams).to(equal(screenParams));
        expect(testStruct.numCustomPresetsAvailable).to(equal(@43));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDisplayCapabilities* testStruct = [[SDLDisplayCapabilities alloc] init];
        
        expect(testStruct.displayType).to(beNil());
        expect(testStruct.displayName).to(beNil());
        expect(testStruct.textFields).to(beNil());
        expect(testStruct.imageFields).to(beNil());
        expect(testStruct.mediaClockFormats).to(beNil());
        expect(testStruct.graphicSupported).to(beNil());
        expect(testStruct.templatesAvailable).to(beNil());
        expect(testStruct.screenParams).to(beNil());
        expect(testStruct.numCustomPresetsAvailable).to(beNil());
    });
});

#pragma clang diagnostic pop

QuickSpecEnd
