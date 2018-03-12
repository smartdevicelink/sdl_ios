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
#import "TestFileProgressResponse.h"
#import "TestResponse.h"

typedef NSString SDLFileManagerState;
SDLFileManagerState *const SDLFileManagerStateShutdown = @"Shutdown";
SDLFileManagerState *const SDLFileManagerStateFetchingInitialList = @"FetchingInitialList";
SDLFileManagerState *const SDLFileManagerStateReady = @"Ready";

@interface SDLFileManager ()
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (strong, nonatomic) NSMutableSet<SDLFileName *> *uploadedEphemeralFileNames;
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

                context(@"when there is a remote file with the same file name", ^{
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
                            expect(testFileManager.uploadedEphemeralFileNames).to(beEmpty());
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
                                expect(testFileManager.uploadedEphemeralFileNames).toEventually(contain(testFileName));
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
                                expect(testFileManager.uploadedEphemeralFileNames).to(beEmpty());
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

                    context(@"when allow overwrite is NO", ^{
                        __block NSString *testUploadFileName = nil;
                        __block Boolean testUploadOverwrite = NO;

                        beforeEach(^{
                            testUploadFileName = [testInitialFileNames anyObject];
                        });

                        it(@"should not upload the file if persistance is YES", ^{
                            SDLFile *persistantFile = [[SDLFile alloc] initWithData:testFileData name:testUploadFileName fileExtension:@"bin" persistent:YES];
                            persistantFile.overwrite = testUploadOverwrite;

                            waitUntilTimeout(1, ^(void (^done)(void)){
                                [testFileManager uploadFile:persistantFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                                    expect(testConnectionManager.receivedRequests.lastObject).toNot(beAnInstanceOf([SDLPutFile class]));
                                    expect(@(success)).to(beFalse());
                                    expect(@(bytesAvailable)).to(equal(@(testFileManager.bytesAvailable)));
                                    expect(error).to(equal([NSError sdl_fileManager_cannotOverwriteError]));
                                    done();
                                }];
                            });
                        });

                        it(@"should upload the file if persistance is NO", ^{
                            SDLFile *unPersistantFile = [[SDLFile alloc] initWithData:testFileData name:testUploadFileName fileExtension:@"bin" persistent:NO];
                            unPersistantFile.overwrite = testUploadOverwrite;

                            waitUntilTimeout(1, ^(void (^done)(void)){
                                [testFileManager uploadFile:unPersistantFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                                    expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLPutFile class]));
                                    expect(@(success)).to(beTrue());
                                    expect(@(bytesAvailable)).to(equal(@(testFileManager.bytesAvailable)));
                                    expect(error).to(beNil());
                                    done();
                                }];

                                [NSThread sleepForTimeInterval:0.1];

                                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];
                            });
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
                            expect(testFileManager.uploadedEphemeralFileNames).toEventually(contain(testUploadFile.name));
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
                            expect(testFileManager.uploadedEphemeralFileNames).toEventuallyNot(contain(testUploadFile.name));
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

                context(@"When the file data is nil", ^{
                    it(@"should call the completion handler with an error", ^{
                        SDLFile *emptyFile = [[SDLFile alloc] initWithData:[[NSData alloc] init] name:@"testFile" fileExtension:@"bin" persistent:YES];

                        waitUntilTimeout(1, ^(void (^done)(void)){
                            [testFileManager uploadFile:emptyFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                                expect(testConnectionManager.receivedRequests.lastObject).toNot(beAnInstanceOf([SDLPutFile class]));
                                expect(@(success)).to(beFalse());
                                expect(@(bytesAvailable)).to(equal(@(testFileManager.bytesAvailable)));
                                expect(error).to(equal([NSError sdl_fileManager_dataMissingError]));
                                done();
                            }];
                        });
                    });
                });
            });

            describe(@"uploading artwork", ^{
                __block UIImage *testUIImage = nil;
                __block SDLArtwork *testArtwork = nil;

                __block NSString *expectedArtworkName = nil;
                __block Boolean expectedOverwrite = false;
                __block NSUInteger expectedRemoteFilesCount = 0;
                __block NSUInteger expectedBytesAvailable = 0;

                __block Boolean expectedToUploadArtwork = true;
                __block NSUInteger expectedRPCsSentCount = 1;

                beforeEach(^{
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), YES, 0);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    [[UIColor blackColor] setFill];
                    CGContextFillRect(context, CGRectMake(0, 0, 5, 5));
                    UIImage *blackSquareImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    testUIImage = blackSquareImage;

                    expectedRemoteFilesCount = testInitialFileNames.count;
                    expect(testFileManager.remoteFileNames.count).to(equal(expectedRemoteFilesCount));

                    expectedBytesAvailable = initialSpaceAvailable;
                    expect(testFileManager.bytesAvailable).to(equal(expectedBytesAvailable));

                    expectedRPCsSentCount = 1; // ListFiles RPC
                    expect(testConnectionManager.receivedRequests.count).to(equal(expectedRPCsSentCount));
                });

                it(@"should not upload the artwork again and simply return the artwork name when sending artwork that has already been uploaded", ^{
                    expectedArtworkName = [testListFilesResponse.filenames firstObject];
                    expectedOverwrite = false;
                    expectedRemoteFilesCount = testInitialFileNames.count;
                    expectedBytesAvailable = initialSpaceAvailable;
                    expectedToUploadArtwork = false;
                });

                it(@"should upload the artwork and return the artwork name when done when sending artwork that has not yet been uploaded", ^{
                    expectedArtworkName = @"uniqueArtworkName";
                    expectedOverwrite = false;
                    expectedRemoteFilesCount = testInitialFileNames.count + 1;
                    expectedBytesAvailable = 22;
                    expectedToUploadArtwork = true;
                    expectedRPCsSentCount += 1;
                });

                it(@"should upload the artwork and return the artwork name when done when sending arwork that is already been uploaded but overwrite is enabled", ^{
                    expectedArtworkName = [testListFilesResponse.filenames firstObject];
                    expectedOverwrite = true;
                    expectedRemoteFilesCount = testInitialFileNames.count;
                    expectedBytesAvailable = initialSpaceAvailable;
                    expectedToUploadArtwork = true;
                    expectedRPCsSentCount += 1;
                });

                afterEach(^{
                    testArtwork = [[SDLArtwork alloc] initWithImage:testUIImage name:expectedArtworkName persistent:true asImageFormat:SDLArtworkImageFormatPNG];
                    testArtwork.overwrite = expectedOverwrite;

                    waitUntilTimeout(1, ^(void (^done)(void)){
                        [testFileManager uploadArtwork:testArtwork completionHandler:^(BOOL success, NSString * _Nonnull artworkName, NSUInteger bytesAvailable, NSError * _Nullable error) {
                            expect(artworkName).to(equal(expectedArtworkName));
                            expect(success).to(beTrue());
                            expect(bytesAvailable).to(equal(expectedBytesAvailable));
                            expect(error).to(beNil());

                            expect(testFileManager.remoteFileNames.count).to(equal(expectedRemoteFilesCount));

                            done();
                        }];

                        if (expectedToUploadArtwork) {
                            [NSThread sleepForTimeInterval:0.1];

                            SDLPutFileResponse *successfulPutFileResponse = [[SDLPutFileResponse alloc] init];
                            successfulPutFileResponse.success = @YES;
                            successfulPutFileResponse.spaceAvailable = @(expectedBytesAvailable);
                            [testConnectionManager respondToLastRequestWithResponse:successfulPutFileResponse];
                        }
                    });

                    expect(testConnectionManager.receivedRequests.count).to(equal(expectedRPCsSentCount));
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

            // TODO: This should use itBehavesLike
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

        context(@"and all artworks are uploaded successfully", ^{
            __block NSMutableArray<SDLArtwork *> *testArtworks = nil;
            __block NSMutableDictionary *testConnectionManagerResponses;
            __block NSMutableArray<NSString*> *expectedArtworkNames = nil;

            beforeEach(^{
                testArtworks = [NSMutableArray array];
                testConnectionManagerResponses = [NSMutableDictionary dictionary];
                expectedArtworkNames = [NSMutableArray array];
            });

            it(@"should upload one artwork successfully", ^{
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), YES, 0);
                CGContextRef context = UIGraphicsGetCurrentContext();
                [[UIColor blackColor] setFill];
                CGContextFillRect(context, CGRectMake(0, 0, 5, 5));
                UIImage *blackSquareImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();

                SDLArtwork *testArtwork = [SDLArtwork artworkWithImage:blackSquareImage asImageFormat:SDLArtworkImageFormatPNG];
                [testArtworks addObject:testArtwork];
                [expectedArtworkNames addObject:testArtwork.name];

                successfulResponse.spaceAvailable = @22;
                testConnectionManagerResponses[testArtwork.name] = [[TestResponse alloc] initWithResponse:successfulResponse error:nil];
                expectedSpaceLeft = @22;
                testConnectionManager.responses = testConnectionManagerResponses;
            });

            it(@"should upload multiple artworks successfully", ^{
                NSInteger spaceAvailable = 6000;
                for (NSUInteger i = 0; i < 200; i += 1) {
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), YES, 0);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    CGFloat grey = (i % 255) / 255.0;
                    [[UIColor colorWithRed:grey green:grey blue:grey alpha:1.0] setFill];
                    CGContextFillRect(context, CGRectMake(0, 0, 10, 10));
                    UIImage *greySquareImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();

                    SDLArtwork *testArtwork = [SDLArtwork artworkWithImage:greySquareImage asImageFormat:SDLArtworkImageFormatPNG];
                    [testArtworks addObject:testArtwork];
                    [expectedArtworkNames addObject:testArtwork.name];

                    successfulResponse.spaceAvailable = @(spaceAvailable -= 1);
                    [expectedSuccessfulFileNames addObject:testArtwork.name];
                    testConnectionManagerResponses[testArtwork.name] = [[TestResponse alloc] initWithResponse:successfulResponse error:nil];
                }
                expectedSpaceLeft = @(spaceAvailable);
                testConnectionManager.responses = testConnectionManagerResponses;
            });

            afterEach(^{
                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadArtworks:testArtworks completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                        for (NSString *artworkName in expectedArtworkNames) {
                            expect(artworkNames).to(contain(artworkName));
                        }
                        expect(expectedArtworkNames.count).to(equal(artworkNames.count));
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
                describe(@"The correct errors should be returned", ^{
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

                            testConnectionManagerResponses[testFileName] = [[TestResponse alloc] initWithResponse:response error:responseError];
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

            context(@"When the file manager receives a notification from the remote that an artwork upload failed", ^{
                __block NSMutableArray<SDLArtwork *> *testArtworks = nil;
                __block NSSet<NSNumber *> *testOverwriteErrorIndices = nil;
                __block NSMutableArray<NSString *> *expectedSuccessfulArtworkNames = nil;
                __block NSInteger expectedSuccessfulArtworkNameCount = 0;
                __block NSInteger expectedErrorMessagesCount = 0;

                beforeEach(^{
                    testArtworks = [NSMutableArray array];
                    testOverwriteErrorIndices = [NSSet set];
                    expectedSuccessfulArtworkNameCount = 0;
                    expectedSuccessfulArtworkNames = [NSMutableArray array];
                    expectedErrorMessagesCount = 0;

                    testFailureIndexStart = -1;
                    testFailureIndexEnd = INT8_MAX;
                });

                describe(@"The correct errors should be returned", ^{
                    it(@"should return an empty artwork name array if all artwork uploads failed", ^{
                        testTotalFileCount = 20;
                        testFailureIndexStart = testTotalFileCount;
                        expectedSuccessfulArtworkNameCount = 0;
                        expectedErrorMessagesCount = 20;
                    });

                    it(@"should not include the failed upload in the artwork names", ^{
                        testTotalFileCount = 5;
                        testFailureIndexStart = 1;
                        testFailureIndexEnd = 3;
                        expectedSuccessfulArtworkNameCount = 1;
                        expectedErrorMessagesCount = 4;
                    });

                    it(@"should not return any errors that are overwrite errors", ^{
                        testTotalFileCount = 12;
                        testFailureIndexEnd = 5;
                        testOverwriteErrorIndices = [[NSSet alloc] initWithArray:@[@6, @7]];
                        expectedSuccessfulArtworkNameCount = 7;
                        expectedErrorMessagesCount = 5;
                    });

                    it(@"should not return an error if all the errors are overwrite errors", ^{
                        testTotalFileCount = 10;
                        testFailureIndexEnd = 5;
                        testOverwriteErrorIndices = [[NSSet alloc] initWithArray:@[@5, @6, @7, @8, @9]];
                        expectedSuccessfulArtworkNameCount = 10;
                        expectedErrorMessagesCount = 0;
                    });

                    afterEach(^{
                        NSInteger testSpaceAvailable = initialSpaceAvailable;
                        for(int i = 0; i < testTotalFileCount; i += 1) {
                            UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), YES, 0);
                            CGContextRef context = UIGraphicsGetCurrentContext();
                            CGFloat grey = (i % 255) / 255.0;
                            [[UIColor colorWithRed:grey green:grey blue:grey alpha:1.0] setFill];
                            CGContextFillRect(context, CGRectMake(0, 0, i + 1, i + 1));
                            UIImage *greySquareImage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();

                            SDLArtwork *testArtwork = [SDLArtwork artworkWithImage:greySquareImage asImageFormat:SDLArtworkImageFormatPNG];
                            [testArtworks addObject:testArtwork];

                            SDLPutFileResponse *response = [[SDLPutFileResponse alloc] init];
                            NSError *responseError = nil;
                            if (i <= testFailureIndexStart || i >= testFailureIndexEnd) {
                                // Failed response
                                response = failedResponse;
                                response.spaceAvailable = @(testSpaceAvailable);
                                if ([testOverwriteErrorIndices containsObject:@(i)]) {
                                    // Overwrite error
                                    responseError = [NSError sdl_fileManager_cannotOverwriteError];
                                    [expectedSuccessfulArtworkNames addObject:testArtwork.name];
                                } else {
                                    responseError = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:[NSString stringWithFormat:@"file upload failed: %d", i] andReason:[NSString stringWithFormat:@"some error reason: %d", i]];
                                    expectedFailedUploads[testArtwork.name] = responseError;
                                }
                            } else {
                                // Successful response
                                response = successfulResponse;
                                response.spaceAvailable = @(testSpaceAvailable -= 1);
                                responseError = nil;
                                [expectedSuccessfulFileNames addObject:testArtwork.name];
                                [expectedSuccessfulArtworkNames addObject:testArtwork.name];
                            }
                            testConnectionManagerResponses[testArtwork.name] = [[TestResponse alloc] initWithResponse:response error:responseError];
                        }

                        testConnectionManager.responses = testConnectionManagerResponses;
                        expectedError = expectedFailedUploads.count == 0 ? nil : [NSError sdl_fileManager_unableToUpload_ErrorWithUserInfo:expectedFailedUploads];
                        expectedSpaceLeft = @(testSpaceAvailable);
                    });
                });

                afterEach(^{
                    expect(testFileManager.remoteFileNames.count).to(equal(testListFilesResponse.filenames.count));

                    waitUntilTimeout(1, ^(void (^done)(void)){
                        [testFileManager uploadArtworks:testArtworks completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                            expect(artworkNames.count).to(equal(expectedSuccessfulArtworkNameCount));
                            if (expectedSuccessfulArtworkNames == nil) {
                                expect(artworkNames).to(beNil());
                            } else {
                                for (NSString *artworkName in expectedSuccessfulArtworkNames) {
                                    expect(artworkNames).to(contain(artworkName));
                                }
                            }

                            if (expectedError == nil) {
                                expect(error).to(beNil());
                            } else {
                                for (NSString *artworkName in expectedError.userInfo) {
                                    expect([error.userInfo objectForKey:artworkName]).toNot(beNil());
                                }
                            }

                            expect(error.userInfo.count).to(equal(expectedErrorMessagesCount));
                            expect(testFileManager.bytesAvailable).to(equal(expectedSpaceLeft));
                            done();
                        }];
                    });
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

            describe(@"When uploading files", ^{
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
                        testFileManagerProgressResponses[testFileName] = [[TestFileProgressResponse alloc] initWithFileName:testFileName testUploadPercentage:testTotalBytesUploaded / testTotalBytesToUpload error:nil];
                    }
                    expectedSpaceLeft = @(testSpaceAvailable);
                    testConnectionManager.responses = testFileManagerResponses;
                });
            });

            afterEach(^{
                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles progressHandler:^BOOL(SDLFileName * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                        TestFileProgressResponse *testProgressResponse = testFileManagerProgressResponses[fileName];
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

            describe(@"When uploading artworks", ^{
                __block NSMutableArray<SDLArtwork *> *testArtworks = nil;
                __block NSMutableDictionary *testConnectionManagerResponses;
                __block NSMutableArray<NSString*> *expectedArtworkNames = nil;

                beforeEach(^{
                    testArtworks = [NSMutableArray array];
                    testConnectionManagerResponses = [NSMutableDictionary dictionary];
                    expectedArtworkNames = [NSMutableArray array];
                    testTotalFileCount = 0;
                });

                context(@"A progress handler should be returned for each artwork", ^{
                    it(@"should upload 1 artwork without error", ^{
                        testTotalFileCount = 1;
                    });

                    it(@"should upload multiple artworks without error", ^{
                        testTotalFileCount = 100;
                    });

                    afterEach(^{
                        NSInteger spaceAvailable = initialSpaceAvailable;
                        float testTotalBytesToUpload = 0; // testTotalFileCount * testFileData.length;
                        for (NSUInteger i = 0; i < testTotalFileCount; i += 1) {
                            UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), YES, 0);
                            CGContextRef context = UIGraphicsGetCurrentContext();
                            CGFloat grey = (i % 255) / 255.0;
                            [[UIColor colorWithRed:grey green:grey blue:grey alpha:1.0] setFill];
                            CGContextFillRect(context, CGRectMake(0, 0, 10, 10));
                            UIImage *greySquareImage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();

                            SDLArtwork *testArtwork = [SDLArtwork artworkWithImage:greySquareImage asImageFormat:SDLArtworkImageFormatPNG];
                            [testArtworks addObject:testArtwork];
                            [expectedArtworkNames addObject:testArtwork.name];
                            testTotalBytesToUpload += testArtwork.fileSize;

                            successfulResponse.spaceAvailable = @(spaceAvailable -= 1);
                            [expectedSuccessfulFileNames addObject:testArtwork.name];
                            testFileManagerResponses[testArtwork.name] = [[TestResponse alloc] initWithResponse:successfulResponse error:nil];

                            testFileManagerProgressResponses[testArtwork.name] = [[TestFileProgressResponse alloc] initWithFileName:testArtwork.name testUploadPercentage:0 error:nil];
                        }

                        float testTotalBytesUploaded = 0.0;
                        for (SDLArtwork *artwork in testArtworks) {
                            testTotalBytesUploaded += artwork.fileSize;
                            TestFileProgressResponse *response = testFileManagerProgressResponses[artwork.name];
                            response.testUploadPercentage = testTotalBytesUploaded / testTotalBytesToUpload;
                        }

                        expectedSpaceLeft = @(spaceAvailable);
                        testConnectionManager.responses = testFileManagerResponses;
                    });
                });

                afterEach(^{
                    waitUntilTimeout(10, ^(void (^done)(void)){
                        [testFileManager uploadArtworks:testArtworks progressHandler:^BOOL(NSString * _Nonnull artworkName, float uploadPercentage, NSError * _Nullable error) {
                            TestFileProgressResponse *testProgressResponse = testFileManagerProgressResponses[artworkName];
                            expect(artworkName).to(equal(testProgressResponse.testFileName));
                            expect(uploadPercentage).to(equal(testProgressResponse.testUploadPercentage));
                            expect(error).to(testProgressResponse.testError == nil ? beNil() : equal(testProgressResponse.testError));
                            return YES;
                        } completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                            expect(error).to(beNil());
                            expect(testFileManager.bytesAvailable).to(equal(expectedSpaceLeft));
                            done();
                        }];
                    });
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
                    testProgressResponses[testFileName] = [[TestFileProgressResponse alloc] initWithFileName:testFileName testUploadPercentage:0.0 error:nil];
                }
                testConnectionManager.responses = testResponses;

                waitUntilTimeout(10, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles progressHandler:^(NSString * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                        // Once operations are canceled, the order in which the operations complete is random, so the upload percentage and the error message can vary. This means we can not test the error message or upload percentage it will be different every test run.
                        TestFileProgressResponse *testProgressResponse = testProgressResponses[fileName];
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
                    testProgressResponses[testFileName] = [[TestFileProgressResponse alloc] initWithFileName:testFileName testUploadPercentage:0.0 error:nil];
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
                        TestFileProgressResponse *testProgressResponse = testProgressResponses[fileName];
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

        it(@"should throw an exception when the artwork upload function is passed an empty array", ^{
            expectAction(^{
                [testFileManager uploadArtworks:[NSArray array] completionHandler:nil];
            }).to(raiseException().named([NSException sdl_missingFilesException].name));
        });

        it(@"should throw an exception when the artwork upload function with a progress handler is passed an empty array", ^{
            expectAction(^{
                [testFileManager uploadArtworks:[NSArray array] progressHandler:nil completionHandler:nil];
            }).to(raiseException().named([NSException sdl_missingFilesException].name));
        });
    });
});

QuickSpecEnd
