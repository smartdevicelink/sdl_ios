//
//  SDLTextAndGraphicStateSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 9/11/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLArtwork.h"
#import "SDLTemplateConfiguration.h"
#import "SDLTextAlignment.h"
#import "SDLTextAndGraphicState.h"

QuickSpecBegin(SDLTextAndGraphicStateSpec)

UIImage *testImagePNG = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
UIImage *testImagePNG2 = [UIImage imageNamed:@"TestLockScreenAppIcon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];

NSString *stringText1 = @"String 1";
NSString *stringText2 = @"String 2";
NSString *stringText3 = @"String 3";
NSString *stringText4 = @"String 4";
NSString *stringTitle = @"String Title";
NSString *stringMedia = @"String Media";
SDLTextAlignment testAlignment = SDLTextAlignmentLeft;
SDLArtwork *artworkPrimary = [[SDLArtwork alloc] initWithImage:testImagePNG name:@"Artwork Primary" persistent:NO asImageFormat:SDLArtworkImageFormatPNG];
SDLArtwork *artworkSecondary = [[SDLArtwork alloc] initWithImage:testImagePNG2 name:@"Artwork Secondary" persistent:NO asImageFormat:SDLArtworkImageFormatPNG];
SDLMetadataType type1 = SDLMetadataTypeRating;
SDLMetadataType type2 = SDLMetadataTypeHumidity;
SDLMetadataType type3 = SDLMetadataTypeMediaYear;
SDLMetadataType type4 = SDLMetadataTypeMediaGenre;
SDLTemplateConfiguration *testConfig = [[SDLTemplateConfiguration alloc] initWithTemplate:@"Test Template" dayColorScheme:nil nightColorScheme:nil];

describe(@"state initialization", ^{
    __block SDLTextAndGraphicState *testState = nil;
    beforeEach(^{
        testState = [[SDLTextAndGraphicState alloc] initWithTextField1:stringText1 textField2:stringText2 textField3:stringText3 textField4:stringText4 mediaText:stringMedia title:stringTitle primaryGraphic:artworkPrimary secondaryGraphic:artworkSecondary alignment:testAlignment textField1Type:type1 textField2Type:type2 textField3Type:type3 textField4Type:type4 templateConfiguration:testConfig];
    });

    it(@"should initialize correctly", ^{
        expect(testState.textField1).to(equal(stringText1));
        expect(testState.textField2).to(equal(stringText2));
        expect(testState.textField3).to(equal(stringText3));
        expect(testState.textField4).to(equal(stringText4));
        expect(testState.mediaTrackTextField).to(equal(stringMedia));
        expect(testState.title).to(equal(stringTitle));
        expect(testState.primaryGraphic).to(equal(artworkPrimary));
        expect(testState.secondaryGraphic).to(equal(artworkSecondary));
        expect(testState.alignment).to(equal(testAlignment));
        expect(testState.textField1Type).to(equal(type1));
        expect(testState.textField2Type).to(equal(type2));
        expect(testState.textField3Type).to(equal(type3));
        expect(testState.textField4Type).to(equal(type4));
    });

    it(@"should copy correctly", ^{
        SDLTextAndGraphicState *newState = [testState copy];

        expect(testState).toNot(beIdenticalTo(newState));
    });

    it(@"should compare equality correctly", ^{
        SDLTextAndGraphicState *newState = [testState copy];

        expect(testState).to(equal(newState));
    });
});

QuickSpecEnd
