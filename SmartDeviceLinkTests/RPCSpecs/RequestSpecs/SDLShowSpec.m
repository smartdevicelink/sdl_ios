//
//  SDLShowSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLImage.h"
#import "SDLMetadataTags.h"
#import "SDLMetadataType.h"
#import "SDLNames.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLTextAlignment.h"

QuickSpecBegin(SDLShowSpec)

SDLImage* image1 = [[SDLImage alloc] init];
SDLImage* image2 = [[SDLImage alloc] init];
SDLSoftButton* button = [[SDLSoftButton alloc] init];

NSArray<SDLMetadataType *> *formatArray = @[[SDLMetadataType MEDIA_ARTIST], [SDLMetadataType MEDIA_TITLE]];
SDLMetadataTags* testMetadata = [[SDLMetadataTags alloc] initWithTextFieldTypes:formatArray mainField2:formatArray mainField3:formatArray mainField4:formatArray];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLShow* testRequest = [[SDLShow alloc] init];
        
        testRequest.mainField1 = @"field1";
        testRequest.mainField2 = @"field2";
        testRequest.mainField3 = @"field3";
        testRequest.mainField4 = @"field4";
        testRequest.alignment = [SDLTextAlignment LEFT_ALIGNED];
        testRequest.statusBar = @"status";
        testRequest.mediaClock = @"TheTime";
        testRequest.mediaTrack = @"In The Clear";
        testRequest.graphic = image1;
        testRequest.secondaryGraphic = image2;
        testRequest.softButtons = [@[button] mutableCopy];
        testRequest.customPresets = [@[@"preset1", @"preset2"] mutableCopy];
        testRequest.metadataTags = testMetadata;
        
        expect(testRequest.mainField1).to(equal(@"field1"));
        expect(testRequest.mainField2).to(equal(@"field2"));
        expect(testRequest.mainField3).to(equal(@"field3"));
        expect(testRequest.mainField4).to(equal(@"field4"));
        expect(testRequest.alignment).to(equal([SDLTextAlignment LEFT_ALIGNED]));
        expect(testRequest.statusBar).to(equal(@"status"));
        expect(testRequest.mediaClock).to(equal(@"TheTime"));
        expect(testRequest.mediaTrack).to(equal(@"In The Clear"));
        expect(testRequest.graphic).to(equal(image1));
        expect(testRequest.secondaryGraphic).to(equal(image2));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
        expect(testRequest.customPresets).to(equal([@[@"preset1", @"preset2"] mutableCopy]));
        expect(testRequest.metadataTags).to(equal(testMetadata));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_mainField1:@"field1",
                                                   NAMES_mainField2:@"field2",
                                                   NAMES_mainField3:@"field3",
                                                   NAMES_mainField4:@"field4",
                                                   NAMES_alignment:[SDLTextAlignment LEFT_ALIGNED],
                                                   NAMES_statusBar:@"status",
                                                   NAMES_mediaClock:@"TheTime",
                                                   NAMES_mediaTrack:@"In The Clear",
                                                   NAMES_graphic:image1,
                                                   NAMES_secondaryGraphic:image2,
                                                   NAMES_softButtons:[@[button] mutableCopy],
                                                   NAMES_customPresets:[@[@"preset1", @"preset2"] mutableCopy],
                                                   NAMES_metadataTags: testMetadata},
                                             NAMES_operation_name:NAMES_Show}} mutableCopy];
        SDLShow* testRequest = [[SDLShow alloc] initWithDictionary:dict];
        
        expect(testRequest.mainField1).to(equal(@"field1"));
        expect(testRequest.mainField2).to(equal(@"field2"));
        expect(testRequest.mainField3).to(equal(@"field3"));
        expect(testRequest.mainField4).to(equal(@"field4"));
        expect(testRequest.alignment).to(equal([SDLTextAlignment LEFT_ALIGNED]));
        expect(testRequest.statusBar).to(equal(@"status"));
        expect(testRequest.mediaClock).to(equal(@"TheTime"));
        expect(testRequest.mediaTrack).to(equal(@"In The Clear"));
        expect(testRequest.graphic).to(equal(image1));
        expect(testRequest.secondaryGraphic).to(equal(image2));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
        expect(testRequest.customPresets).to(equal([@[@"preset1", @"preset2"] mutableCopy]));
        expect(testRequest.metadataTags).to(equal(testMetadata));
    });

    it(@"Should get correctly when initialized without a dictionary", ^ {

        SDLShow* testRequest = [[SDLShow alloc] initWithMainField1:@"field1" mainField2:@"field2" mainField3:@"field3" mainField4:@"field4" alignment:[SDLTextAlignment LEFT_ALIGNED] statusBar:@"status" mediaClock:@"TheTime" mediaTrack:@"In The Clear" graphic:image1 softButtons:[@[button] mutableCopy] customPresets:[@[@"preset1", @"preset2"] mutableCopy] textFieldMetadata:testMetadata];

        expect(testRequest.mainField1).to(equal(@"field1"));
        expect(testRequest.mainField2).to(equal(@"field2"));
        expect(testRequest.mainField3).to(equal(@"field3"));
        expect(testRequest.mainField4).to(equal(@"field4"));
        expect(testRequest.alignment).to(equal([SDLTextAlignment LEFT_ALIGNED]));
        expect(testRequest.statusBar).to(equal(@"status"));
        expect(testRequest.mediaClock).to(equal(@"TheTime"));
        expect(testRequest.mediaTrack).to(equal(@"In The Clear"));
        expect(testRequest.graphic).to(equal(image1));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
        expect(testRequest.customPresets).to(equal([@[@"preset1", @"preset2"] mutableCopy]));
        expect(testRequest.metadataTags).to(equal(testMetadata));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLShow* testRequest = [[SDLShow alloc] init];
        
        expect(testRequest.mainField1).to(beNil());
        expect(testRequest.mainField2).to(beNil());
        expect(testRequest.mainField3).to(beNil());
        expect(testRequest.mainField4).to(beNil());
        expect(testRequest.alignment).to(beNil());
        expect(testRequest.statusBar).to(beNil());
        expect(testRequest.mediaClock).to(beNil());
        expect(testRequest.mediaTrack).to(beNil());
        expect(testRequest.graphic).to(beNil());
        expect(testRequest.secondaryGraphic).to(beNil());
        expect(testRequest.softButtons).to(beNil());
        expect(testRequest.customPresets).to(beNil());
        expect(testRequest.metadataTags).to(beNil());
    });
});

QuickSpecEnd
