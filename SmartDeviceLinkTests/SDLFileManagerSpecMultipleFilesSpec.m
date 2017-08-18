//
//  SDLFileManagerSpecMultipleFilesSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/17/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteFileResponse.h"
#import "SDLError.h"
#import "SDLFile.h"
#import "SDLFileManager.h"
#import "SDLFileType.h"
#import "SDLListFiles.h"
#import "SDLListFilesOperation.h"
#import "SDLListFilesResponse.h"
#import "SDLNotificationConstants.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLRPCResponse.h"
#import "SDLUploadFileOperation.h"
#import "TestMultipleFilesConnectionManager.h"
#import "TestProgressResponse.h"
#import "TestResponse.h"

QuickSpecBegin(SDLFileManagerSpecMultipleFilesSpec)

describe(@"Uploading multiple files", ^{
    __block TestMultipleFilesConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block NSUInteger initialSpaceAvailable = 0;
    __block SDLListFilesResponse *testListFilesResponse = nil;
    __block NSMutableArray<SDLFile *> *testSDLFiles = nil;
    __block NSMutableArray *expectedSuccessfulFileNames;
    __block NSNumber *expectedSpaceLeft = nil;

    beforeEach(^{
        testConnectionManager = [[TestMultipleFilesConnectionManager alloc] init];
        testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager];
        initialSpaceAvailable = 9666;

        testListFilesResponse = [[SDLListFilesResponse alloc] init];
        testListFilesResponse.success = @YES;
        testListFilesResponse.spaceAvailable = @(initialSpaceAvailable);
        testListFilesResponse.filenames = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", nil];

        testSDLFiles = [NSMutableArray array];
        expectedSuccessfulFileNames = [NSMutableArray array];
    });

    context(@"After uploading", ^{
        beforeEach(^{
            waitUntil(^(void (^done)(void)){
                [testFileManager startWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                    done();
                }];

                // Need to wait state machine transitions to complete before sending testListFilesResponse
                [NSThread sleepForTimeInterval:0.3];

                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];
            });
        });

        context(@"When all files are uploaded successfully", ^{
            __block SDLPutFileResponse *response;
            __block NSError *responseError = nil;
            __block NSMutableDictionary *testResponses = [[NSMutableDictionary alloc] init];

            beforeEach(^{
                // Successful response
                response = [[SDLPutFileResponse alloc] init];
                response.success = @YES;
            });

            it(@"should upload 1 small file from memory without error", ^{
                NSString *fileName = [NSString stringWithFormat:@"Test Small File Memory %d", 0];
                NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                file.overwrite = true;

                [testSDLFiles addObject:file];

                expectedSpaceLeft = @55;
                response.spaceAvailable = expectedSpaceLeft;

                [expectedSuccessfulFileNames addObject:fileName];
                TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                testResponses[fileName] = testResponse;
                testConnectionManager.responses = testResponses;
            });

            it(@"should upload 1 large file from disk without error", ^{
                NSString *imageName = @"testImage";
                NSString *imageFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:imageName ofType:@"png"];
                NSURL *imageFileURL = [[NSURL alloc] initFileURLWithPath:imageFilePath];

                NSString *fileName = [NSString stringWithFormat:@"Test Large File Disk %d", 0];
                SDLFile *file = [SDLFile fileAtFileURL:imageFileURL name:fileName];
                file.overwrite = true;

                [testSDLFiles addObject:file];

                expectedSpaceLeft = @44;
                response.spaceAvailable = expectedSpaceLeft;

                [expectedSuccessfulFileNames addObject:fileName];

                TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                testResponses[fileName] = testResponse;
                testConnectionManager.responses = testResponses;
            });

            it(@"should upload multiple small files from memory without error", ^{
                NSInteger space = initialSpaceAvailable;
                for(int i = 0; i < 5; i += 1) {
                    NSString *fileName = [NSString stringWithFormat:@"Test Files %d", i];
                    NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                    SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                    file.overwrite = true;
                    [testSDLFiles addObject:file];

                    space -= 10;
                    response.spaceAvailable = @(space);

                    [expectedSuccessfulFileNames addObject:fileName];

                    TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                    testResponses[fileName] = testResponse;
                }

                expectedSpaceLeft = @(space);
                testConnectionManager.responses = testResponses;
            });

            it(@"should upload a large number of small files from memory without error", ^{
                NSInteger space = initialSpaceAvailable;
                for(int i = 0; i < 500; i += 1) {
                    NSString *fileName = [NSString stringWithFormat:@"Test Files %d", i];
                    NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                    SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                    file.overwrite = true;
                    [testSDLFiles addObject:file];

                    space -= 10;
                    response.spaceAvailable = @(space);

                    [expectedSuccessfulFileNames addObject:fileName];

                    TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                    testResponses[fileName] = testResponse;
                }

                expectedSpaceLeft = @(space);
                testConnectionManager.responses = testResponses;
            });

            it(@"should upload 5 small files from disk without error", ^{
                NSURL *imageFileURL = nil;
                NSInteger space = initialSpaceAvailable;
                for(int i = 0; i < 5; i += 1) {
                    NSString *imageName = [NSString stringWithFormat:@"testImage%d", i];
                    NSString *imageFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:imageName ofType:@"png"];
                    imageFileURL = [[NSURL alloc] initFileURLWithPath:imageFilePath];

                    NSString *fileName = [NSString stringWithFormat:@"TestMultipleLargeFilesDisk%d", i];
                    SDLFile *file = [SDLFile fileAtFileURL:imageFileURL name:fileName];

                    file.overwrite = true;
                    [testSDLFiles addObject:file];

                    space -= 10;
                    response.spaceAvailable = @(space);

                    [expectedSuccessfulFileNames addObject:fileName];

                    TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                    testResponses[fileName] = testResponse;
                }
                expectedSpaceLeft = @(space);
                testConnectionManager.responses = testResponses;
            });

            it(@"should upload multiple files from memory and on disk without error", ^{
                NSInteger space = initialSpaceAvailable;
                for(int i = 0; i < 10; i += 1) {
                    NSString *fileName = [NSString stringWithFormat:@"TestMultipleSDiskAndMemory%d", i];
                    NSData *fileData = nil;
                    SDLFile *testFile = nil;

                    if (i < 5) {
                        NSString *textFileName = [NSString stringWithFormat:@"testImageA%d", i];
                        NSString *textFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:textFileName ofType:@"png"];
                        NSURL *textFileURL = [[NSURL alloc] initFileURLWithPath:textFilePath];

                        fileData = [[NSData alloc] initWithContentsOfURL:textFileURL];
                        testFile = [SDLFile fileAtFileURL:textFileURL name:fileName];
                    } else {
                        fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                        testFile = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                    }

                    testFile.overwrite = true;
                    [testSDLFiles addObject:testFile];

                    space -= 10;
                    response.spaceAvailable = @(space);

                    [expectedSuccessfulFileNames addObject:fileName];

                    TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                    testResponses[fileName] = testResponse;
                }
                expectedSpaceLeft = @(space);
                testConnectionManager.responses = testResponses;
            });

            afterEach(^{
                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(beNil());
                        done();
                    }];
                });
            });
        });

        context(@"When files are uploaded successfully with progress handlers", ^{
            __block SDLPutFileResponse *response;
            __block NSError *responseError = nil;
            __block NSMutableDictionary *testResponses;
            __block NSMutableDictionary *testProgressResponses;

            beforeEach(^{
                testResponses = [[NSMutableDictionary alloc] init];
                testProgressResponses = [[NSMutableDictionary alloc] init];

                // Successful response
                response = [[SDLPutFileResponse alloc] init];
                response.success = @YES;
            });

            it(@"should upload 1 small file from memory without error", ^{
                NSString *fileName = [NSString stringWithFormat:@"Test Small File Memory %d", 0];
                NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                file.overwrite = true;

                [testSDLFiles addObject:file];

                expectedSpaceLeft = @55;
                response.spaceAvailable = expectedSpaceLeft;

                [expectedSuccessfulFileNames addObject:fileName];
                TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                testResponses[fileName] = testResponse;
                testConnectionManager.responses = testResponses;

                TestProgressResponse *testProgressResponse = [[TestProgressResponse alloc] initWithFileName:fileName testUploadPercentage:1.0 error:nil];
                testProgressResponses[fileName] = testProgressResponse;
            });

            it(@"should upload a large number of small files from memory without error", ^{
                NSInteger space = initialSpaceAvailable;

                int totalFileCount = 200;
                NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];

                float testTotalBytesToUpload = totalFileCount * fileData.length;
                float testTotalBytesUploaded = 0.0;

                for(int i = 0; i < totalFileCount; i += 1) {
                    NSString *fileName = [NSString stringWithFormat:@"Test Files %d", i];
                    SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                    file.overwrite = true;
                    [testSDLFiles addObject:file];

                    space -= 10;
                    response.spaceAvailable = @(space);

                    [expectedSuccessfulFileNames addObject:fileName];

                    TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                    testResponses[fileName] = testResponse;

                    testTotalBytesUploaded += file.fileSize;
                    float uploadPercentage = testTotalBytesUploaded / testTotalBytesToUpload;

                    TestProgressResponse *testProgressResponse = [[TestProgressResponse alloc] initWithFileName:fileName testUploadPercentage:uploadPercentage error:nil];
                    testProgressResponses[fileName] = testProgressResponse;
                }

                expectedSpaceLeft = @(space);
                testConnectionManager.responses = testResponses;
            });

            afterEach(^{
                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles progressHandler:^(NSString * _Nonnull fileName, float uploadPercentage, Boolean * _Nonnull cancel, NSError * _Nullable error) {
                        TestProgressResponse *testProgressResponse = testProgressResponses[fileName];
                        expect(fileName).to(equal(testProgressResponse.testFileName));
                        expect(uploadPercentage).to(equal(testProgressResponse.testUploadPercentage));
                        expect(error).to(testProgressResponse.testError == nil ? beNil() : equal(testProgressResponse.testError));
                    } completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(beNil());
                        done();
                    }];
                });
            });
        });

        context(@"When an upload is cancelled while in progress by the cancel parameter of the progress handler", ^{
            __block NSMutableDictionary *testResponses = [[NSMutableDictionary alloc] init];
            __block NSMutableDictionary *testProgressResponses = [[NSMutableDictionary alloc] init];
            __block NSString *testFileName;
            __block int totalFileCount = 0;
            __block int cutoff = 0;

            beforeEach(^{
                // [expectedSuccessfulFileNames removeAllObjects];
            });

            it(@"should cancel the remaining 9 files", ^{
                cutoff = 0;
                testFileName = @"Test Files Cancel After First";
            });

            it(@"should cancel the remaining 6 files", ^{
                cutoff = 4;
                testFileName = @"Test Files Cancel In Middle";
            });

            it(@"should not fail if there are no more files to cancel", ^{
                cutoff = (totalFileCount - 1);
                testFileName = @"Test Files Cancel At End";
            });

            afterEach(^{
                // File data
                NSData *testData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                totalFileCount = 10;
                NSInteger space = initialSpaceAvailable;
                for(int i = 0; i < totalFileCount; i += 1) {
                    NSString *fileName = [NSString stringWithFormat:@"%@ %d", testFileName, i];
                    SDLFile *file = [SDLFile fileWithData:testData name:fileName fileExtension:@"bin"];
                    file.overwrite = true;
                    [testSDLFiles addObject:file];

                    // Successful response
                    SDLPutFileResponse *response = [[SDLPutFileResponse alloc] init];
                    space -= 10;
                    response.success = @YES;
                    response.spaceAvailable = @(space);

                    if (i <= cutoff) {
                        [expectedSuccessfulFileNames addObject:fileName];
                    }

                    TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:nil];
                    testResponses[fileName] = testResponse;

                    TestProgressResponse *testProgressResponse = [[TestProgressResponse alloc] initWithFileName:fileName testUploadPercentage:0.0 error:nil];
                    testProgressResponses[fileName] = testProgressResponse;
                }

                expectedSpaceLeft = @(space);
                testConnectionManager.responses = testResponses;

                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles progressHandler:^(NSString * _Nonnull fileName, float uploadPercentage, Boolean * _Nonnull cancel, NSError * _Nullable error) {
                        // Once an operation is cancelled, there is no expected order to the cancellations, so upload percentage will vary for canceled operations depending on the order in which they are cancelled.
                        TestProgressResponse *testProgressResponse = testProgressResponses[fileName];
                        expect(fileName).to(equal([testProgressResponse testFileName]));

                        NSString *cancelFileName = [NSString stringWithFormat:@"%@ %d", testFileName, cutoff];
                        if ([fileName isEqual:cancelFileName]) {
                            (*cancel) = YES;
                        }
                    } completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(beNil());
                        done();
                    }];
                });
            });
        });
        
        afterEach(^{
            for(int i = 0; i < expectedSuccessfulFileNames.count; i += 1) {
                expect(testFileManager.remoteFileNames).to(contain(expectedSuccessfulFileNames[i]));
            }
        });
    });
});

QuickSpecEnd
