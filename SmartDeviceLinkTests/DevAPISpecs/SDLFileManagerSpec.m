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


typedef NSString SDLFileManagerState;
SDLFileManagerState *const SDLFileManagerStateShutdown = @"Shutdown";
SDLFileManagerState *const SDLFileManagerStateFetchingInitialList = @"FetchingInitialList";
SDLFileManagerState *const SDLFileManagerStateReady = @"Ready";


@interface SDLFileManager ()

@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@end


QuickSpecBegin(SDLFileManagerSpec)

describe(@"Uploading multiple files", ^{
    __block TestMultipleFilesConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block NSUInteger initialSpaceAvailable = 0;

    __block NSMutableArray<NSString *> *testFileNames = nil;
    __block NSMutableArray<SDLFile *> *testSDLFiles = nil;
    __block NSMutableArray<NSData *> *testFileData = nil;

    __block NSUInteger testFileCount = 0;
    __block SDLListFilesResponse *testListFilesResponse = nil;
    __block SDLPutFileResponse *testUploadFileResponse = nil;

    beforeEach(^{
        testConnectionManager = [[TestMultipleFilesConnectionManager alloc] init];
        testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager];
        initialSpaceAvailable = 9666;

        testListFilesResponse = [[SDLListFilesResponse alloc] init];
        testListFilesResponse.success = @YES;
        testListFilesResponse.spaceAvailable = @(initialSpaceAvailable);
        testListFilesResponse.filenames = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", nil];

        testUploadFileResponse = [[SDLPutFileResponse alloc] init];
        testUploadFileResponse.success = @YES;
        testUploadFileResponse.spaceAvailable = @259;
        testConnectionManager.response = testUploadFileResponse;
    });

    context(@"", ^{
        beforeEach(^{
            waitUntil(^(void (^done)(void)){
                [testFileManager startWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                    done();
                }];

                // Need to wait state machine transitions to complete before sending testListFilesResponse
                [NSThread sleepForTimeInterval:0.3];

                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];
            });

            expect(testFileManager.currentState).to(equal(SDLFileManagerStateReady));
        });

        context(@"It should upload multiple files successfully", ^{
            beforeEach(^{
                testFileNames = [NSMutableArray array];
                testFileData = [NSMutableArray array];
                testSDLFiles = [NSMutableArray array];
            });

            it(@"should upload 1 small file from memory", ^{
                testFileCount = 1;

                NSString *fileName = [NSString stringWithFormat:@"Test Small File Memory %d", 0];
                NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                file.overwrite = true;

                [testFileNames addObject: fileName];
                [testFileData addObject:fileData];
                [testSDLFiles addObject:file];
            });

            it(@"should upload 1 large file from disk", ^{
                testFileCount = 1;

                NSString *imageName = @"testImage";
                NSString *imageFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:imageName ofType:@"png"];
                NSURL *imageFileURL = [[NSURL alloc] initFileURLWithPath:imageFilePath];

                NSString *fileName = [NSString stringWithFormat:@"Test Large File Disk %d", 0];
                SDLFile *file = [SDLFile fileAtFileURL:imageFileURL name:fileName];
                file.overwrite = true;

                [testFileNames addObject: fileName];
                [testFileData addObject: [[NSData alloc] initWithContentsOfURL:imageFileURL]];
                [testSDLFiles addObject:file];
            });

            it(@"should upload multiple small files from memory", ^{
                testFileCount = 5;
                for(int i = 0; i < testFileCount; i += 1) {
                    NSString *fileName = [NSString stringWithFormat:@"Test Files %d", i];
                    NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                    SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                    file.overwrite = true;
                    [testFileNames addObject: fileName];
                    [testFileData addObject:fileData];
                    [testSDLFiles addObject:file];
                }
            });

            it(@"should upload a large number of small files from memory", ^{
                testFileCount = 500;
                for(int i = 0; i < testFileCount; i += 1) {
                    NSString *fileName = [NSString stringWithFormat:@"Test Files %d", i];
                    NSData *fileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
                    SDLFile *file = [SDLFile fileWithData:fileData name:fileName fileExtension:@"bin"];
                    file.overwrite = true;
                    [testFileNames addObject: fileName];
                    [testFileData addObject:fileData];
                    [testSDLFiles addObject:file];
                }
            });

            it(@"should upload 5 small files from disk", ^{
                testFileCount = 5;
                NSURL *imageFileURL = nil;

                for(int i = 0; i < testFileCount; i += 1) {
                    NSString *imageName = [NSString stringWithFormat:@"testImage%d", i];
                    NSString *imageFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:imageName ofType:@"png"];
                    imageFileURL = [[NSURL alloc] initFileURLWithPath:imageFilePath];

                    NSString *fileName = [NSString stringWithFormat:@"TestMultipleLargeFilesDisk%d", i];
                    SDLFile *file = [SDLFile fileAtFileURL:imageFileURL name:fileName];

                    file.overwrite = true;
                    [testFileNames addObject: fileName];
                    [testFileData addObject:[[NSData alloc] initWithContentsOfURL:imageFileURL]];
                    [testSDLFiles addObject:file];
                }
            });

            it(@"should upload multiple files from memory and on disk", ^{
                testFileCount = 10;
                for(int i = 0; i < testFileCount; i += 1) {
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
                    [testFileNames addObject: fileName];
                    [testFileData addObject:fileData];
                    [testSDLFiles addObject:testFile];
                }
            });

            afterEach(^{
                waitUntilTimeout(100, ^(void (^done)(void)){
                    [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(beNil());
                        done();
                    }];
                });
            });
        });

        afterEach(^{
            // TODO
        });
    });
});

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
    });
});



QuickSpecEnd
