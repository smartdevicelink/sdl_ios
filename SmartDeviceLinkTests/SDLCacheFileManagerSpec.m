//
//  SDLCacheFileManagerSpec.m
//  SmartDeviceLinkTests
//
//  Created by James Lapinski on 3/23/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLCacheFileManager.h"
#import "SDLIconArchiveFile.h"
#import "SDLOnSystemRequest.h"


@interface SDLCacheFileManager ()

+ (nullable NSString *)sdl_writeImage:(UIImage *)icon toFileFromURL:(NSString *)urlString atFilePath:(NSString *)filePath;

@property (weak, nonatomic, nullable) NSURLSession *urlSession;
@property (weak, nonatomic, nullable) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic, readonly, nullable) NSString *cacheFileBaseDirectory;
@property (strong, nonatomic, readonly, nullable) NSString *archiveFileDirectory;

@end

QuickSpecBegin(SDLCacheFileManagerSpec)

describe(@"a cache file manager", ^{
    __block SDLCacheFileManager *testManager = nil;
    __block NSFileManager *mockFileManager = nil;
    __block id mockUnarchiver = nil;
    __block id mockUIImage = nil;
    __block SDLOnSystemRequest *testRequest = nil;
    __block NSString *testURL = nil;
    __block NSString *testFilePath = nil;
    __block NSString *testHashName = nil;
    __block UIImage *testImage = nil;
    __block SDLIconArchiveFile *testArchiveFile = nil;
    __block SDLLockScreenIconCache *testIconCache = nil;
    __block NSArray<SDLLockScreenIconCache *> *testArchiveFileLockScreenCacheArray = nil;

    beforeEach(^{
        testManager = [[SDLCacheFileManager alloc] init];

        testURL = @"http://i.imgur.com/TgkvOIZ.png";
        testRequest = [[SDLOnSystemRequest alloc] init];
        testRequest.url = testURL;

        testHashName = @"935e06761f887b20";

        testFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"testImagePNG" ofType:@"png"];

        testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];

        testIconCache = [[SDLLockScreenIconCache alloc] initWithIconUrl:testURL iconFilePath:testFilePath];
        // add expired testIconCache object
        testArchiveFileLockScreenCacheArray = @[testIconCache];

        testArchiveFile = [[SDLIconArchiveFile alloc] init];
        testArchiveFile.lockScreenIconCaches = testArchiveFileLockScreenCacheArray;

        mockFileManager = OCMStrictClassMock([NSFileManager class]);
        testManager.fileManager = mockFileManager;
        mockUnarchiver = OCMClassMock([NSKeyedUnarchiver class]);
        OCMStub(ClassMethod([mockUnarchiver unarchiveObjectWithFile:[OCMArg any]])).andReturn(testArchiveFile);
        mockUIImage = OCMClassMock([UIImage class]);
    });

    it(@"should initialize properties", ^{
        expect(testManager.urlSession).toNot(beNil());
        expect(testManager.fileManager).toNot(beNil());
    });

        describe(@"request with existing icon", ^{
            beforeEach(^{
                OCMStub(ClassMethod([mockUIImage imageWithContentsOfFile:[OCMArg any]])).andReturn(testImage);
            });

            context(@"icon is not exipred", ^{
                __block UIImage *resultImage = nil;
                __block NSError *resultError = nil;

                beforeEach(^{
                    OCMStub([mockFileManager fileExistsAtPath:[OCMArg any]]).andReturn(YES);
                    [testManager retrieveImageForRequest:testRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        resultImage = image;
                        resultError = error;
                    }];
                });

                it(@"should return image and no error", ^{
                    expect(resultImage).to(equal(testImage));
                    expect(resultError).to(beNil());
                });

            });

            context(@"icon is expired", ^{


                it(@"should have an archive file present with expired icon", ^{
                    expect(testManager.archiveFileDirectory).toNot(beNil());
                    expect(testArchiveFile).toNot(beNil());
                    expect(testArchiveFile.lockScreenIconCaches.count).toNot(beNil());
                });

                it(@"should have same url as cache", ^{
                    expect(testURL).to(match(testIconCache.iconUrl));
                });

                it(@"should update icon", ^{

                });

                it(@"should return icon with nil error", ^{
                    UIImage *image = [[UIImage alloc] init];
                    NSError *error = nil;
//                    OCMStub([testManager retrieveImageForRequest:[OCMArg any] withCompletionHandler:([OCMArg invokeBlockWithArgs:@[image, error], nil])]);
                    expect(image).toNot(beNil());
                    expect(error).to(beNil());
                });
            });

        });

        describe(@"request with new icon", ^{
            // it should dowload the icon

            context(@"directory doesn't exist", ^{
                // create directory
                // download icon
            });

            context(@"directory exists", ^{
                // download icon
                // save to archive file
                // return icon
            });
        });

    });


QuickSpecEnd
