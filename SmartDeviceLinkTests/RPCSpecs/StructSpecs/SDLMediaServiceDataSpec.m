//
//  SDLMediaServiceDataSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMediaServiceData.h"
#import "SDLMediaType.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLMediaServiceDataSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLImage *testMediaImage = nil;
    __block SDLMediaType testMediaType = nil;
    __block NSString *testMediaTitle = nil;
    __block NSString *testMediaArtist = nil;
    __block NSString *testMediaAlbum = nil;
    __block NSString *testPlaylistName = nil;
    __block BOOL testIsExplicit = nil;
    __block int testTrackPlaybackProgress = 45;
    __block int testTrackPlaybackDuration = 3;
    __block int testQueuePlaybackProgress = 21;
    __block int testQueuePlaybackDuration = 5;
    __block int testQueueCurrentTrackNumber = 3;
    __block int testQueueTotalTrackCount = 56;

    beforeEach(^{
        testMediaType = SDLMediaTypePodcast;
        testMediaImage = [[SDLImage alloc] initWithStaticIconName:SDLStaticIconNameKey];
        testMediaTitle = @"testMediaTitle";
        testMediaArtist = @"testMediaArtist";
        testMediaAlbum = @"testMediaAlbum";
        testPlaylistName = @"testPlaylistName";
        testIsExplicit = true;
    });

    it(@"Should set and get correctly", ^{
        SDLMediaServiceData *testStruct = [[SDLMediaServiceData alloc] init];
        testStruct.mediaImage = testMediaImage;
        testStruct.mediaType = testMediaType;
        testStruct.mediaTitle = testMediaTitle;
        testStruct.mediaArtist = testMediaArtist;
        testStruct.mediaAlbum = testMediaAlbum;
        testStruct.playlistName = testPlaylistName;
        testStruct.isExplicit = @(testIsExplicit);
        testStruct.trackPlaybackProgress = @(testTrackPlaybackProgress);
        testStruct.trackPlaybackDuration = @(testTrackPlaybackDuration);
        testStruct.queuePlaybackProgress = @(testQueuePlaybackProgress);
        testStruct.queuePlaybackDuration = @(testQueuePlaybackDuration);
        testStruct.queueCurrentTrackNumber = @(testQueueCurrentTrackNumber);
        testStruct.queueTotalTrackCount = @(testQueueTotalTrackCount);

        expect(testStruct.mediaImage).to(equal(testMediaImage));
        expect(testStruct.mediaType).to(equal(testMediaType));
        expect(testStruct.mediaTitle).to(equal(testMediaTitle));
        expect(testStruct.mediaArtist).to(equal(testMediaArtist));
        expect(testStruct.mediaAlbum).to(equal(testMediaAlbum));
        expect(testStruct.playlistName).to(equal(testPlaylistName));
        expect(testStruct.isExplicit).to(equal(testIsExplicit));
        expect(testStruct.trackPlaybackProgress).to(equal(testTrackPlaybackProgress));
        expect(testStruct.trackPlaybackDuration).to(equal(testTrackPlaybackDuration));
        expect(testStruct.queuePlaybackProgress).to(equal(testQueuePlaybackProgress));
        expect(testStruct.queuePlaybackDuration).to(equal(testQueuePlaybackDuration));
        expect(testStruct.queueCurrentTrackNumber).to(equal(testQueueCurrentTrackNumber));
        expect(testStruct.queueTotalTrackCount).to(equal(testQueueTotalTrackCount));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameMediaImage:testMediaImage,
                               SDLRPCParameterNameMediaType:testMediaType,
                               SDLRPCParameterNameMediaTitle:testMediaTitle,
                               SDLRPCParameterNameMediaArtist:testMediaArtist,
                               SDLRPCParameterNameMediaAlbum:testMediaAlbum,
                               SDLRPCParameterNamePlaylistName:testPlaylistName,
                               SDLRPCParameterNameIsExplicit:@(testIsExplicit),
                               SDLRPCParameterNameTrackPlaybackProgress:@(testTrackPlaybackProgress),
                               SDLRPCParameterNameTrackPlaybackDuration:@(testTrackPlaybackDuration),
                               SDLRPCParameterNameQueuePlaybackProgress:@(testQueuePlaybackProgress),
                               SDLRPCParameterNameQueuePlaybackDuration:@(testQueuePlaybackDuration),
                               SDLRPCParameterNameQueueCurrentTrackNumber:@(testQueueCurrentTrackNumber),
                               SDLRPCParameterNameQueueTotalTrackCount:@(testQueueTotalTrackCount)
                               };
        SDLMediaServiceData *testStruct = [[SDLMediaServiceData alloc] initWithDictionary:dict];

        expect(testStruct.mediaImage).to(equal(testMediaImage));
        expect(testStruct.mediaType).to(equal(testMediaType));
        expect(testStruct.mediaTitle).to(equal(testMediaTitle));
        expect(testStruct.mediaArtist).to(equal(testMediaArtist));
        expect(testStruct.mediaAlbum).to(equal(testMediaAlbum));
        expect(testStruct.playlistName).to(equal(testPlaylistName));
        expect(testStruct.isExplicit).to(equal(testIsExplicit));
        expect(testStruct.trackPlaybackProgress).to(equal(testTrackPlaybackProgress));
        expect(testStruct.trackPlaybackDuration).to(equal(testTrackPlaybackDuration));
        expect(testStruct.queuePlaybackProgress).to(equal(testQueuePlaybackProgress));
        expect(testStruct.queuePlaybackDuration).to(equal(testQueuePlaybackDuration));
        expect(testStruct.queueCurrentTrackNumber).to(equal(testQueueCurrentTrackNumber));
        expect(testStruct.queueTotalTrackCount).to(equal(testQueueTotalTrackCount));
    });

    it(@"Should get correctly when initialized with initWithMediaType:mediaImage:mediaTitle:mediaArtist:mediaAlbum:playlistName:isExplicit:trackPlaybackProgress:trackPlaybackDuration:queuePlaybackProgress:queuePlaybackDuration:queueCurrentTrackNumber:queueTotalTrackCount:", ^{
        SDLMediaServiceData *testStruct = [[SDLMediaServiceData alloc] initWithMediaType:testMediaType mediaImage:testMediaImage mediaTitle:testMediaTitle mediaArtist:testMediaArtist mediaAlbum:testMediaAlbum playlistName:testPlaylistName isExplicit:testIsExplicit trackPlaybackProgress:testTrackPlaybackProgress trackPlaybackDuration:testTrackPlaybackDuration queuePlaybackProgress:testQueuePlaybackProgress queuePlaybackDuration:testQueuePlaybackDuration queueCurrentTrackNumber:testQueueCurrentTrackNumber queueTotalTrackCount:testQueueTotalTrackCount];

        expect(testStruct.mediaType).to(equal(testMediaType));
        expect(testStruct.mediaImage).to(equal(testMediaImage));
        expect(testStruct.mediaTitle).to(equal(testMediaTitle));
        expect(testStruct.mediaArtist).to(equal(testMediaArtist));
        expect(testStruct.mediaAlbum).to(equal(testMediaAlbum));
        expect(testStruct.playlistName).to(equal(testPlaylistName));
        expect(testStruct.isExplicit).to(equal(testIsExplicit));
        expect(testStruct.trackPlaybackProgress).to(equal(testTrackPlaybackProgress));
        expect(testStruct.trackPlaybackDuration).to(equal(testTrackPlaybackDuration));
        expect(testStruct.queuePlaybackProgress).to(equal(testQueuePlaybackProgress));
        expect(testStruct.queuePlaybackDuration).to(equal(testQueuePlaybackDuration));
        expect(testStruct.queueCurrentTrackNumber).to(equal(testQueueCurrentTrackNumber));
        expect(testStruct.queueTotalTrackCount).to(equal(testQueueTotalTrackCount));
    });

    it(@"Should return nil if not set", ^{
        SDLMediaServiceData *testStruct = [[SDLMediaServiceData alloc] init];

        expect(testStruct.mediaImage).to(beNil());
        expect(testStruct.mediaType).to(beNil());
        expect(testStruct.mediaTitle).to(beNil());
        expect(testStruct.mediaArtist).to(beNil());
        expect(testStruct.mediaAlbum).to(beNil());
        expect(testStruct.playlistName).to(beNil());
        expect(testStruct.isExplicit).to(beNil());
        expect(testStruct.trackPlaybackProgress).to(beNil());
        expect(testStruct.trackPlaybackDuration).to(beNil());
        expect(testStruct.queuePlaybackProgress).to(beNil());
        expect(testStruct.queuePlaybackDuration).to(beNil());
        expect(testStruct.queueCurrentTrackNumber).to(beNil());
        expect(testStruct.queueTotalTrackCount).to(beNil());
    });
});

QuickSpecEnd

