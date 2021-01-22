//
//  SDLShowSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLImage.h"
#import "SDLMetadataTags.h"
#import "SDLMetadataType.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLTemplateConfiguration.h"
#import "SDLTextAlignment.h"

QuickSpecBegin(SDLShowSpec)

describe(@"Getter/Setter Tests", ^ {
    __block NSString *testString1 = @"Test 1";
    __block NSString *testString2 = @"Test 2";
    __block NSString *testString3 = @"Test 3";
    __block NSString *testString4 = @"Test 4";
    __block NSString *testStatusBarString = @"Test Status";
    __block NSString *testMediaClockString = @"Test Clock";
    __block NSString *testMediaTrackString = @"Test Track";
    __block NSString *testTemplateTitleString = @"Hello World";
    __block SDLImage *testGraphic = nil;
    __block SDLImage *testSecondaryGraphic = nil;
    __block NSArray<NSString *> *testCustomPresets = nil;
    __block SDLSoftButton *testButton = nil;
    __block NSArray<SDLSoftButton *> *testSoftButtons = nil;
    __block SDLMetadataType testType1 = SDLMetadataTypeHumidity;
    __block SDLMetadataType testType2 = SDLMetadataTypeRating;
    __block SDLMetadataType testType3 = SDLMetadataTypeMediaYear;
    __block SDLMetadataType testType4 = SDLMetadataTypeWeatherTerm;
    __block SDLTextAlignment testAlignment = SDLTextAlignmentCenter;
    __block SDLMetadataTags *testMetadata = nil;
    __block SDLTemplateConfiguration *testTemplateConfiguration = nil;
    __block int testWindowID = 4;

    beforeEach(^{
        testGraphic = [[SDLImage alloc] initWithName:@"test name" isTemplate:false];
        testSecondaryGraphic = [[SDLImage alloc] initWithName:@"test name 2" isTemplate:false];
        testCustomPresets = @[testString1];
        testButton = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"Test Button" image:nil highlighted:NO buttonId:0 systemAction:nil handler:nil];
        testSoftButtons = @[testButton];
        testMetadata = [[SDLMetadataTags alloc] initWithTextFieldTypes:@[testType1] mainField2:@[testType2] mainField3:@[testType3] mainField4:@[testType4]];
        testTemplateConfiguration = [[SDLTemplateConfiguration alloc] initWithPredefinedLayout:SDLPredefinedLayoutMedia];
    });

    it(@"Should set and get correctly", ^ {
        SDLShow* testRequest = [[SDLShow alloc] init];

        testRequest.mainField1 = testString1;
        testRequest.mainField2 = testString2;
        testRequest.mainField3 = testString3;
        testRequest.mainField4 = testString4;
        testRequest.alignment = SDLTextAlignmentLeft;
        testRequest.statusBar = testStatusBarString;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testRequest.mediaClock = testMediaClockString;
#pragma clang diagnostic pop
        testRequest.mediaTrack = testMediaTrackString;
        testRequest.templateTitle = testTemplateTitleString;
        testRequest.graphic = testGraphic;
        testRequest.secondaryGraphic = testSecondaryGraphic;
        testRequest.softButtons = testSoftButtons;
        testRequest.customPresets = testCustomPresets;
        testRequest.metadataTags = testMetadata;
        testRequest.windowID = @(testWindowID);
        testRequest.templateConfiguration = testTemplateConfiguration;

        expect(testRequest.mainField1).to(equal(testString1));
        expect(testRequest.mainField2).to(equal(testString2));
        expect(testRequest.mainField3).to(equal(testString3));
        expect(testRequest.mainField4).to(equal(testString4));
        expect(testRequest.alignment).to(equal(SDLTextAlignmentLeft));
        expect(testRequest.statusBar).to(equal(testStatusBarString));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.mediaClock).to(equal(testMediaClockString));
#pragma clang diagnostic pop
        expect(testRequest.mediaTrack).to(equal(testMediaTrackString));
        expect(testRequest.templateTitle).to(equal(testTemplateTitleString));
        expect(testRequest.graphic).to(equal(testGraphic));
        expect(testRequest.secondaryGraphic).to(equal(testSecondaryGraphic));
        expect(testRequest.softButtons).to(equal(testSoftButtons));
        expect(testRequest.customPresets).to(equal(testCustomPresets));
        expect(testRequest.metadataTags).to(equal(testMetadata));
        expect(testRequest.windowID).to(equal(testWindowID));
        expect(testRequest.templateConfiguration).to(equal(testTemplateConfiguration));
    });

    it(@"Should return nil if not set", ^{
        SDLShow* testRequest = [[SDLShow alloc] init];

        expect(testRequest.mainField1).to(beNil());
        expect(testRequest.mainField2).to(beNil());
        expect(testRequest.mainField3).to(beNil());
        expect(testRequest.mainField4).to(beNil());
        expect(testRequest.alignment).to(beNil());
        expect(testRequest.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.mediaClock).to(beNil());
#pragma clang diagnostic pop
        expect(testRequest.mediaTrack).to(beNil());
        expect(testRequest.templateTitle).to(beNil());
        expect(testRequest.graphic).to(beNil());
        expect(testRequest.secondaryGraphic).to(beNil());
        expect(testRequest.softButtons).to(beNil());
        expect(testRequest.customPresets).to(beNil());
        expect(testRequest.metadataTags).to(beNil());
        expect(testRequest.windowID).to(beNil());
        expect(testRequest.templateConfiguration).to(beNil());
    });

    describe(@"initializing", ^{
        it(@"should initialize with initWithMainField1:mainField2:alignment:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField2:testString2 alignment:testAlignment];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(beNil());
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testShow = [[SDLShow alloc] initWithMainField1:nil mainField2:nil alignment:nil];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(beNil());
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField1Type:mainField2:mainField2Type:alignment:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField1Type:testType1 mainField2:testString2 mainField2Type:testType2 alignment:testAlignment];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(beNil());
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags.mainField1).to(contain(testType1));
            expect(testShow.metadataTags.mainField2).to(contain(testType2));
            expect(testShow.metadataTags.mainField3).to(beNil());
            expect(testShow.metadataTags.mainField4).to(beNil());

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testShow = [[SDLShow alloc] initWithMainField1:nil mainField1Type:nil mainField2:nil mainField2Type:nil alignment:nil];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(beNil());
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField2:mainField3:mainField4:alignment:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField2:testString2 mainField3:testString3 mainField4:testString4 alignment:testAlignment];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(equal(testString3));
            expect(testShow.mainField4).to(equal(testString4));
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(beNil());
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags.mainField1).to(beNil());
            expect(testShow.metadataTags.mainField2).to(beNil());
            expect(testShow.metadataTags.mainField3).to(beNil());
            expect(testShow.metadataTags.mainField4).to(beNil());

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testShow = [[SDLShow alloc] initWithMainField1:nil mainField2:nil mainField3:nil mainField4:nil alignment:nil];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(beNil());
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField1Type:mainField2:mainField2Type:mainField3:mainField3Type:mainField4:mainField4Type:alignment:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField1Type:testType1 mainField2:testString2 mainField2Type:testType2 mainField3:testString3 mainField3Type:testType3 mainField4:testString4 mainField4Type:testType4 alignment:testAlignment];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(equal(testString3));
            expect(testShow.mainField4).to(equal(testString4));
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(beNil());
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags.mainField1).to(contain(testType1));
            expect(testShow.metadataTags.mainField2).to(contain(testType2));
            expect(testShow.metadataTags.mainField3).to(contain(testType3));
            expect(testShow.metadataTags.mainField4).to(contain(testType4));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testShow = [[SDLShow alloc] initWithMainField1:nil mainField1Type:nil mainField2:nil mainField2Type:nil mainField3:nil mainField3Type:nil mainField4:nil mainField4Type:nil alignment:nil];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(beNil());
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField2:alignment:statusBar:mediaClock:mediaTrack:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField2:testString2 alignment:testAlignment statusBar:testStatusBarString mediaClock:testMediaClockString mediaTrack:testMediaTrackString];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(equal(testStatusBarString));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(equal(testMediaClockString));
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(equal(testMediaTrackString));
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags.mainField1).to(beNil());
            expect(testShow.metadataTags.mainField2).to(beNil());
            expect(testShow.metadataTags.mainField3).to(beNil());
            expect(testShow.metadataTags.mainField4).to(beNil());

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testShow = [[SDLShow alloc] initWithMainField1:nil mainField2:nil alignment:nil statusBar:nil mediaClock:nil mediaTrack:nil];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(beNil());
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField2:mainField3:mainField4:alignment:statusBar:mediaClock:mediaTrack:graphic:softButtons:customPresets:textFieldMetadata:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField2:testString2 mainField3:testString3 mainField4:testString4 alignment:testAlignment statusBar:testStatusBarString mediaClock:testMediaClockString mediaTrack:testMediaTrackString graphic:testGraphic softButtons:testSoftButtons customPresets:testCustomPresets textFieldMetadata:testMetadata];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(equal(testString3));
            expect(testShow.mainField4).to(equal(testString4));
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(equal(testStatusBarString));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(equal(testMediaClockString));
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(equal(testMediaTrackString));
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(equal(testGraphic));
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(contain(testButton));
            expect(testShow.customPresets).to(contain(testString1));
            expect(testShow.metadataTags.mainField1).to(contain(testType1));
            expect(testShow.metadataTags.mainField2).to(contain(testType2));
            expect(testShow.metadataTags.mainField3).to(contain(testType3));
            expect(testShow.metadataTags.mainField4).to(contain(testType4));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testShow = [[SDLShow alloc] initWithMainField1:nil mainField2:nil mainField3:nil mainField4:nil alignment:nil statusBar:nil mediaClock:nil mediaTrack:nil graphic:nil softButtons:nil customPresets:nil textFieldMetadata:nil];
#pragma clang diagnostic pop
            expect(testShow.mainField1).to(beNil());
            expect(testShow.mainField2).to(beNil());
            expect(testShow.mainField3).to(beNil());
            expect(testShow.mainField4).to(beNil());
            expect(testShow.alignment).to(beNil());
            expect(testShow.statusBar).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testShow.mediaClock).to(beNil());
#pragma clang diagnostic pop
            expect(testShow.mediaTrack).to(beNil());
            expect(testShow.templateTitle).to(beNil());
            expect(testShow.graphic).to(beNil());
            expect(testShow.secondaryGraphic).to(beNil());
            expect(testShow.softButtons).to(beNil());
            expect(testShow.customPresets).to(beNil());
            expect(testShow.metadataTags).to(beNil());
        });

        it(@"should initialize correctly with initWithMainField1:mainField2:mainField3:mainField4:alignment:statusBar:mediaTrack:graphic:secondaryGraphic:softButtons:customPresets:metadataTags:templateTitle:windowID:templateConfiguration:", ^{
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:testString1 mainField2:testString2 mainField3:testString3 mainField4:testString4 alignment:testAlignment statusBar:testStatusBarString mediaTrack:testMediaTrackString graphic:testGraphic secondaryGraphic:testSecondaryGraphic softButtons:testSoftButtons customPresets:testCustomPresets metadataTags:testMetadata templateTitle:testTemplateTitleString windowID:@(testWindowID) templateConfiguration:testTemplateConfiguration];
            expect(testShow.mainField1).to(equal(testString1));
            expect(testShow.mainField2).to(equal(testString2));
            expect(testShow.mainField3).to(equal(testString3));
            expect(testShow.mainField4).to(equal(testString4));
            expect(testShow.alignment).to(equal(testAlignment));
            expect(testShow.statusBar).to(equal(testStatusBarString));
            expect(testShow.mediaTrack).to(equal(testMediaTrackString));
            expect(testShow.graphic).to(equal(testGraphic));
            expect(testShow.secondaryGraphic).to(equal(testSecondaryGraphic));
            expect(testShow.softButtons).to(contain(testButton));
            expect(testShow.customPresets).to(contain(testString1));
            expect(testShow.metadataTags.mainField1).to(contain(testType1));
            expect(testShow.metadataTags.mainField2).to(contain(testType2));
            expect(testShow.metadataTags.mainField3).to(contain(testType3));
            expect(testShow.metadataTags.mainField4).to(contain(testType4));
            expect(testShow.templateTitle).to(equal(testTemplateTitleString));
            expect(testShow.windowID).to(equal(@(testWindowID)));
            expect(testShow.templateConfiguration).to(equal(testTemplateConfiguration));
        });

        it(@"Should get correctly when initialized with a dictionary", ^ {
            NSMutableDictionary* dict = [@{SDLRPCParameterNameRequest:
                                               @{SDLRPCParameterNameParameters:
                                                     @{SDLRPCParameterNameMainField1:testString1,
                                                       SDLRPCParameterNameMainField2:testString2,
                                                       SDLRPCParameterNameMainField3:testString3,
                                                       SDLRPCParameterNameMainField4:testString4,
                                                       SDLRPCParameterNameAlignment:SDLTextAlignmentLeft,
                                                       SDLRPCParameterNameStatusBar:testStatusBarString,
                                                       SDLRPCParameterNameMediaClock:testMediaClockString,
                                                       SDLRPCParameterNameMediaTrack:testMediaTrackString,
                                                       SDLRPCParameterNameTemplateTitle: testTemplateTitleString,
                                                       SDLRPCParameterNameGraphic:testGraphic,
                                                       SDLRPCParameterNameSecondaryGraphic:testSecondaryGraphic,
                                                       SDLRPCParameterNameSoftButtons:testSoftButtons,
                                                       SDLRPCParameterNameCustomPresets:testCustomPresets,
                                                       SDLRPCParameterNameMetadataTags:testMetadata,
                                                       SDLRPCParameterNameWindowId:@(testWindowID),
                                                       SDLRPCParameterNameTemplateConfiguration:testTemplateConfiguration
                                                     },
                                                 SDLRPCParameterNameOperationName:SDLRPCFunctionNameShow}} mutableCopy];
            SDLShow* testRequest = [[SDLShow alloc] initWithDictionary:dict];

            expect(testRequest.mainField1).to(equal(testString1));
            expect(testRequest.mainField2).to(equal(testString2));
            expect(testRequest.mainField3).to(equal(testString3));
            expect(testRequest.mainField4).to(equal(testString4));
            expect(testRequest.alignment).to(equal(SDLTextAlignmentLeft));
            expect(testRequest.statusBar).to(equal(testStatusBarString));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.mediaClock).to(equal(testMediaClockString));
#pragma clang diagnostic pop
            expect(testRequest.mediaTrack).to(equal(testMediaTrackString));
            expect(testRequest.templateTitle).to(equal(testTemplateTitleString));
            expect(testRequest.graphic).to(equal(testGraphic));
            expect(testRequest.secondaryGraphic).to(equal(testSecondaryGraphic));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.customPresets).to(equal(testCustomPresets));
            expect(testRequest.metadataTags).to(equal(testMetadata));
            expect(testRequest.windowID).to(equal(testWindowID));
            expect(testRequest.templateConfiguration).to(equal(testTemplateConfiguration));
        });
    });
});

QuickSpecEnd
