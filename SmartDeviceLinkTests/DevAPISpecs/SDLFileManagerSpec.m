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
#import "TestConnectionManager.h"
#import "TestMultipleFilesConnectionManager.h"
#import "TestProgressResponse.h"
#import "TestResponse.h"

typedef NSString SDLFileManagerState;
SDLFileManagerState *const SDLFileManagerStateShutdown = @"Shutdown";
SDLFileManagerState *const SDLFileManagerStateFetchingInitialList = @"FetchingInitialList";
SDLFileManagerState *const SDLFileManagerStateReady = @"Ready";

@interface SDLFileManager ()
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@end

QuickSpecBegin(SDLFileManagerSpec)

describe(@"SDLFileManager", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block NSUInteger initialSpaceAvailable = 250;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager];
        testFileManager.suspended = YES;
    });

    describe(@"before starting", ^{
        it(@"should be in the shutdown state", ^{
            expect(testFileManager.currentState).to(match(SDLFileManagerStateShutdown));
        });

        it(@"bytesAvailable should be 0", ^{
            expect(@(testFileManager.bytesAvailable)).to(equal(@0));
        });

        it(@"remoteFileNames should be empty", ^{
            expect(testFileManager.remoteFileNames).to(beEmpty());
        });

        it(@"should have no pending operations", ^{
            expect(testFileManager.pendingTransactions).to(beEmpty());
        });
    });

    describe(@"after receiving a start message", ^{
        __block BOOL startupSuccess = NO;
        __block NSError *startupError = nil;

        beforeEach(^{
            [testFileManager startWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                startupSuccess = success;
                startupError = error;
            }];

            testFileManager.suspended = NO;

            [NSThread sleepForTimeInterval:0.1];
        });

        it(@"should have queued a ListFiles request", ^{
            expect(testFileManager.pendingTransactions).to(haveCount(@1));
            expect(testFileManager.pendingTransactions.firstObject).to(beAnInstanceOf([SDLListFilesOperation class]));
        });

        it(@"should be in the fetching initial list state", ^{
            expect(testFileManager.currentState).to(match(SDLFileManagerStateFetchingInitialList));
        });

        describe(@"after going to the shutdown state and receiving a ListFiles response", ^{
            __block SDLListFilesResponse *testListFilesResponse = nil;
            __block NSSet<NSString *> *testInitialFileNames = nil;

            beforeEach(^{
                testInitialFileNames = [NSSet setWithArray:@[@"testFile1", @"testFile2", @"testFile3"]];

                testListFilesResponse = [[SDLListFilesResponse alloc] init];
                testListFilesResponse.success = @YES;
                testListFilesResponse.spaceAvailable = @(initialSpaceAvailable);
                testListFilesResponse.filenames = [NSArray arrayWithArray:[testInitialFileNames allObjects]];

                [testFileManager stop];
                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];
            });

            it(@"should remain in the stopped state after receiving the response if disconnected", ^{

                expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateShutdown));
            });
        });

        describe(@"after receiving a ListFiles response", ^{
            __block SDLListFilesResponse *testListFilesResponse = nil;
            __block NSSet<NSString *> *testInitialFileNames = nil;

            beforeEach(^{
                testInitialFileNames = [NSSet setWithArray:@[@"testFile1", @"testFile2", @"testFile3"]];

                testListFilesResponse = [[SDLListFilesResponse alloc] init];
                testListFilesResponse.success = @YES;
                testListFilesResponse.spaceAvailable = @(initialSpaceAvailable);
                testListFilesResponse.filenames = [NSArray arrayWithArray:[testInitialFileNames allObjects]];
                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];
            });

            it(@"the file manager should be in the correct state", ^{
                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];

                expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateReady));
                expect(testFileManager.remoteFileNames).toEventually(equal(testInitialFileNames));
                expect(@(testFileManager.bytesAvailable)).toEventually(equal(@(initialSpaceAvailable)));
            });

            describe(@"deleting a file", ^{
                __block BOOL completionSuccess = NO;
                __block NSUInteger completionBytesAvailable = 0;
                __block NSError *completionError = nil;

                context(@"when the file is unknown", ^{
                    beforeEach(^{
                        NSString *someUnknownFileName = @"Some Unknown File Name";
                        [testFileManager deleteRemoteFileWithName:someUnknownFileName completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                            completionSuccess = success;
                            completionBytesAvailable = bytesAvailable;
                            completionError = error;
                        }];

                        [NSThread sleepForTimeInterval:0.1];
                    });

                    it(@"should return the correct data", ^{
                        expect(@(completionSuccess)).toEventually(equal(@NO));
                        expect(@(completionBytesAvailable)).toEventually(equal(@250));
                        expect(completionError).toEventually(equal([NSError sdl_fileManager_noKnownFileError]));
                    });

                    it(@"should not have deleted any files in the file manager", ^{
                        expect(testFileManager.remoteFileNames).toEventually(haveCount(@(testInitialFileNames.count)));
                    });
                });

                context(@"when the file is known", ^{
                    __block NSUInteger newSpaceAvailable = 600;
                    __block NSString *someKnownFileName = nil;
                    __block BOOL completionSuccess = NO;
                    __block NSUInteger completionBytesAvailable = 0;
                    __block NSError *completionError = nil;

                    beforeEach(^{
                        someKnownFileName = [testInitialFileNames anyObject];
                        [testFileManager deleteRemoteFileWithName:someKnownFileName completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                            completionSuccess = success;
                            completionBytesAvailable = bytesAvailable;
                            completionError = error;
                        }];

                        SDLDeleteFileResponse *deleteResponse = [[SDLDeleteFileResponse alloc] init];
                        deleteResponse.success = @YES;
                        deleteResponse.spaceAvailable = @(newSpaceAvailable);

                        [NSThread sleepForTimeInterval:0.1];

                        [testConnectionManager respondToLastRequestWithResponse:deleteResponse];
                    });

                    it(@"should return the correct data", ^{
                        expect(@(completionSuccess)).to(equal(@YES));
                        expect(@(completionBytesAvailable)).to(equal(@(newSpaceAvailable)));
                        expect(@(testFileManager.bytesAvailable)).to(equal(@(newSpaceAvailable)));
                        expect(completionError).to(beNil());
                    });

                    it(@"should have removed the file from the file manager", ^{
                        expect(testFileManager.remoteFileNames).toNot(contain(someKnownFileName));
                    });
                });
            });

            describe(@"uploading a new file", ^{
                __block NSString *testFileName = nil;
                __block SDLFile *testUploadFile = nil;
                __block BOOL completionSuccess = NO;
                __block NSUInteger completionBytesAvailable = 0;
                __block NSError *completionError = nil;

                __block SDLPutFile *sentPutFile = nil;
                __block NSData *testFileData = nil;

                context(@"when there is a remote file named the same thing", ^{
                    beforeEach(^{
                        testFileName = [testInitialFileNames anyObject];
                        testFileData = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
                        testUploadFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];
                    });

                    context(@"when the file's overwrite property is YES", ^{
                        beforeEach(^{
                            testUploadFile.overwrite = YES;

                            [testFileManager uploadFile:testUploadFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                                completionSuccess = success;
                                completionBytesAvailable = bytesAvailable;
                                completionError = error;
                            }];

                            [NSThread sleepForTimeInterval:0.1];

                            sentPutFile = testConnectionManager.receivedRequests.lastObject;
                        });

                        it(@"should set the file manager state to be waiting", ^{
                            expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                        });

                        it(@"should create a putfile with the correct data", ^{
                            expect(sentPutFile.length).to(equal(@(testFileData.length)));
                            expect(sentPutFile.bulkData).to(equal(testFileData));
                            expect(sentPutFile.fileType).to(match(SDLFileTypeBinary));
                        });

                        context(@"when the response returns without error", ^{
                            __block SDLPutFileResponse *testResponse = nil;
                            __block NSNumber *testResponseSuccess = nil;
                            __block NSNumber *testResponseBytesAvailable = nil;

                            beforeEach(^{
                                testResponseBytesAvailable = @750;
                                testResponseSuccess = @YES;

                                testResponse = [[SDLPutFileResponse alloc] init];
                                testResponse.success = testResponseSuccess;
                                testResponse.spaceAvailable = testResponseBytesAvailable;

                                [testConnectionManager respondToLastRequestWithResponse:testResponse];
                            });

                            it(@"should set the file manager data correctly", ^{
                                expect(@(testFileManager.bytesAvailable)).toEventually(equal(testResponseBytesAvailable));
                                expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateReady));
                                expect(testFileManager.remoteFileNames).toEventually(contain(testFileName));
                            });

                            it(@"should call the completion handler with the correct data", ^{
                                expect(@(completionBytesAvailable)).toEventually(equal(testResponseBytesAvailable));
                                expect(@(completionSuccess)).toEventually(equal(@YES));
                                expect(completionError).to(beNil());
                            });
                        });

                        context(@"when the connection returns failure", ^{
                            __block SDLPutFileResponse *testResponse = nil;
                            __block NSNumber *testResponseBytesAvailable = nil;
                            __block NSNumber *testResponseSuccess = nil;

                            beforeEach(^{
                                testResponseBytesAvailable = @750;
                                testResponseSuccess = @NO;

                                testResponse = [[SDLPutFileResponse alloc] init];
                                testResponse.spaceAvailable = testResponseBytesAvailable;
                                testResponse.success = testResponseSuccess;

                                [testConnectionManager respondToLastRequestWithResponse:testResponse];
                            });

                            it(@"should set the file manager data correctly", ^{
                                expect(@(testFileManager.bytesAvailable)).toEventually(equal(@(initialSpaceAvailable)));
                                expect(testFileManager.remoteFileNames).toEventually(contain(testFileName));
                                expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateReady));
                            });

                            it(@"should call the completion handler with the correct data", ^{
                                expect(@(completionBytesAvailable)).to(equal(@0));
                                expect(@(completionSuccess)).to(equal(testResponseSuccess));
                                expect(completionError).toEventually(beNil());
                            });
                        });

                        context(@"when the connection errors without a response", ^{
                            beforeEach(^{
                                [testConnectionManager respondToLastRequestWithResponse:nil error:[NSError sdl_lifecycle_notReadyError]];
                            });

                            it(@"should have the correct file manager state", ^{
                                expect(testFileManager.remoteFileNames).to(contain(testFileName));
                                expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                            });

                            it(@"should call the completion handler with correct data", ^{
                                expect(completionError).toEventually(equal([NSError sdl_lifecycle_notReadyError]));
                            });
                        });
                    });

                    context(@"when allow overwrite is false", ^{
                        __block SDLRPCRequest *lastRequest = nil;

                        beforeEach(^{
                            testUploadFile.overwrite = NO;

                            [testFileManager uploadFile:testUploadFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                                completionSuccess = success;
                                completionBytesAvailable = bytesAvailable;
                                completionError = error;
                            }];

                            [NSThread sleepForTimeInterval:0.1];

                            lastRequest = testConnectionManager.receivedRequests.lastObject;
                        });

                        it(@"should have called the completion handler with correct data", ^{
                            expect(lastRequest).toNot(beAnInstanceOf([SDLPutFile class]));
                            expect(@(completionSuccess)).to(equal(@NO));
                            expect(@(completionBytesAvailable)).to(equal(@(testFileManager.bytesAvailable)));
                            expect(completionError).to(equal([NSError sdl_fileManager_cannotOverwriteError]));
                        });
                    });
                });

                context(@"when there is not a remote file named the same thing", ^{
                    beforeEach(^{
                        testFileName = @"not a test file";
                        testFileData = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
                        testUploadFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];

                        [testFileManager uploadFile:testUploadFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                            completionSuccess = success;
                            completionBytesAvailable = bytesAvailable;
                            completionError = error;
                        }];

                        [NSThread sleepForTimeInterval:0.1];

                        sentPutFile = (SDLPutFile *)testConnectionManager.receivedRequests.lastObject;
                    });

                    it(@"should not have testFileName in the files set", ^{
                        expect(testInitialFileNames).toNot(contain(testFileName));
                    });

                    context(@"when the connection returns without error", ^{
                        __block SDLPutFileResponse *testResponse = nil;
                        __block NSNumber *testResponseSuccess = nil;
                        __block NSNumber *testResponseBytesAvailable = nil;

                        beforeEach(^{
                            testResponseBytesAvailable = @750;
                            testResponseSuccess = @YES;

                            testResponse = [[SDLPutFileResponse alloc] init];
                            testResponse.success = testResponseSuccess;
                            testResponse.spaceAvailable = testResponseBytesAvailable;

                            [testConnectionManager respondToLastRequestWithResponse:testResponse];
                        });

                        it(@"should set the file manager state correctly", ^{
                            expect(@(testFileManager.bytesAvailable)).toEventually(equal(testResponseBytesAvailable));
                            expect(testFileManager.remoteFileNames).toEventually(contain(testFileName));
                            expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateReady));
                        });

                        it(@"should call the completion handler with the correct data", ^{
                            expect(@(completionBytesAvailable)).toEventually(equal(testResponseBytesAvailable));
                            expect(@(completionSuccess)).toEventually(equal(@YES));
                            expect(completionError).to(beNil());
                        });
                    });

                    context(@"when the connection returns failure", ^{
                        __block SDLPutFileResponse *testResponse = nil;
                        __block NSNumber *testResponseBytesAvailable = nil;
                        __block NSNumber *testResponseSuccess = nil;

                        beforeEach(^{
                            testResponseBytesAvailable = @750;
                            testResponseSuccess = @NO;

                            testResponse = [[SDLPutFileResponse alloc] init];
                            testResponse.spaceAvailable = testResponseBytesAvailable;
                            testResponse.success = testResponseSuccess;

                            testFileManager.accessibilityHint = @"This doesn't matter";

                            [testConnectionManager respondToLastRequestWithResponse:testResponse];
                        });

                        it(@"should set the file manager state correctly", ^{
                            expect(@(testFileManager.bytesAvailable)).toEventually(equal(@(initialSpaceAvailable)));
                            expect(testFileManager.remoteFileNames).toEventuallyNot(contain(testFileName));
                            expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateReady));
                        });

                        it(@"should call the completion handler with the correct data", ^{
                            expect(@(completionBytesAvailable)).to(equal(@0));
                            expect(@(completionSuccess)).to(equal(testResponseSuccess));
                            expect(completionError).toEventually(beNil());
                        });
                    });

                    context(@"when the connection errors without a response", ^{
                        beforeEach(^{
                            [testConnectionManager respondToLastRequestWithResponse:nil error:[NSError sdl_lifecycle_notReadyError]];
                        });

                        it(@"should set the file manager state correctly", ^{
                            expect(testFileManager.remoteFileNames).toNot(contain(testFileName));
                            expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                        });

                        it(@"should call the completion handler with nil error", ^{
                            expect(completionError).toEventually(equal([NSError sdl_lifecycle_notReadyError]));
                        });
                    });
                });
            });
        });

        afterEach(^{
            expect(testFileManager.transactionQueue.maxConcurrentOperationCount).to(equal(@(1)));
        });
    });
});

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
                SDLFile *testSDLFile = [SDLFile fileAtFileURL: [[NSURL alloc] initFileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"testImagePNG" ofType:@"png"]] name:testFileName];
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
                    NSString *testFileName = [NSString stringWithFormat:@"TestMultipleSmallFilesDisk%d", i];
                    SDLFile *testSDLFile = [SDLFile fileAtFileURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"testImagePNG" ofType:@"png"]] name:testFileName];
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
                        testSDLFile = [SDLFile fileAtFileURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"testImagePNG" ofType:@"png"]] name:testFileName];
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
                    expectedError = [NSError sdl_fileManager_unableToUpload_ErrorWithUserInfo:expectedFailedUploads];
                    expectedSpaceLeft = @(testSpaceAvailable);
                });
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
                    [testFileManager uploadFiles:testSDLFiles progressHandler:^BOOL(SDLFileName * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                        TestProgressResponse *testProgressResponse = testFileManagerProgressResponses[fileName];
                        expect(fileName).to(equal(testProgressResponse.testFileName));
                        expect(uploadPercentage).to(equal(testProgressResponse.testUploadPercentage));
                        expect(error).to(testProgressResponse.testError == nil ? beNil() : equal(testProgressResponse.testError));
                        return YES;
                    } completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(beNil());
                        expect(testFileManager.bytesAvailable).to(equal(expectedSpaceLeft));
                        done();
                    }];
                });
            });
        });

        context(@"When an upload is canceled while in progress by the cancel parameter of the progress handler", ^{
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
                expectedError = [NSError sdl_fileManager_unableToUpload_ErrorWithUserInfo:testResponses];
            });

            it(@"should cancel the remaining files if cancel is triggered after half of the files are uploaded", ^{
                testFileCount = 30;
                testCancelIndex = testFileCount / 2;
                testFileNameBase = @"TestUploadFilesCancelInMiddle";
                expectedError = [NSError sdl_fileManager_unableToUpload_ErrorWithUserInfo:testResponses];
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
                    [testFileManager uploadFiles:testSDLFiles progressHandler:^(NSString * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                        // Once operations are canceled, the order in which the operations complete is random, so the upload percentage and the error message can vary. This means we can not test the error message or upload percentage it will be different every test run.
                        TestProgressResponse *testProgressResponse = testProgressResponses[fileName];
                        expect(fileName).to(equal(testProgressResponse.testFileName));

                        NSString *cancelFileName = [NSString stringWithFormat:@"%@%d", testFileNameBase, testCancelIndex];
                        if ([fileName isEqual:cancelFileName]) {
                            return NO;
                        }
                        return YES;
                    } completionHandler:^(NSError * _Nullable error) {
                        if (expectedError != nil) {
                            expect(error.code).to(equal(SDLFileManagerMultipleFileUploadTasksFailed));
                        } else {
                            expect(error).to(beNil());
                        }
                        done();
                    }];
                });
            });
        });

        context(@"When an upload is canceled it should only cancel files that were passed with the same file array", ^{
            // When canceled is called in this test group, the rest of the files should be canceled
            __block NSMutableDictionary *testResponses;
            __block NSMutableDictionary *testProgressResponses;
            __block NSString *testFileNameBase;
            __block int testFileCount = 0;
            __block int testCancelIndex = 0;
            __block NSError *expectedError;

            // Another group of uploads. These uploads should not be canceled when the other files are canceled
            __block NSMutableArray<SDLFile *> *testOtherSDLFiles;
            __block NSString *testOtherFileNameBase;
            __block int testOtherFileCount = 0;
            __block NSError *expectedOtherError;

            beforeEach(^{
                testResponses = [[NSMutableDictionary alloc] init];
                testProgressResponses = [[NSMutableDictionary alloc] init];

                testOtherSDLFiles = [[NSMutableArray alloc] init];
            });

            it(@"should only cancel the remaining files that were passed with the same file. Other files in the queue that were not passed in the same array should not be canceled", ^{
                testFileCount = 11;
                testCancelIndex = 0;
                testFileNameBase = @"TestUploadFilesCancelGroupOnly";
                expectedError = [NSError sdl_fileManager_unableToUpload_ErrorWithUserInfo:testResponses];

                testOtherFileNameBase = @"TestOtherUploadFilesCancelGroupOnly";
                testOtherFileCount = 22;
                expectedOtherError = nil;
            });

            it(@"should not fail if no files are canceled", ^{
                testFileCount = 1;
                testCancelIndex = 0;
                testFileNameBase = @"TestUploadFilesCancelGroupOnlyOneFile";
                expectedError = nil;

                testOtherFileNameBase = @"TestOtherUploadFilesCancelGroupOnlyOneFile";
                testOtherFileCount = 2;
                expectedOtherError = nil;
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

                for(int i = 0; i < testOtherFileCount; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"%@%d", testOtherFileNameBase, i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someOtherTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testOtherSDLFiles addObject:testSDLFile];

                    [expectedSuccessfulFileNames addObject:testFileName];

                    testResponses[testFileName] = [[TestResponse alloc] initWithResponse:successfulResponse error:nil];
                }

                testConnectionManager.responses = testResponses;

                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles progressHandler:^(NSString * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                        // Once operations are canceled, the order in which the operations complete is random, so the upload percentage and the error message can vary. This means we can not test the error message or upload percentage it will be different every test run.
                        TestProgressResponse *testProgressResponse = testProgressResponses[fileName];
                        expect(fileName).to(equal(testProgressResponse.testFileName));

                        NSString *cancelFileName = [NSString stringWithFormat:@"%@%d", testFileNameBase, testCancelIndex];
                        if ([fileName isEqual:cancelFileName]) {
                            return NO;
                        }
                        return YES;
                    } completionHandler:^(NSError * _Nullable error) {
                        if (expectedError != nil) {
                            expect(error.code).to(equal(SDLFileManagerMultipleFileUploadTasksFailed));
                        } else {
                            expect(error).to(beNil());
                        }
                    }];

                    [testFileManager uploadFiles:testOtherSDLFiles completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(beNil());
                        // Since the queue is serial, we know that these files will finish after the first uploadFiles() batch.
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
                    expectedError = [NSError sdl_fileManager_unableToDelete_ErrorWithUserInfo:expectedFailedDeletes];
                    expectedSpaceLeft = @(testSpaceAvailable);
                });
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

    context(@"The file manager should handle exceptions correctly", ^{
        beforeEach(^{
            SDLListFilesResponse *testListFilesResponse = [[SDLListFilesResponse alloc] init];
            testListFilesResponse.success = @YES;
            testListFilesResponse.spaceAvailable = @(initialSpaceAvailable);
            testListFilesResponse.filenames = [[NSArray alloc] initWithObjects:@"AA", nil];

            waitUntilTimeout(10, ^(void (^done)(void)){
                [testFileManager startWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                    done();
                }];
                
                // Need to wait state machine transitions to complete before sending testListFilesResponse
                [NSThread sleepForTimeInterval:0.3];
                
                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];
            });
        });
        
        it(@"should throw an exception when the upload function is passed an empty array", ^{
            expectAction(^{
                [testFileManager uploadFiles:[NSArray array] completionHandler:nil];
            }).to(raiseException().named([NSException sdl_missingFilesException].name));
        });
        
        it(@"should throw an exception when the upload function with a progress handler is passed an empty array", ^{
            expectAction(^{
                [testFileManager uploadFiles:[NSArray array] progressHandler:nil completionHandler:nil];
            }).to(raiseException().named([NSException sdl_missingFilesException].name));
        });
        
        it(@"should throw an exception when the delete function is passed an empty array", ^{
            expectAction(^{
                [testFileManager deleteRemoteFilesWithNames:[NSArray array] completionHandler:nil];
            }).to(raiseException().named([NSException sdl_missingFilesException].name));
        });
    });
});

QuickSpecEnd
