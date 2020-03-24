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

@property (weak, nonatomic, nullable) NSURLSession *urlSession;
@property (weak, nonatomic, nullable) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSFileManager *fileManager;

@end

QuickSpecBegin(SDLCacheFileManagerSpec)

describe(@"a cache file manager", ^{
    __block SDLCacheFileManager *testManager = nil;

    beforeEach(^{
        testManager = [[SDLCacheFileManager alloc] init];
        testManager.fileManager = OCMClassMock([NSFileManager class]);
    });

    it(@"should initialize properties", ^{
        expect(testManager.urlSession).toNot(beNil());
    });

    describe(@"after receiving lock screen icon system request", ^{
    __block SDLOnSystemRequest *request = nil;
    __block NSString *testURL = nil;
    __block SDLIconArchiveFile *archiveFile = nil;

        describe(@"request with existing icon", ^{
            beforeEach(^{
                testURL = @"https://livio.io/";

                request = [[SDLOnSystemRequest alloc] init];
                request.url = testURL;
            });

            context(@"icon is not exipred", ^{
                // retrieve icon from path
                // return icon
            });

            context(@"icon is expired", ^{
                // download icon
                // update archive file
                // return icon
            });

        });

        describe(@"request with new icon", ^{
            // it should dowload the icon
        });

    });
});


QuickSpecEnd
