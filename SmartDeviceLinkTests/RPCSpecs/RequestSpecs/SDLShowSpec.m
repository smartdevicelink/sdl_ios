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

NSArray<SDLMetadataType> *formatArray = @[SDLMetadataTypeMediaArtist,SDLMetadataTypeMediaTitle];
SDLMetadataTags* testMetadata = [[SDLMetadataTags alloc] initWithTextFieldTypes:formatArray mainField2:formatArray mainField3:formatArray mainField4:formatArray];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLShow* testRequest = [[SDLShow alloc] init];

        testRequest.mainField1 = @"field1";
        testRequest.mainField2 = @"field2";
        testRequest.mainField3 = @"field3";
        testRequest.mainField4 = @"field4";
        testRequest.alignment = SDLTextAlignmentLeft;
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
        expect(testRequest.alignment).to(equal(SDLTextAlignmentLeft));
        expect(testRequest.statusBar).to(equal(@"status"));
        expect(testRequest.mediaClock).to(equal(@"TheTime"));
        expect(testRequest.mediaTrack).to(equal(@"In The Clear"));
        expect(testRequest.graphic).to(equal(image1));
        expect(testRequest.secondaryGraphic).to(equal(image2));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
        expect(testRequest.customPresets).to(equal([@[@"preset1", @"preset2"] mutableCopy]));
        expect(testRequest.metadataTags).to(equal(testMetadata));

    });

    it(@"Should return nil if not set", ^{
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

    describe(@"initializing", ^{
        __block NSString *testString1 = @"Test 1";
        __block NSString *testString2 = @"Test 2";
        __block NSString *testString3 = @"Test 3";
        __block NSString *testString4 = @"Test 4";
        __block NSString *testStatusBarString = @"Test Status";
        __block NSString *testMediaClockString = @"Test Clock";
        __block NSString *testMediaTrackString = @"Test Track";
        __block SDLImage *testGraphic = nil;
        __block NSArray<NSString *> *testCustomPresets = nil;
        __block SDLSoftButton *testButton = nil;
        __block NSArray<SDLSoftButton *> *testSoftButtons = nil;
        __block SDLMetadataType testType1 = SDLMetadataTypeHumidity;
        __block SDLMetadataType testType2 = SDLMetadataTypeRating;
        __block SDLMetadataType testType3 = SDLMetadataTypeMediaYear;
        __block SDLMetadataType testType4 = SDLMetadataTypeWeatherTerm;
        __block SDLTextAlignment testAlignment = SDLTextAlignmentCenter;
        __block SDLMetadataTags *testTags = nil;

        beforeEach(^{
            testGraphic = [[SDLImage alloc] initWithName:@"test name" isTemplate:false];
            testCustomPresets = @[testString1];
            testButton = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"Test Button" image:nil highlighted:NO buttonId:0 systemAction:nil handler:nil];
            testSoftButtons = @[testButton];
            testTags = [[SDLMetadataTags alloc] initWithTextFieldTypes:@[testType1] mainField2:@[testType2] mainField3:@[testType3] mainField4:@[testType4]];
        });

        it(@"should initialize with initWithMainField1:mainField2:alignment:", ^{
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField2:testString2 alignment:testAlignment];
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(beNil());
            expect(testShow.mediaClock).to(beNil());
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());

            testShow = [[SDLShow alloc] initWithMainField1:nil mainField2:nil alignment:nil];
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
            expect(testShow.mediaClock).to(beNil());
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField1Type:mainField2:mainField2Type:alignment:", ^{
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField1Type:testType1 mainField2:testString2 mainField2Type:testType2 alignment:testAlignment];
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(beNil());
            expect(testShow.mediaClock).to(beNil());
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags.mainField1).to(contain(testType1));
            expect(testShow.metadataTags.mainField2).to(contain(testType2));
            expect(testShow.metadataTags.mainField3).to(beNil());
            expect(testShow.metadataTags.mainField4).to(beNil());

            testShow = [[SDLShow alloc] initWithMainField1:nil mainField1Type:nil mainField2:nil mainField2Type:nil alignment:nil];
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
            expect(testShow.mediaClock).to(beNil());
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField2:mainField3:mainField4:alignment:", ^{
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField2:testString2 mainField3:testString3 mainField4:testString4 alignment:testAlignment];
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(equal(testString3));
            expect(testShow.mainField4).to(equal(testString4));
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(beNil());
            expect(testShow.mediaClock).to(beNil());
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags.mainField1).to(beNil());
            expect(testShow.metadataTags.mainField2).to(beNil());
            expect(testShow.metadataTags.mainField3).to(beNil());
            expect(testShow.metadataTags.mainField4).to(beNil());

            testShow = [[SDLShow alloc] initWithMainField1:nil mainField2:nil mainField3:nil mainField4:nil alignment:nil];
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
            expect(testShow.mediaClock).to(beNil());
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField1Type:mainField2:mainField2Type:mainField3:mainField3Type:mainField4:mainField4Type:alignment:", ^{
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField1Type:testType1 mainField2:testString2 mainField2Type:testType2 mainField3:testString3 mainField3Type:testType3 mainField4:testString4 mainField4Type:testType4 alignment:testAlignment];
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(equal(testString3));
            expect(testShow.mainField4).to(equal(testString4));
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(beNil());
            expect(testShow.mediaClock).to(beNil());
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags.mainField1).to(contain(testType1));
            expect(testShow.metadataTags.mainField2).to(contain(testType2));
            expect(testShow.metadataTags.mainField3).to(contain(testType3));
            expect(testShow.metadataTags.mainField4).to(contain(testType4));

            testShow = [[SDLShow alloc] initWithMainField1:nil mainField1Type:nil mainField2:nil mainField2Type:nil mainField3:nil mainField3Type:nil mainField4:nil mainField4Type:nil alignment:nil];
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
            expect(testShow.mediaClock).to(beNil());
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField2:alignment:statusBar:mediaClock:mediaTrack:", ^{
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField2:testString2 alignment:testAlignment statusBar:testStatusBarString mediaClock:testMediaClockString mediaTrack:testMediaTrackString];
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(equal(testStatusBarString));
            expect(testShow.mediaClock).to(equal(testMediaClockString));
            expect(testShow.mediaTrack).to(equal(testMediaTrackString));
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags.mainField1).to(beNil());
            expect(testShow.metadataTags.mainField2).to(beNil());
            expect(testShow.metadataTags.mainField3).to(beNil());
            expect(testShow.metadataTags.mainField4).to(beNil());

            testShow = [[SDLShow alloc] initWithMainField1:nil mainField2:nil alignment:nil statusBar:nil mediaClock:nil mediaTrack:nil];
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
            expect(testShow.mediaClock).to(beNil());
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField2:mainField3:mainField4:alignment:statusBar:mediaClock:mediaTrack:graphic:softButtons:customPresets:textFieldMetadata:", ^{
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField2:testString2 mainField3:testString3 mainField4:testString4 alignment:testAlignment statusBar:testStatusBarString mediaClock:testMediaClockString mediaTrack:testMediaTrackString graphic:testGraphic softButtons:testSoftButtons customPresets:testCustomPresets textFieldMetadata:testTags];
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(equal(testString3));
            expect(testShow.mainField4).to(equal(testString4));
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(equal(testStatusBarString));
            expect(testShow.mediaClock).to(equal(testMediaClockString));
            expect(testShow.mediaTrack).to(equal(testMediaTrackString));
            expect(testShow.graphic).to(equal(testGraphic));
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(contain(testButton));
            expect(testShow.customPresets).to(contain(testString1));
            expect(testShow.metadataTags.mainField1).to(contain(testType1));
            expect(testShow.metadataTags.mainField2).to(contain(testType2));
            expect(testShow.metadataTags.mainField3).to(contain(testType3));
            expect(testShow.metadataTags.mainField4).to(contain(testType4));

            testShow = [[SDLShow alloc] initWithMainField1:nil mainField2:nil mainField3:nil mainField4:nil alignment:nil statusBar:nil mediaClock:nil mediaTrack:nil graphic:nil softButtons:nil customPresets:nil textFieldMetadata:nil];
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
            expect(testShow.mediaClock).to(beNil());
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"Should get correctly when initialized with a dictionary", ^ {
            NSMutableDictionary* dict = [@{SDLNameRequest:
                                               @{SDLNameParameters:
                                                     @{SDLNameMainField1:@"field1",
                                                       SDLNameMainField2:@"field2",
                                                       SDLNameMainField3:@"field3",
                                                       SDLNameMainField4:@"field4",
                                                       SDLNameAlignment:SDLTextAlignmentLeft,
                                                       SDLNameStatusBar:@"status",
                                                       SDLNameMediaClock:@"TheTime",
                                                       SDLNameMediaTrack:@"In The Clear",
                                                       SDLNameGraphic:image1,
                                                       SDLNameSecondaryGraphic:image2,
                                                       SDLNameSoftButtons:[@[button] mutableCopy],
                                                       SDLNameCustomPresets:[@[@"preset1", @"preset2"] mutableCopy],
                                                       SDLNameMetadataTags:testMetadata},
                                                 SDLNameOperationName:SDLNameShow}} mutableCopy];
            SDLShow* testRequest = [[SDLShow alloc] initWithDictionary:dict];

            expect(testRequest.mainField1).to(equal(@"field1"));
            expect(testRequest.mainField2).to(equal(@"field2"));
            expect(testRequest.mainField3).to(equal(@"field3"));
            expect(testRequest.mainField4).to(equal(@"field4"));
            expect(testRequest.alignment).to(equal(SDLTextAlignmentLeft));
            expect(testRequest.statusBar).to(equal(@"status"));
            expect(testRequest.mediaClock).to(equal(@"TheTime"));
            expect(testRequest.mediaTrack).to(equal(@"In The Clear"));
            expect(testRequest.graphic).to(equal(image1));
            expect(testRequest.secondaryGraphic).to(equal(image2));
            expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
            expect(testRequest.customPresets).to(equal([@[@"preset1", @"preset2"] mutableCopy]));
            expect(testRequest.metadataTags).to(equal(testMetadata));
        });
    });
});

QuickSpecEnd
