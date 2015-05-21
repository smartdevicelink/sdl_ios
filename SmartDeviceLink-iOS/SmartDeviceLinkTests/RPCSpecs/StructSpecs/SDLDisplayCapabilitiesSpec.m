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

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDisplayCapabilities* testStruct = [[SDLDisplayCapabilities alloc] init];
        
        testStruct.displayType = [SDLDisplayType GEN2_6_DMA];
        testStruct.textFields = [@[textField] mutableCopy];
        testStruct.imageFields = [@[imageField] mutableCopy];
        testStruct.mediaClockFormats = [@[[SDLMediaClockFormat CLOCKTEXT1], [SDLMediaClockFormat CLOCK3], [SDLMediaClockFormat CLOCKTEXT3]] copy];
        testStruct.graphicSupported = @YES;
        testStruct.templatesAvailable = [@[@"String", @"String", @"String"] mutableCopy];
        testStruct.screenParams = screenParams;
        testStruct.numCustomPresetsAvailable = @43;
        
        expect(testStruct.displayType).to(equal([SDLDisplayType GEN2_6_DMA]));
        expect(testStruct.textFields).to(equal([@[textField] mutableCopy]));
        expect(testStruct.imageFields).to(equal([@[imageField] mutableCopy]));
        expect(testStruct.mediaClockFormats).to(equal([@[[SDLMediaClockFormat CLOCKTEXT1], [SDLMediaClockFormat CLOCK3], [SDLMediaClockFormat CLOCKTEXT3]] copy]));
        expect(testStruct.graphicSupported).to(equal(@YES));
        expect(testStruct.templatesAvailable).to(equal([@[@"String", @"String", @"String"] mutableCopy]));
        expect(testStruct.screenParams).to(equal(screenParams));
        expect(testStruct.numCustomPresetsAvailable).to(equal(@43));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_displayType:[SDLDisplayType GEN2_6_DMA],
                                       NAMES_textFields:[@[textField] mutableCopy],
                                       NAMES_imageFields:[@[imageField] mutableCopy],
                                       NAMES_mediaClockFormats:[@[[SDLMediaClockFormat CLOCKTEXT1], [SDLMediaClockFormat CLOCK3], [SDLMediaClockFormat CLOCKTEXT3]] copy],
                                       NAMES_graphicSupported:@YES,
                                       NAMES_templatesAvailable:[@[@"String", @"String", @"String"] mutableCopy],
                                       NAMES_screenParams:screenParams,
                                       NAMES_numCustomPresetsAvailable:@43} mutableCopy];
        SDLDisplayCapabilities* testStruct = [[SDLDisplayCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.displayType).to(equal([SDLDisplayType GEN2_6_DMA]));
        expect(testStruct.textFields).to(equal([@[textField] mutableCopy]));
        expect(testStruct.imageFields).to(equal([@[imageField] mutableCopy]));
        expect(testStruct.mediaClockFormats).to(equal([@[[SDLMediaClockFormat CLOCKTEXT1], [SDLMediaClockFormat CLOCK3], [SDLMediaClockFormat CLOCKTEXT3]] copy]));
        expect(testStruct.graphicSupported).to(equal(@YES));
        expect(testStruct.templatesAvailable).to(equal([@[@"String", @"String", @"String"] mutableCopy]));
        expect(testStruct.screenParams).to(equal(screenParams));
        expect(testStruct.numCustomPresetsAvailable).to(equal(@43));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDisplayCapabilities* testStruct = [[SDLDisplayCapabilities alloc] init];
        
        expect(testStruct.displayType).to(beNil());
        expect(testStruct.textFields).to(beNil());
        expect(testStruct.imageFields).to(beNil());
        expect(testStruct.mediaClockFormats).to(beNil());
        expect(testStruct.graphicSupported).to(beNil());
        expect(testStruct.templatesAvailable).to(beNil());
        expect(testStruct.screenParams).to(beNil());
        expect(testStruct.numCustomPresetsAvailable).to(beNil());
    });
});

QuickSpecEnd