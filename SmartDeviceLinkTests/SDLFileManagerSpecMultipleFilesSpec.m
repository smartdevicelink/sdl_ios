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
            __block NSMutableDictionary *testResponses;

            beforeEach(^{
                testResponses = [[NSMutableDictionary alloc] init];

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

        context(@"When files are not uploaded successfully", ^{
            __block NSMutableDictionary *testResponses;
            __block NSMutableDictionary *expectedFailedUploads;
            __block NSError *expectedError = nil;

            beforeEach(^{
                testResponses = [[NSMutableDictionary alloc] init];
                expectedFailedUploads = [[NSMutableDictionary alloc] init];
            });

            it(@"should return an error when all files fail", ^{
                for(int i = 0; i < 5; i += 1) {
                    NSString *fileName = [NSString stringWithFormat:@"Test Files Unsuccessful %d", i];
                    NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                    SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                    file.overwrite = true;
                    [testSDLFiles addObject:file];

                    // Failed response
                    SDLPutFileResponse *response = [[SDLPutFileResponse alloc] init];
                    response.spaceAvailable = @(initialSpaceAvailable);
                    response.success = @NO;

                    // Failed error
                    NSString *responseErrorDescription = [NSString stringWithFormat:@"file upload failed: %d", i];
                    NSString *responseErrorReason = [NSString stringWithFormat:@"some error reason: %d", i];
                    NSError *responseError = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason];

                    TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                    testResponses[fileName] = testResponse;
                    expectedFailedUploads[fileName] = responseError;
                }

                testConnectionManager.responses = testResponses;
                expectedError = [NSError sdl_fileManager_unableToUploadError:expectedFailedUploads];
                expectedSpaceLeft = [[NSNumber alloc] initWithInteger:initialSpaceAvailable];
            });

            it(@"should return an error when the first file fails", ^{
                NSInteger space = initialSpaceAvailable;
                for(int i = 0; i < 6; i += 1) {
                    NSString *fileName = [NSString stringWithFormat:@"Test Files Unsuccessful %d", i];
                    NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                    SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                    file.overwrite = true;
                    [testSDLFiles addObject:file];

                    SDLPutFileResponse *response = [[SDLPutFileResponse alloc] init];
                    NSError *responseError = nil;
                    if (i == 0) {
                        // Failed response
                        response.spaceAvailable = @(space);
                        response.success = @NO;

                        // Failed error
                        NSString *responseErrorDescription = [NSString stringWithFormat:@"file upload failed: %d", i];
                        NSString *responseErrorReason = [NSString stringWithFormat:@"some error reason: %d", i];
                        responseError = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason];

                        expectedFailedUploads[fileName] = responseError;
                    } else {
                        // Successful response
                        space -= 1;
                        response.spaceAvailable = @(space);
                        response.success = @YES;

                        // No error
                        responseError = nil;

                        [expectedSuccessfulFileNames addObject:fileName];
                    }

                    TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                    testResponses[fileName] = testResponse;
                }

                testConnectionManager.responses = testResponses;
                expectedError = [NSError sdl_fileManager_unableToUploadError:expectedFailedUploads];
                expectedSpaceLeft = [[NSNumber alloc] initWithInteger:space];
            });

            it(@"should return an error when the last file fails", ^{
                NSInteger space = initialSpaceAvailable;
                for(int i = 0; i < 100; i += 1) {
                    NSString *fileName = [NSString stringWithFormat:@"Test Files Unsuccessful %d", i];
                    NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                    SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                    file.overwrite = true;
                    [testSDLFiles addObject:file];

                    SDLPutFileResponse *response = [[SDLPutFileResponse alloc] init];
                    NSError *responseError = nil;
                    if (i == 99) {
                        // Failed response
                        response.spaceAvailable = @(space);
                        response.success = @NO;

                        // Failed error
                        NSString *responseErrorDescription = [NSString stringWithFormat:@"file upload failed: %d", i];
                        NSString *responseErrorReason = [NSString stringWithFormat:@"some error reason: %d", i];
                        responseError = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason];

                        expectedFailedUploads[fileName] = responseError;
                    } else {
                        // Successful response
                        space -= 5;
                        response.spaceAvailable = @(space);
                        response.success = @YES;

                        // No error
                        responseError = nil;

                        [expectedSuccessfulFileNames addObject:fileName];
                    }

                    TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                    testResponses[fileName] = testResponse;
                }

                testConnectionManager.responses = testResponses;
                expectedError = [NSError sdl_fileManager_unableToUploadError:expectedFailedUploads];
                expectedSpaceLeft = [[NSNumber alloc] initWithInteger:space];
            });

            it(@"should return an error if 0 files passed", ^{
                expectedError = [NSError sdl_fileManager_noFilesError];
                expectedSpaceLeft = [[NSNumber alloc] initWithInteger:initialSpaceAvailable];
            });

            it(@"should return an error if remote files contains same name", ^{
                SDLPutFileResponse *response = [[SDLPutFileResponse alloc] init];
                NSError *responseError = nil;

                NSString *fileName = testListFilesResponse.filenames.firstObject;
                NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                file.overwrite = false;
                [testSDLFiles addObject:file];

                response.spaceAvailable = @(initialSpaceAvailable);
                response.success = @NO;

                TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:responseError];
                testResponses[fileName] = testResponse;

                testConnectionManager.responses = testResponses;
                expectedFailedUploads[fileName] = [NSError sdl_fileManager_cannotOverwriteError];
                expectedError = [NSError sdl_fileManager_unableToUploadError:expectedFailedUploads];
                expectedSpaceLeft = @(initialSpaceAvailable);
            });
            
            afterEach(^{
                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(equal(expectedError));
                        done();
                    }];
                });
            });
        });
        
        afterEach(^{
            expect(@(testFileManager.bytesAvailable)).to(equal(expectedSpaceLeft));
            for(int i = 0; i < expectedSuccessfulFileNames.count; i += 1) {
                expect(testFileManager.remoteFileNames).to(contain(expectedSuccessfulFileNames[i]));
            }
        });
    });
});

QuickSpecEnd
