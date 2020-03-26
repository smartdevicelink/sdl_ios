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
- (void)sdl_downloadIconFromRequestURL:(NSString *)requestURL withCompletionHandler:(ImageRetrievalCompletionHandler)completion;
- (BOOL)updateArchiveFileWithIconURL:(NSString *)iconURL
                        iconFilePath:(NSString *)iconFilePath
                         archiveFile:(SDLIconArchiveFile *)archiveFile
                               error:(NSError **)error;
+ (NSInteger)numberOfDaysFromDateCreated:(NSDate *)date;

@property (weak, nonatomic, nullable) NSURLSession *urlSession;
@property (weak, nonatomic, nullable) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic, readonly, nullable) NSString *cacheFileBaseDirectory;
@property (strong, nonatomic, readonly, nullable) NSString *archiveFileDirectory;

@end

QuickSpecBegin(SDLCacheFileManagerSpec)

describe(@"a cache file manager", ^{
    __block SDLCacheFileManager *testManager = nil;
    __block id testManagerMock = nil;
    __block NSFileManager *mockFileManager = nil;
    __block id mockUnarchiver = nil;
    __block id mockUIImage = nil;
    __block id mockDataTask = nil;
    __block id mockArchiver = nil;
    __block SDLOnSystemRequest *testRequest = nil;
    __block NSString *testURL = nil;
    __block SDLOnSystemRequest *expiredTestRequest = nil;
    __block NSString *testFilePath = nil;
    __block NSString *testHashName = nil;
    __block NSString *expiredTestURL = nil;
    __block UIImage *testImage = nil;
    __block SDLIconArchiveFile *testArchiveFile = nil;
    __block SDLLockScreenIconCache *testIconCache = nil;
    __block SDLLockScreenIconCache *testExpiredIconCache = nil;
    __block NSArray<SDLLockScreenIconCache *> *testArchiveFileLockScreenCacheArray = nil;

    beforeEach(^{
        testManager = [[SDLCacheFileManager alloc] init];
        testManagerMock = OCMPartialMock(testManager);

        testFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"testImagePNG" ofType:@"png"];
        testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];

        testURL = @"testURL";
        testRequest = [[SDLOnSystemRequest alloc] init];
        testRequest.url = testURL;
        testIconCache = [[SDLLockScreenIconCache alloc] initWithIconUrl:testURL iconFilePath:testFilePath];

        expiredTestURL = @"expiredTestURL";
        expiredTestRequest = [[SDLOnSystemRequest alloc] init];
        expiredTestRequest.url = expiredTestURL;
        testExpiredIconCache = [[SDLLockScreenIconCache alloc] initWithIconUrl:expiredTestURL iconFilePath:testFilePath];
        testExpiredIconCache.lastModifiedDate = [[NSDate date] dateByAddingTimeInterval:-31*24*60*60];

        testArchiveFileLockScreenCacheArray = @[testIconCache,testExpiredIconCache];

        testArchiveFile = [[SDLIconArchiveFile alloc] init];
        testArchiveFile.lockScreenIconCaches = testArchiveFileLockScreenCacheArray;

        mockFileManager = OCMStrictClassMock([NSFileManager class]);
        testManager.fileManager = mockFileManager;
        mockUnarchiver = OCMClassMock([NSKeyedUnarchiver class]);
        OCMStub(ClassMethod([mockUnarchiver unarchiveObjectWithFile:[OCMArg any]])).andReturn(testArchiveFile);

        mockUIImage = OCMClassMock([UIImage class]);
        mockDataTask = OCMClassMock([NSURLSession class]);

        mockArchiver = OCMClassMock([NSKeyedArchiver class]);
    });

    it(@"should initialize properties", ^{
        expect(testManager.urlSession).toNot(beNil());
        expect(testManager.fileManager).toNot(beNil());
    });

    describe(@"request with existing icon", ^{
        beforeEach(^{
            OCMStub([mockFileManager fileExistsAtPath:[OCMArg any]]).andReturn(YES);
        });

        context(@"icon is not expired", ^{
            __block UIImage *resultImage = nil;
            __block NSError *resultError = nil;

            beforeEach(^{
                OCMStub(ClassMethod([mockUIImage imageWithContentsOfFile:[OCMArg any]])).andReturn(testImage);
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

        context(@"request with expired icon", ^{
            __block UIImage *resultImage = nil;
            __block NSError *resultError = nil;

            beforeEach(^{
                OCMStub(ClassMethod([mockArchiver archiveRootObject:[OCMArg any] toFile:[OCMArg any]])).andReturn(YES);

                OCMStub(ClassMethod([testManagerMock sdl_writeImage:[OCMArg any] toFileFromURL:[OCMArg any] atFilePath:[OCMArg any]])).andReturn(testFilePath);

                // to do delete
//                OCMStub([mockDataTask dataTaskWithURL:[OCMArg any] completionHandler:([OCMArg invokeBlockWithArgs:UIImagePNGRepresentation(testImage), blankResponse, [NSNull null], nil])]);

                OCMStub([testManagerMock sdl_downloadIconFromRequestURL:[OCMArg any] withCompletionHandler:([OCMArg invokeBlockWithArgs:testImage, [NSNull null], nil])]);

                [testManager retrieveImageForRequest:expiredTestRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                    resultImage = image;
                    resultError = error;
                }];
            });

            it(@"it should return downloaded image", ^{
                expect(resultImage).to(equal(testImage));
                expect(resultError).to(beNil());
            });

        });
    });

    describe(@"Receiving a new icon", ^{
        context(@"When no directory is created", ^{

        });

        context(@"When directory is created", ^{

        });
    });

});

QuickSpecEnd
