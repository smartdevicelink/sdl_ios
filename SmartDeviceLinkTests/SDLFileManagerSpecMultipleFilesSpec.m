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

describe(@"SDLFileManager uploading/deleting multiple files", ^{
    __block TestMultipleFilesConnectionManager *testConnectionManager;
    __block SDLFileManager *testFileManager;
    __block NSUInteger initialSpaceAvailable;

    beforeEach(^{
        testConnectionManager = [[TestMultipleFilesConnectionManager alloc] init];
        testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager];
        initialSpaceAvailable = 66666;
    });

    context(@"When the file manager is passed multiple files to upload", ^{
        __block SDLListFilesResponse *testListFilesResponse;
        __block NSMutableArray<SDLFile *> *testSDLFiles;
        __block NSMutableArray *expectedSuccessfulFileNames;
        __block NSNumber *expectedSpaceLeft;
        __block SDLPutFileResponse *failedResponse;
        __block SDLPutFileResponse *successfulResponse;

        beforeEach(^{
            testSDLFiles = [NSMutableArray array];
            expectedSuccessfulFileNames = [NSMutableArray array];
            expectedSpaceLeft = @(initialSpaceAvailable);

            testListFilesResponse = [[SDLListFilesResponse alloc] init];
            testListFilesResponse.success = @YES;
            testListFilesResponse.spaceAvailable = @(initialSpaceAvailable);
            testListFilesResponse.filenames = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", nil];

            failedResponse = [[SDLPutFileResponse alloc] init];
            failedResponse.success = @NO;
            failedResponse.spaceAvailable = @(initialSpaceAvailable);

            successfulResponse = [[SDLPutFileResponse alloc] init];
            successfulResponse.success = @YES;
            successfulResponse.spaceAvailable = @(initialSpaceAvailable);

            waitUntilTimeout(10, ^(void (^done)(void)){
                [testFileManager startWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                    done();
                }];

                // Need to wait state machine transitions to complete before sending testListFilesResponse
                [NSThread sleepForTimeInterval:0.3];

                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];
            });
        });

        context(@"and all files are uploaded successfully", ^{
            __block NSError *successfulResponseError = nil;
            __block NSMutableDictionary *testConnectionManagerResponses = [[NSMutableDictionary alloc] init];

            it(@"should not return an error when one small file is uploaded from memory", ^{
                NSString *testFileName = [NSString stringWithFormat:@"TestSmallFileMemory%d", 0];
                SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                testSDLFile.overwrite = true;
                [testSDLFiles addObject:testSDLFile];

                [expectedSuccessfulFileNames addObject:testFileName];
                testConnectionManagerResponses[testFileName] = [[TestResponse alloc] initWithResponse:successfulResponse error:successfulResponseError];
                testConnectionManager.responses = testConnectionManagerResponses;
            });

            it(@"should not return an error when one large file is uploaded from disk", ^{
                NSString *testFileName = [NSString stringWithFormat:@"TestLargeFileDisk%d", 0];
                SDLFile *testSDLFile = [SDLFile fileAtFileURL: [[NSURL alloc] initFileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"testImage" ofType:@"png"]] name:testFileName];
                testSDLFile.overwrite = true;
                [testSDLFiles addObject:testSDLFile];

                [expectedSuccessfulFileNames addObject:testFileName];
                testConnectionManagerResponses[testFileName] = [[TestResponse alloc] initWithResponse:successfulResponse error:successfulResponseError];
                testConnectionManager.responses = testConnectionManagerResponses;
            });

            it(@"should not return an error when multiple small files are uploaded from memory", ^{
                NSInteger testSpaceAvailable = initialSpaceAvailable;
                for(int i = 0; i < 5; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];

                    successfulResponse.spaceAvailable = @(testSpaceAvailable -= 5);

                    [expectedSuccessfulFileNames addObject:testFileName];
                    testConnectionManagerResponses[testFileName] = [[TestResponse alloc] initWithResponse:successfulResponse error:successfulResponseError];
                }
                expectedSpaceLeft = @(testSpaceAvailable);
                testConnectionManager.responses = testConnectionManagerResponses;
            });

            it(@"should not return an error when a large number of small files are uploaded from memory", ^{
                NSInteger testSpaceAvailable = initialSpaceAvailable;
                for(int i = 0; i < 500; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"Test500FilesMemory%d", i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];

                    successfulResponse.spaceAvailable = @(testSpaceAvailable -= 4);

                    [expectedSuccessfulFileNames addObject:testFileName];
                    testConnectionManagerResponses[testFileName] = [[TestResponse alloc] initWithResponse:successfulResponse error:successfulResponseError];
                }
                expectedSpaceLeft = @(testSpaceAvailable);
                testConnectionManager.responses = testConnectionManagerResponses;
            });

            it(@"should not return an error when multiple small files are uploaded from disk", ^{
                NSInteger testSpaceAvailable = initialSpaceAvailable;
                for(int i = 0; i < 5; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestMultipleLargeFilesDisk%d", i];
                    SDLFile *testSDLFile = [SDLFile fileAtFileURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:[NSString stringWithFormat:@"testImage%d", i] ofType:@"png"]] name:testFileName];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];

                    successfulResponse.spaceAvailable = @(testSpaceAvailable -= 3);

                    [expectedSuccessfulFileNames addObject:testFileName];
                    testConnectionManagerResponses[testFileName] = [[TestResponse alloc] initWithResponse:successfulResponse error:successfulResponseError];
                }
                expectedSpaceLeft = @(testSpaceAvailable);
                testConnectionManager.responses = testConnectionManagerResponses;
            });

            it(@"should not return an error when multiple files are uploaded from both memory and disk", ^{
                NSInteger testSpaceAvailable = initialSpaceAvailable;
                for(int i = 0; i < 10; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestMultipleFilesDiskAndMemory%d", i];
                    SDLFile *testSDLFile;
                    if (i < 5) {
                        testSDLFile = [SDLFile fileAtFileURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:[NSString stringWithFormat:@"testImageA%d", i] ofType:@"png"]] name:testFileName];
                    } else {
                        testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    }
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];

                    successfulResponse.spaceAvailable = @(testSpaceAvailable -= 2);

                    [expectedSuccessfulFileNames addObject:testFileName];
                    testConnectionManagerResponses[testFileName] = [[TestResponse alloc] initWithResponse:successfulResponse error:successfulResponseError];
                }
                expectedSpaceLeft = @(testSpaceAvailable);
                testConnectionManager.responses = testConnectionManagerResponses;
            });

            afterEach(^{
                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(beNil());
                        expect(testFileManager.bytesAvailable).to(equal(expectedSpaceLeft));
                        done();
                    }];
                });
            });
        });

        context(@"and all files are not uploaded successfully", ^{
            __block NSMutableDictionary *testConnectionManagerResponses;
            __block NSMutableDictionary *expectedFailedUploads;
            __block NSError *expectedError;
            __block int testTotalFileCount;
            __block NSString *testFileNameBase;
            __block int testFailureIndexStart;
            __block int testFailureIndexEnd;

            beforeEach(^{
                testConnectionManagerResponses = [[NSMutableDictionary alloc] init];
                expectedFailedUploads = [[NSMutableDictionary alloc] init];
                expectedError = nil;
            });

            context(@"When the file manager receives a notification from the remote that a file upload failed", ^{
                beforeEach(^{
                    testFailureIndexStart = -1;
                    testFailureIndexEnd = INT8_MAX;
                });

                it(@"should return an error when all files fail", ^{
                    testTotalFileCount = 5;
                    testFileNameBase = @"TestAllFilesUnsuccessful";
                    testFailureIndexStart = testTotalFileCount;
                });

                it(@"should return an error when the first file fails to upload", ^{
                    testTotalFileCount = 5;
                    testFileNameBase = @"TestFirstFileUnsuccessful";
                    testFailureIndexStart = 0;
                });

                it(@"should return an error when the last file fails to upload", ^{
                    testTotalFileCount = 100;
                    testFileNameBase = @"TestLastFileUnsuccessful";
                    testFailureIndexEnd = (testTotalFileCount - 1);
                });

                afterEach(^{
                    NSInteger testSpaceAvailable = initialSpaceAvailable;
                    for(int i = 0; i < testTotalFileCount; i += 1) {
                        NSString *testFileName = [NSString stringWithFormat:@"%@%d", testFileNameBase, i];
                        SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                        testSDLFile.overwrite = true;
                        [testSDLFiles addObject:testSDLFile];

                        SDLPutFileResponse *response = [[SDLPutFileResponse alloc] init];
                        NSError *responseError = nil;
                        if (i <= testFailureIndexStart || i >= testFailureIndexEnd) {
                            // Failed response
                            response = failedResponse;
                            response.spaceAvailable = @(testSpaceAvailable);
                            responseError = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:[NSString stringWithFormat:@"file upload failed: %d", i] andReason:[NSString stringWithFormat:@"some error reason: %d", i]];
                            expectedFailedUploads[testFileName] = responseError;
                        } else {
                            // Successful response
                            response = successfulResponse;
                            response.spaceAvailable = @(testSpaceAvailable -= 1);
                            responseError = nil;
                            [expectedSuccessfulFileNames addObject:testFileName];
                        }

                        testConnectionManagerResponses[testFileName] = [[TestResponse alloc] initWithResponse:response error:responseError];;
                    }

                    testConnectionManager.responses = testConnectionManagerResponses;
                    expectedError = [NSError sdl_fileManager_unableToUploadError:expectedFailedUploads];
                    expectedSpaceLeft = @(testSpaceAvailable);
                });
            });

            it(@"should return an error if empty array of files is passed to file manager", ^{
                [testSDLFiles removeAllObjects];
                expectedError = [NSError sdl_fileManager_noFilesError];
                expectedSpaceLeft = @(initialSpaceAvailable);
            });

            afterEach(^{
                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(equal(expectedError));
                        expect(testFileManager.bytesAvailable).to(equal(expectedSpaceLeft));
                        done();
                    }];
                });
            });
        });

        context(@"and all files are uploaded successfully while expecting a progress response for each file", ^{
            __block NSMutableDictionary *testFileManagerResponses;
            __block NSMutableDictionary *testFileManagerProgressResponses;
            __block int testTotalFileCount;
            __block NSString *testFileNameBase;

            beforeEach(^{
                testFileManagerResponses = [[NSMutableDictionary alloc] init];
                testFileManagerProgressResponses = [[NSMutableDictionary alloc] init];
            });

            context(@"A progress handler should be returned for each file", ^{
                it(@"should upload 1 small file from memory without error", ^{
                    testTotalFileCount = 1;
                    testFileNameBase = @"TestProgressHandlerOneSmallFileMemory";
                });

                it(@"should upload a large number of small files from memory without error", ^{
                    testTotalFileCount = 200;
                    testFileNameBase = @"TestProgressHandlerMultipleSmallFileMemory";
                });

                afterEach(^{
                    NSData *testFileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                    float testTotalBytesToUpload = testTotalFileCount * testFileData.length;
                    float testTotalBytesUploaded = 0.0;

                    NSInteger testSpaceAvailable = initialSpaceAvailable;
                    for(int i = 0; i < testTotalFileCount; i += 1) {
                        NSString *testFileName = [NSString stringWithFormat:@"%@%d", testFileNameBase, i];
                        SDLFile *testSDLFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];
                        testSDLFile.overwrite = true;
                        [testSDLFiles addObject:testSDLFile];

                        successfulResponse.spaceAvailable = @(testSpaceAvailable -= 10);
                        [expectedSuccessfulFileNames addObject:testFileName];
                        testFileManagerResponses[testFileName] = [[TestResponse alloc] initWithResponse:successfulResponse error:nil];

                        testTotalBytesUploaded += testSDLFile.fileSize;
                        testFileManagerProgressResponses[testFileName] = [[TestProgressResponse alloc] initWithFileName:testFileName testUploadPercentage:testTotalBytesUploaded / testTotalBytesToUpload error:nil];
                    }
                    expectedSpaceLeft = @(testSpaceAvailable);
                    testConnectionManager.responses = testFileManagerResponses;
                });
            });

            afterEach(^{
                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles progressHandler:^(NSString * _Nonnull fileName, float uploadPercentage, Boolean * _Nonnull cancel, NSError * _Nullable error) {
                        TestProgressResponse *testProgressResponse = testFileManagerProgressResponses[fileName];
                        expect(fileName).to(equal(testProgressResponse.testFileName));
                        expect(uploadPercentage).to(equal(testProgressResponse.testUploadPercentage));
                        expect(error).to(testProgressResponse.testError == nil ? beNil() : equal(testProgressResponse.testError));
                    } completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(beNil());
                        expect(testFileManager.bytesAvailable).to(equal(expectedSpaceLeft));
                        done();
                    }];
                });
            });
        });

        context(@"When an upload is cancelled while in progress by the cancel parameter of the progress handler", ^{
            __block NSMutableDictionary *testResponses;
            __block NSMutableDictionary *testProgressResponses;
            __block NSString *testFileNameBase;
            __block int testFileCount = 0;
            __block int testCancelIndex = 0;
            __block NSError *expectedError;

            beforeEach(^{
                testResponses = [[NSMutableDictionary alloc] init];
                testProgressResponses = [[NSMutableDictionary alloc] init];
            });

            it(@"should cancel the remaining files if cancel is triggered after first upload", ^{
                testFileCount = 11;
                testCancelIndex = 0;
                testFileNameBase = @"TestUploadFilesCancelAfterFirst";
                expectedError = [NSError sdl_fileManager_unableToUploadError:testResponses];
            });

            it(@"should cancel the remaining files if cancel is triggered after half of the files are uploaded", ^{
                testFileCount = 30;
                testCancelIndex = testFileCount / 2;
                testFileNameBase = @"TestUploadFilesCancelInMiddle";
                expectedError = [NSError sdl_fileManager_unableToUploadError:testResponses];
            });

            it(@"should not fail if there are no more files to cancel", ^{
                testFileCount = 20;
                testCancelIndex = (testFileCount - 1);
                testFileNameBase = @"TestUploadFilesCancelAtEnd";
                expectedError = nil;
            });

            afterEach(^{
                for(int i = 0; i < testFileCount; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"%@%d", testFileNameBase, i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];

                    if (i <= testCancelIndex) {
                        [expectedSuccessfulFileNames addObject:testFileName];
                    }

                    testResponses[testFileName] = [[TestResponse alloc] initWithResponse:successfulResponse error:nil];
                    testProgressResponses[testFileName] = [[TestProgressResponse alloc] initWithFileName:testFileName testUploadPercentage:0.0 error:nil];
                }
                testConnectionManager.responses = testResponses;

                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles progressHandler:^(NSString * _Nonnull fileName, float uploadPercentage, Boolean * _Nonnull cancel, NSError * _Nullable error) {
                        // Once an operation is cancelled, the order in which the cancellations complete is random, so upload percentage and the error message can vary depending on the order in which they are cancelled.
                        TestProgressResponse *testProgressResponse = testProgressResponses[fileName];
                        expect(fileName).to(equal(testProgressResponse.testFileName));

                        NSString *cancelFileName = [NSString stringWithFormat:@"%@%d", testFileNameBase, testCancelIndex];
                        if ([fileName isEqual:cancelFileName]) {
                            (*cancel) = YES;
                        }
                    } completionHandler:^(NSError * _Nullable error) {
                        if (expectedError != nil) {
                            expect(error.code).to(equal(SDLFileManagerErrorUnableToUpload));
                        } else {
                            expect(error).to(beNil());
                        }
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

    context(@"When the file manager is passed multiple files to delete", ^{
        __block SDLListFilesResponse *testListFilesResponse;
        __block NSArray<NSString *> *testRemoteFileNames;
        __block NSMutableArray<NSString *> *expectedRemoteFileNames;
        __block NSNumber *expectedSpaceLeft;
        __block NSMutableArray *testDeleteFileNames;
        __block SDLDeleteFileResponse *failedDeleteResponse;
        __block SDLDeleteFileResponse *successfulDeleteResponse;
        __block NSError *expectedError = nil;

        beforeEach(^{
            testRemoteFileNames = [[NSArray alloc] initWithObjects:@"AA", @"BB", @"CC", @"DD", @"EE", @"FF", nil];
            expectedRemoteFileNames = [[NSMutableArray alloc] init];

            testListFilesResponse = [[SDLListFilesResponse alloc] init];
            testListFilesResponse.success = @YES;
            testListFilesResponse.spaceAvailable = @(initialSpaceAvailable);
            testListFilesResponse.filenames = testRemoteFileNames;

            // Failed delete response
            failedDeleteResponse = [[SDLDeleteFileResponse alloc] init];
            failedDeleteResponse.spaceAvailable = @10;
            failedDeleteResponse.success = @NO;

            // Successful delete response
            successfulDeleteResponse = [[SDLDeleteFileResponse alloc] init];
            successfulDeleteResponse.spaceAvailable = @9;
            successfulDeleteResponse.success = @YES;

            waitUntilTimeout(10, ^(void (^done)(void)){
                [testFileManager startWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                    done();
                }];

                // Need to wait state machine transitions to complete before sending testListFilesResponse
                [NSThread sleepForTimeInterval:0.3];

                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];
            });
        });

        context(@"and all files are deleted successfully", ^{
            __block NSMutableDictionary *testResponses;
            __block int testFileCount = 0;

            beforeEach(^{
                testResponses = [[NSMutableDictionary alloc] init];
                testDeleteFileNames = [[NSMutableArray alloc] init];
            });

            context(@"When the file manager receives a successful notification for each deleted file", ^{
                it(@"should not return an error when one remote file is deleted", ^{
                    testFileCount = 1;
                });

                it(@"should not return an error when all remote files are deleted", ^{
                    testFileCount = (int)testRemoteFileNames.count;
                });

                afterEach(^{
                    NSInteger testSpaceAvailable = initialSpaceAvailable;
                    for(int i = 0; i < testFileCount; i += 1) {
                        NSString *testFileName = [testRemoteFileNames objectAtIndex:i];
                        successfulDeleteResponse.spaceAvailable = @(testSpaceAvailable += 91);
                        testResponses[testFileName] = [[TestResponse alloc] initWithResponse:successfulDeleteResponse error:nil];
                        [testDeleteFileNames addObject:testFileName];
                    }
                    expectedSpaceLeft = @(testSpaceAvailable);
                    [expectedRemoteFileNames removeAllObjects];
                    testConnectionManager.responses = testResponses;
                });
            });
        });

        context(@"and all files are not deleted successfully", ^{
            __block NSMutableDictionary *testConnectionManagerResponses;
            __block NSMutableDictionary *expectedFailedDeletes;

            beforeEach(^{
                testConnectionManagerResponses = [[NSMutableDictionary alloc] init];
                testDeleteFileNames = [[NSMutableArray alloc] init];
                expectedFailedDeletes = [[NSMutableDictionary alloc] init];
            });

            context(@"When the file manager receives a unsuccessful notification for a deleted file", ^{
                __block int testFailureIndexStart;
                __block int testFailureIndexEnd;

                beforeEach(^{
                    testFailureIndexStart = -1;
                    testFailureIndexEnd = INT8_MAX;
                });

                it(@"should return an error if the first remote file fails to delete", ^{
                    testFailureIndexStart = 0;
                });

                it(@"should return an error if the last remote file fails to delete", ^{
                    testFailureIndexEnd = (int)testRemoteFileNames.count - 1;
                });

                it(@"should return an error if all files fail to delete", ^{
                    testFailureIndexStart = (int)testRemoteFileNames.count;
                });

                afterEach(^{
                    NSInteger testSpaceAvailable = initialSpaceAvailable;
                    for(int i = 0; i < testRemoteFileNames.count; i += 1) {
                        NSString *testFileName = [testRemoteFileNames objectAtIndex:i];

                        SDLDeleteFileResponse *response;
                        NSError *responseError;
                        if (i <= testFailureIndexStart || i >= testFailureIndexEnd) {
                            failedDeleteResponse.spaceAvailable = @(testSpaceAvailable);
                            response = failedDeleteResponse;
                            responseError = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:[NSString stringWithFormat:@"file upload failed: %d", i] andReason: [NSString stringWithFormat:@"some error reason: %d", i]];
                            expectedFailedDeletes[testFileName] = responseError;
                            [expectedRemoteFileNames addObject:testFileName];
                        } else {
                            successfulDeleteResponse.spaceAvailable = @(testSpaceAvailable += 891);
                            response = successfulDeleteResponse;
                            responseError = nil;
                        }

                        testConnectionManagerResponses[testFileName] = [[TestResponse alloc] initWithResponse:response error:responseError];
                        [testDeleteFileNames addObject:testFileName];
                    }

                    testConnectionManager.responses = testConnectionManagerResponses;
                    expectedError = [NSError sdl_fileManager_unableToDeleteError:expectedFailedDeletes];
                    expectedSpaceLeft = @(testSpaceAvailable);
                });
            });

            it(@"should return an error if empty array of file names is passed to file manager", ^{
                [testDeleteFileNames removeAllObjects];
                expectedError = [NSError sdl_fileManager_noFilesError];
                expectedSpaceLeft = @(initialSpaceAvailable);
            });
        });
        
        afterEach(^{
            waitUntilTimeout(10, ^(void (^done)(void)){
                [testFileManager deleteRemoteFilesWithNames:testDeleteFileNames completionHandler:^(NSError * _Nullable error) {
                    expect(error).to(expectedError == nil ? beNil() : equal(expectedError));
                    expect(testFileManager.bytesAvailable).to(equal(expectedSpaceLeft));
                    done();
                }];
            });

            for(int i = 0; i < expectedRemoteFileNames.count; i += 1) {
                expect(testFileManager.remoteFileNames).to(contain(expectedRemoteFileNames[i]));
            }
        });
    });
});

QuickSpecEnd
