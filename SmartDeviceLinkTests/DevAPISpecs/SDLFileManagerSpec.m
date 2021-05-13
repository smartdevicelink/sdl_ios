#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLDeleteFileResponse.h"
#import "SDLDeleteFileOperation.h"
#import "SDLError.h"
#import "SDLFile.h"
#import "SDLFileManager.h"
#import "SDLFileManagerConfiguration.h"
#import "SDLFileType.h"
#import "SDLFileWrapper.h"
#import "SDLGlobals.h"
#import "SDLListFiles.h"
#import "SDLListFilesOperation.h"
#import "SDLListFilesResponse.h"
#import "SDLNotificationConstants.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLRPCResponse.h"
#import "SDLStateMachine.h"
#import "SDLUploadFileOperation.h"
#import "TestConnectionManager.h"
#import "TestMultipleFilesConnectionManager.h"
#import "TestFileProgressResponse.h"
#import "TestResponse.h"

typedef NSString SDLFileManagerState;
SDLFileManagerState *const SDLFileManagerStateShutdown = @"Shutdown";
SDLFileManagerState *const SDLFileManagerStateFetchingInitialList = @"FetchingInitialList";
SDLFileManagerState *const SDLFileManagerStateReady = @"Ready";
SDLFileManagerState *const SDLFileManagerStateStartupError = @"StartupError";

@interface SDLFileManager ()

@property (strong, nonatomic) NSMutableSet<SDLFileName *> *mutableRemoteFileNames;
@property (assign, nonatomic, readwrite) NSUInteger bytesAvailable;

@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (strong, nonatomic) NSMutableSet<SDLFileName *> *uploadedEphemeralFileNames;
@property (strong, nonatomic) NSMutableDictionary<SDLFileName *, NSNumber<SDLUInt> *> *failedFileUploadsCount;
@property (assign, nonatomic) UInt8 maxFileUploadAttempts;
@property (assign, nonatomic) UInt8 maxArtworkUploadAttempts;
@property (strong, nonatomic) SDLStateMachine *stateMachine;

// List files helper
- (void)sdl_listRemoteFilesWithCompletionHandler:(SDLFileManagerListFilesCompletionHandler)handler;

- (BOOL)sdl_canFileBeUploadedAgain:(nullable SDLFile *)file maxUploadCount:(int)maxRetryCount failedFileUploadsCount:(NSMutableDictionary<SDLFileName *, NSNumber<SDLUInt> *> *)failedFileUploadsCount;
+ (NSMutableDictionary<SDLFileName *, NSNumber<SDLUInt> *> *)sdl_incrementFailedUploadCountForFileName:(SDLFileName *)fileName failedFileUploadsCount:(NSMutableDictionary<SDLFileName *, NSNumber<SDLUInt> *> *)failedFileUploadsCount;
- (BOOL)hasUploadedFile:(SDLFile *)file;

@end

@interface FileManagerSpecHelper : NSObject

@end

@implementation FileManagerSpecHelper

+ (NSArray<UIImage *> *)imagesForCount:(NSUInteger)count {
    NSMutableArray<UIImage *> *images = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat grey = (i % 255) / 255.0;
        [[UIColor colorWithRed:grey green:grey blue:grey alpha:1.0] setFill];
        CGContextFillRect(context, CGRectMake(0, 0, i + 1, i + 1));
        UIImage *graySquareImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [images addObject:graySquareImage];
    }

    return [images copy];
}

@end

QuickSpecBegin(SDLFileManagerSpec)

describe(@"uploading / deleting single files with the file manager", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block SDLFileManagerConfiguration *testFileManagerConfiguration = nil;
    NSUInteger initialSpaceAvailable = 250;
    NSUInteger failureSpaceAvailabe = 2000000000;
    NSUInteger newBytesAvailable = 750;
    NSArray<NSString *> *testInitialFileNames = @[@"testFile1", @"testFile2", @"testFile3"];
    NSArray<NSString *> *testInitialFileNames2 = @[@"testFile1", @"testFile2", @"testFile3", @"testFile4"];

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManagerConfiguration = [[SDLFileManagerConfiguration alloc] initWithArtworkRetryCount:0 fileRetryCount:0];
        testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager configuration:testFileManagerConfiguration];
        testFileManager.suspended = YES;
        testFileManager.bytesAvailable = initialSpaceAvailable;
    });

    afterEach(^{
        [testFileManager stop];
    });

    describe(@"before starting", ^{
        it(@"should be in the shutdown state", ^{
            expect(testFileManager.currentState).to(match(SDLFileManagerStateShutdown));
            expect(testFileManager.bytesAvailable).to(equal(initialSpaceAvailable));
            expect(testFileManager.remoteFileNames).to(beEmpty());
            expect(testFileManager.pendingTransactions).to(beEmpty());
            expect(testFileManager.maxFileUploadAttempts).to(equal(1));
            expect(testFileManager.maxArtworkUploadAttempts).to(equal(1));
        });
    });

    describe(@"after receiving a start message", ^{
        __block BOOL startupSuccess = NO;
        __block NSError *startupError = nil;
        __block BOOL completionHandlerCalled = NO;

        beforeEach(^{
            completionHandlerCalled = NO;
            [testFileManager startWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                startupSuccess = success;
                startupError = error;
                completionHandlerCalled = YES;
            }];
        });

        it(@"should have queued a ListFiles request", ^{
            expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateFetchingInitialList));
            expect(testFileManager.pendingTransactions).toEventually(haveCount(@1));
            expect(testFileManager.pendingTransactions.firstObject).toEventually(beAnInstanceOf([SDLListFilesOperation class]));
        });

        describe(@"after going to the shutdown state and receiving a ListFiles response", ^{
            beforeEach(^{
                [testFileManager stop];
                SDLListFilesOperation *operation = testFileManager.pendingTransactions.firstObject;
                operation.completionHandler(YES, initialSpaceAvailable, testInitialFileNames, nil);
            });

            it(@"should remain in the stopped state after receiving the response if disconnected", ^{
                expect(testFileManager.currentState).to(match(SDLFileManagerStateShutdown));
                expect(completionHandlerCalled).to(beTrue());
            });
        });

        describe(@"getting an error for a ListFiles request", ^{
            __block SDLListFilesOperation *operation = nil;

            beforeEach(^{
                operation = testFileManager.pendingTransactions.firstObject;
            });

            it(@"should handle a ListFiles error with a resultCode of DISALLOWED and transition to the ready state", ^{
                operation.completionHandler(NO, initialSpaceAvailable, testInitialFileNames, [NSError errorWithDomain:[NSError sdl_fileManager_unableToStartError].domain code:[NSError sdl_fileManager_unableToStartError].code userInfo:@{@"resultCode" : SDLResultDisallowed}]);

                expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                expect(testFileManager.remoteFileNames).to(beEmpty());
                expect(@(testFileManager.bytesAvailable)).to(equal(initialSpaceAvailable));
            });

            it(@"should handle a ListFiles error with a resultCode ENCRYPTION_NEEDED and transition to the ready state", ^{
                operation.completionHandler(NO, initialSpaceAvailable, testInitialFileNames, [NSError errorWithDomain:[NSError sdl_fileManager_unableToStartError].domain code:[NSError sdl_fileManager_unableToStartError].code userInfo:@{@"resultCode" : SDLResultEncryptionNeeded}]);

                expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                expect(testFileManager.remoteFileNames).to(beEmpty());
                expect(@(testFileManager.bytesAvailable)).to(equal(initialSpaceAvailable));
            });

            it(@"should transition to the error state if it gets a ListFiles error with a resultCode that is not handled by the library", ^{
                operation.completionHandler(NO, initialSpaceAvailable, testInitialFileNames, [NSError errorWithDomain:[NSError sdl_fileManager_unableToStartError].domain code:[NSError sdl_fileManager_unableToStartError].code userInfo:@{@"resultCode" : SDLResultUnsupportedRequest}]);

                expect(testFileManager.currentState).to(match(SDLFileManagerStateStartupError));
                expect(testFileManager.remoteFileNames).to(beEmpty());
                expect(@(testFileManager.bytesAvailable)).to(equal(initialSpaceAvailable));
            });

            it(@"should transition to the error state if it gets a ListFiles error without a resultCode", ^{
                operation.completionHandler(NO, initialSpaceAvailable, testInitialFileNames, [NSError sdl_fileManager_unableToStartError]);

                expect(testFileManager.currentState).to(match(SDLFileManagerStateStartupError));
                expect(testFileManager.remoteFileNames).to(beEmpty());
                expect(@(testFileManager.bytesAvailable)).to(equal(initialSpaceAvailable));
            });
        });

        describe(@"after receiving a ListFiles response", ^{
            beforeEach(^{
                SDLListFilesOperation *operation = testFileManager.pendingTransactions.firstObject;
                operation.completionHandler(YES, initialSpaceAvailable, testInitialFileNames, nil);
            });

            it(@"the file manager should be in the correct state", ^{
                expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                expect(testFileManager.remoteFileNames).to(equal([NSSet setWithArray:testInitialFileNames]));
                expect(@(testFileManager.bytesAvailable)).to(equal(@(initialSpaceAvailable)));
            });
        });
    });

    describe(@"deleting a file", ^{
        __block BOOL completionSuccess = NO;
        __block NSUInteger completionBytesAvailable = 0;
        __block NSError *completionError = nil;

        beforeEach(^{
            testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames];
            [testFileManager.stateMachine setToState:SDLFileManagerStateReady fromOldState:SDLFileManagerStateShutdown callEnterTransition:NO];
        });

        context(@"when the file is unknown", ^{
            beforeEach(^{
                NSString *someUnknownFileName = @"Some Unknown File Name";
                [testFileManager deleteRemoteFileWithName:someUnknownFileName completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                    completionSuccess = success;
                    completionBytesAvailable = bytesAvailable;
                    completionError = error;
                }];

                expect(testFileManager.pendingTransactions).to(beEmpty());
            });

            it(@"should return the correct data", ^{
                expect(completionSuccess).to(beFalse());
                expect(completionBytesAvailable).to(equal(initialSpaceAvailable));
                expect(completionError).to(equal([NSError sdl_fileManager_noKnownFileError]));
                expect(testFileManager.remoteFileNames).to(haveCount(testInitialFileNames.count));
            });
        });

        context(@"when the file is known", ^{
            __block NSUInteger newSpaceAvailable = 600;
            __block NSString *someKnownFileName = nil;
            __block BOOL completionSuccess = NO;
            __block NSUInteger completionBytesAvailable = 0;
            __block NSError *completionError = nil;

            beforeEach(^{
                someKnownFileName = [testInitialFileNames lastObject];
                [testFileManager deleteRemoteFileWithName:someKnownFileName completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                    completionSuccess = success;
                    completionBytesAvailable = bytesAvailable;
                    completionError = error;
                }];

                SDLDeleteFileOperation *operation = testFileManager.pendingTransactions.firstObject;
                operation.completionHandler(YES, newSpaceAvailable, nil);
            });

            it(@"should return the correct data", ^{
                expect(@(completionSuccess)).to(equal(@YES));
                expect(@(completionBytesAvailable)).to(equal(@(newSpaceAvailable)));
                expect(@(testFileManager.bytesAvailable)).to(equal(@(newSpaceAvailable)));
                expect(completionError).to(beNil());
                expect(testFileManager.remoteFileNames).toNot(contain(someKnownFileName));
            });
        });
    });

    describe(@"check hasUploadedFile response", ^{
        __block SDLFile *testFile = nil;

        context(@"on RPC version >= 4.4.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:7 minor:1 patch:0];
                [testFileManager.stateMachine setToState:SDLFileManagerStateReady fromOldState:SDLFileManagerStateShutdown callEnterTransition:NO];

                NSData *testFileData = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
                testFile = [SDLFile persistentFileWithData:testFileData name:@"testFile4" fileExtension:@"png"];
            });

            context(@"when the file is in remoteFileNames", ^{
                beforeEach(^{
                    testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames2];
                });

                it(@"should return NO", ^{
                    expect([testFileManager hasUploadedFile:testFile]).to(equal(YES));
                });
            });

            context(@"when the file is not in remoteFileNames", ^{
                beforeEach(^{
                    testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames];
                });

                it(@"should return NO", ^{
                    expect([testFileManager hasUploadedFile:testFile]).to(equal(NO));
                });
            });
        });

        context(@"on RPC version < 4.4.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:4 minor:3 patch:0];
                [testFileManager.stateMachine setToState:SDLFileManagerStateReady fromOldState:SDLFileManagerStateShutdown callEnterTransition:NO];
            });

            context(@"when the file is persistent", ^{
                beforeEach(^{
                    NSData *testFileData = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
                    testFile = [SDLFile persistentFileWithData:testFileData name:@"testFile4" fileExtension:@"png"];
                });

                it(@"should return NO", ^{
                    expect([testFileManager hasUploadedFile:testFile]).to(equal(NO));
                });

                context(@"when the file is in remoteFileNames", ^{
                    beforeEach(^{
                        testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames2];
                    });

                    it(@"should return YES", ^{
                        expect([testFileManager hasUploadedFile:testFile]).to(equal(YES));
                    });

                    context(@"when the file is in uploadedEphemeralFiles", ^{
                        beforeEach(^{
                            testFileManager.uploadedEphemeralFileNames = [NSMutableSet setWithArray:testInitialFileNames];

                        });

                        it(@"should return YES", ^{
                            expect([testFileManager hasUploadedFile:testFile]).to(equal(YES));
                        });
                    });
                });

                context(@"when the file is not in remoteFileNames", ^{
                    beforeEach(^{
                        testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames];
                    });

                    it(@"should return NO", ^{
                        expect([testFileManager hasUploadedFile:testFile]).to(equal(NO));
                    });
                });
            });

            context(@"when the file is not persistent", ^{
                beforeEach(^{
                    NSData *testFileData = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
                    testFile = [SDLFile fileWithData:testFileData name:@"testFile4" fileExtension:@"png"];
                });

                it(@"should return NO", ^{
                    expect([testFileManager hasUploadedFile:testFile]).to(equal(NO));
                });

                context(@"when the file is in remoteFileNames", ^{
                    beforeEach(^{
                        testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames2];
                    });

                    it(@"should return NO", ^{
                        expect([testFileManager hasUploadedFile:testFile]).to(equal(NO));
                    });

                    context(@"when the file is in uploadedEphemeralFiles", ^{
                        beforeEach(^{
                            testFileManager.uploadedEphemeralFileNames = [NSMutableSet setWithArray:testInitialFileNames2];

                        });

                        it(@"should return YES", ^{
                            expect([testFileManager hasUploadedFile:testFile]).to(equal(YES));
                        });
                    });

                    context(@"when the file is not in uploadedEphemeralFiles", ^{
                        beforeEach(^{
                            testFileManager.uploadedEphemeralFileNames = [NSMutableSet setWithArray:testInitialFileNames];

                        });

                        it(@"should return NO", ^{
                            expect([testFileManager hasUploadedFile:testFile]).to(equal(NO));
                        });
                    });
                });

                context(@"when the file is not in remoteFileNames", ^{
                    beforeEach(^{
                        testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames];
                    });

                    it(@"should return NO", ^{
                        expect([testFileManager hasUploadedFile:testFile]).to(equal(NO));
                    });
                });
            });
        });
    });

    describe(@"uploading a new file", ^{
        __block NSString *testFileName = nil;
        __block SDLFile *testUploadFile = nil;
        __block BOOL completionSuccess = NO;
        __block NSUInteger completionBytesAvailable = 0;
        __block NSError *completionError = nil;

        __block NSData *testFileData = nil;

        beforeEach(^{
            testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames];
            [testFileManager.stateMachine setToState:SDLFileManagerStateReady fromOldState:SDLFileManagerStateShutdown callEnterTransition:NO];
        });

        context(@"when there is a remote file with the same file name", ^{
            beforeEach(^{
                testFileName = [testInitialFileNames lastObject];
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
                });

                context(@"when the connection returns a success", ^{
                    beforeEach(^{
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                        sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                    });

                    it(@"should set the file manager state to be waiting and set correct data", ^{
                        expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                        expect(testFileManager.uploadedEphemeralFileNames).toNot(beEmpty());

                        expect(completionBytesAvailable).to(equal(newBytesAvailable));
                        expect(completionSuccess).to(equal(YES));
                        expect(completionError).to(beNil());

                        expect(@(testFileManager.bytesAvailable)).to(equal(newBytesAvailable));
                        expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                        expect(testFileManager.remoteFileNames).to(contain(testFileName));
                        expect(testFileManager.uploadedEphemeralFileNames).to(contain(testFileName));
                    });
                });

                context(@"when the connection returns failure", ^{
                    beforeEach(^{
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                        sentOperation.fileWrapper.completionHandler(NO, failureSpaceAvailabe, [NSError sdl_fileManager_fileUploadCanceled]);
                    });

                    it(@"should set the file manager data correctly", ^{
                        expect(testFileManager.bytesAvailable).to(equal(initialSpaceAvailable));
                        expect(testFileManager.remoteFileNames).to(contain(testFileName));
                        expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                        expect(testFileManager.uploadedEphemeralFileNames).to(beEmpty());

                        expect(completionBytesAvailable).to(equal(failureSpaceAvailabe));
                        expect(completionSuccess).to(equal(@NO));
                        expect(completionError).toNot(beNil());

                        expect(testFileManager.failedFileUploadsCount[testFileName]).to(equal(1));
                    });
                });
            });

            context(@"when allow overwrite is NO and the RPC version is < 4.4.0", ^{
                __block NSString *testUploadFileName = nil;
                __block Boolean testUploadOverwrite = NO;

                beforeEach(^{
                    testUploadFileName = [testInitialFileNames lastObject];
                    [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:4 minor:3 patch:0];
                });

                it(@"should not upload the file if persistence is YES", ^{
                    SDLFile *persistentFile = [[SDLFile alloc] initWithData:testFileData name:testUploadFileName fileExtension:@"bin" persistent:YES];
                    persistentFile.overwrite = testUploadOverwrite;

                    [testFileManager uploadFile:persistentFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                        expect(@(success)).to(beFalse());
                        expect(@(bytesAvailable)).to(equal(@(testFileManager.bytesAvailable)));
                        expect(error).to(equal([NSError sdl_fileManager_cannotOverwriteError]));
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(0));
                });

                it(@"should upload the file if persistence is NO", ^{
                    SDLFile *unPersistentFile = [[SDLFile alloc] initWithData:testFileData name:testUploadFileName fileExtension:@"bin" persistent:NO];
                    unPersistentFile.overwrite = testUploadOverwrite;

                    [testFileManager uploadFile:unPersistentFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                        expect(success).to(beTrue());
                        expect(bytesAvailable).to(equal(newBytesAvailable));
                        expect(error).to(beNil());
                    }];

                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                    expect(testFileManager.pendingTransactions.count).to(equal(1));
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
            });

            it(@"should not have testFileName in the files set", ^{
                expect(testInitialFileNames).toNot(contain(testFileName));
            });

            context(@"when the connection returns without error", ^{\
                beforeEach(^{
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                });

                it(@"should set the file manager state correctly", ^{
                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                    expect(testFileManager.remoteFileNames).to(contain(testFileName));
                    expect(testFileManager.uploadedEphemeralFileNames).to(contain(testUploadFile.name));
                    expect(testFileManager.currentState).to(equal(SDLFileManagerStateReady));

                    expect(@(completionBytesAvailable)).to(equal(newBytesAvailable));
                    expect(@(completionSuccess)).to(equal(@YES));
                    expect(completionError).to(beNil());
                });
            });

            context(@"when the connection returns failure", ^{
                beforeEach(^{
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                    sentOperation.fileWrapper.completionHandler(NO, failureSpaceAvailabe, [NSError sdl_fileManager_fileUploadCanceled]);
                });

                it(@"should set the file manager state correctly", ^{
                    expect(testFileManager.bytesAvailable).toEventually(equal(initialSpaceAvailable));
                    expect(testFileManager.remoteFileNames).toEventuallyNot(contain(testFileName));
                    expect(testFileManager.uploadedEphemeralFileNames).toEventuallyNot(contain(testUploadFile.name));
                    expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateReady));

                    expect(completionBytesAvailable).to(equal(failureSpaceAvailabe));
                    expect(completionSuccess).to(beFalse());
                    expect(completionError).toEventuallyNot(beNil());
                });
            });
        });
    });

    describe(@"uploading artwork", ^{
        __block UIImage *testUIImage = nil;
        __block NSString *expectedArtworkName = nil;

        beforeEach(^{
            testUIImage = [FileManagerSpecHelper imagesForCount:1].firstObject;

            testFileManager.uploadedEphemeralFileNames = [NSMutableSet setWithArray:testInitialFileNames];
            testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames];
            [testFileManager.stateMachine setToState:SDLFileManagerStateReady fromOldState:SDLFileManagerStateShutdown callEnterTransition:NO];
        });

        it(@"should not upload the artwork again and simply return the artwork name when sending artwork that has already been uploaded", ^{
            expectedArtworkName = testInitialFileNames.firstObject;

            SDLArtwork *art = [SDLArtwork artworkWithImage:testUIImage name:expectedArtworkName asImageFormat:SDLArtworkImageFormatPNG];
            [testFileManager uploadArtwork:art completionHandler:^(BOOL success, NSString * _Nonnull artworkName, NSUInteger bytesAvailable, NSError * _Nullable error) {
                expect(success).to(beTrue());
                expect(bytesAvailable).to(equal(initialSpaceAvailable));
                expect(error).to(beNil());
            }];

            expect(testFileManager.pendingTransactions.count).to(equal(0));
        });

        it(@"should upload the artwork and return the artwork name when done when sending artwork that has not yet been uploaded", ^{
            expectedArtworkName = @"uniqueArtworkName";
            [testFileManager uploadArtwork:[SDLArtwork artworkWithImage:testUIImage name:expectedArtworkName asImageFormat:SDLArtworkImageFormatPNG] completionHandler:^(BOOL success, NSString * _Nonnull artworkName, NSUInteger bytesAvailable, NSError * _Nullable error) {
                expect(success).to(beTrue());
                expect(bytesAvailable).to(equal(newBytesAvailable));
                expect(error).to(beNil());
            }];

            SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
            sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
            expect(testFileManager.pendingTransactions.count).to(equal(1));
        });

        it(@"should upload the artwork and return the artwork name when done when sending arwork that is already been uploaded but overwrite is enabled", ^{
            expectedArtworkName = testInitialFileNames.firstObject;
            SDLArtwork *testArt = [SDLArtwork artworkWithImage:testUIImage name:expectedArtworkName asImageFormat:SDLArtworkImageFormatPNG];
            testArt.overwrite = YES;
            [testFileManager uploadArtwork:testArt completionHandler:^(BOOL success, NSString * _Nonnull artworkName, NSUInteger bytesAvailable, NSError * _Nullable error) {
                expect(success).to(beTrue());
                expect(bytesAvailable).to(equal(newBytesAvailable));
                expect(error).to(beNil());
            }];

            SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
            sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
            expect(testFileManager.pendingTransactions.count).to(equal(1));
        });
    });

    describe(@"checking if files and artworks needs upload", ^{
        __block UIImage *testUIImage = nil;
        __block NSString *expectedArtworkName = nil;
        __block SDLArtwork *artwork = nil;

        context(@"when artwork is nil", ^{
            beforeEach(^{
                artwork = nil;
            });

            it(@"should not allow file to be uploaded", ^{
                expect(artwork).to(beNil());
                BOOL testFileNeedsUpload = [testFileManager fileNeedsUpload:artwork];
                expect(testFileNeedsUpload).to(beFalse());
            });
        });

        context(@"when artwork is static", ^{
            it(@"should not allow file to be uploaded", ^{
                artwork = [[SDLArtwork alloc] initWithStaticIcon:SDLStaticIconNameKey];

                BOOL testFileNeedsUpload = [testFileManager fileNeedsUpload:artwork];
                expect(testFileNeedsUpload).to(beFalse());
            });
        });

        context(@"when artwork is dynamic", ^{
            beforeEach(^{
                testUIImage = [FileManagerSpecHelper imagesForCount:1].firstObject;
                expectedArtworkName = testInitialFileNames.firstObject;
                artwork = [SDLArtwork artworkWithImage:testUIImage name:expectedArtworkName asImageFormat:SDLArtworkImageFormatPNG];
            });

            context(@"when uploading artwork for the first time", ^{
                it(@"should allow file to be uploaded", ^{
                    BOOL testFileNeedsUpload = [testFileManager fileNeedsUpload:artwork];
                    expect(testFileNeedsUpload).to(beTrue());
                });
            });

            context(@"when artwork is previously uploaded", ^{
                beforeEach(^{
                    testFileManager.uploadedEphemeralFileNames = [NSMutableSet setWithArray:testInitialFileNames];
                    testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames];
                    [testFileManager.stateMachine setToState:SDLFileManagerStateReady fromOldState:SDLFileManagerStateShutdown callEnterTransition:NO];
                });

                it(@"should not allow file to be uploaded when overwrite is set to false", ^{
                    artwork.overwrite = NO;

                    BOOL testFileNeedsUpload = [testFileManager fileNeedsUpload:artwork];
                    expect(testFileNeedsUpload).to(beFalse());
                });

                it(@"should allow file to be uploaded when overwrite is set to true", ^{
                    artwork.overwrite = YES;

                    BOOL testFileNeedsUpload = [testFileManager fileNeedsUpload:artwork];
                    expect(testFileNeedsUpload).to(beTrue());
                });
            });
        });
    });
});

describe(@"uploading/deleting multiple files in the file manager", ^{
    __block TestMultipleFilesConnectionManager *testConnectionManager;
    __block SDLFileManager *testFileManager;
    __block NSUInteger initialSpaceAvailable = 123;
    NSUInteger newBytesAvailable = 750;
    NSUInteger failureBytesAvailable = 2000000000;

    beforeEach(^{
        testConnectionManager = [[TestMultipleFilesConnectionManager alloc] init];
        SDLFileManagerConfiguration *testFileManagerConfiguration = [[SDLFileManagerConfiguration alloc] initWithArtworkRetryCount:0 fileRetryCount:0];
        testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager configuration:testFileManagerConfiguration];
        testFileManager.suspended = YES;
        testFileManager.bytesAvailable = initialSpaceAvailable;
    });

    afterEach(^{
        [testFileManager stop];
    });

    context(@"When the file manager is passed multiple files to upload", ^{
        __block NSMutableArray<SDLFile *> *testSDLFiles;

        beforeEach(^{
            testSDLFiles = [NSMutableArray array];
            [testFileManager.stateMachine setToState:SDLFileManagerStateReady fromOldState:SDLFileManagerStateShutdown callEnterTransition:NO];
        });

        context(@"and all files are uploaded successfully", ^{
            it(@"should upload 1 file successfully", ^{
                NSString *testFileName = [NSString stringWithFormat:@"TestSmallFileMemory%d", 0];
                SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                testSDLFile.overwrite = true;
                [testSDLFiles addObject:testSDLFile];

                [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                    expect(error).to(beNil());
                }];

                SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);

                expect(testFileManager.pendingTransactions.count).to(equal(1));
                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
            });

            it(@"should upload 5 files successfully", ^{
                for(int i = 0; i < 5; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];
                }

                [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                    expect(error).to(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(5));
                for (int i = 0; i < 5; i += 1) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable - i, nil);
                }

                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable - 4));
            });

            it(@"should upload 500 files successfully", ^{
                for(int i = 0; i < 500; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];
                }

                [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                    expect(error).to(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(500));
                for (int i = 0; i < 500; i += 1) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable - i, nil);
                }

                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable - 499));
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
                NSArray<UIImage *> *images = [FileManagerSpecHelper imagesForCount:1];

                SDLArtwork *testArtwork = [SDLArtwork artworkWithImage:images.firstObject asImageFormat:SDLArtworkImageFormatPNG];
                [testArtworks addObject:testArtwork];
                [expectedArtworkNames addObject:testArtwork.name];

                [testFileManager uploadArtworks:testArtworks completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                    expect(error).to(beNil());
                }];

                SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);

                expect(testFileManager.pendingTransactions.count).to(equal(1));
                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
            });

            it(@"should upload multiple artworks successfully", ^{
                NSArray<UIImage *> *images = [FileManagerSpecHelper imagesForCount:200];

                for (UIImage *image in images) {
                    SDLArtwork *testArtwork = [SDLArtwork artworkWithImage:image asImageFormat:SDLArtworkImageFormatPNG];
                    [testArtworks addObject:testArtwork];
                    [expectedArtworkNames addObject:testArtwork.name];
                }

                [testFileManager uploadArtworks:testArtworks completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                    expect(error).to(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(200));
                for (int i = 0; i < 200; i += 1) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable - i, nil);
                }

                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable - 199));
            });
        });

        context(@"and file uploads fail", ^{
            context(@"file upload failure", ^{
                it(@"should return an error when all files fail", ^{
                    for(int i = 0; i < 5; i++) {
                        NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                        SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                        testSDLFile.overwrite = true;
                        [testSDLFiles addObject:testSDLFile];
                    }

                    [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                        expect(error).toNot(beNil());
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(5));
                    for (int i = 0; i < 5; i++) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_dataMissingError]);
                    }
                    
                    expect(testFileManager.bytesAvailable).to(equal(initialSpaceAvailable));
                });

                it(@"should return an error when the first file fails to upload", ^{
                    for(int i = 0; i < 5; i += 1) {
                        NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                        SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                        testSDLFile.overwrite = true;
                        [testSDLFiles addObject:testSDLFile];
                    }

                    [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                        expect(error).toNot(beNil());
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(5));
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                    sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_dataMissingError]);

                    for (int i = 1; i < 5; i += 1) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                    }

                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                });

                it(@"should return an error when the last file fails to upload", ^{
                    for(int i = 0; i < 5; i += 1) {
                        NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                        SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                        testSDLFile.overwrite = true;
                        [testSDLFiles addObject:testSDLFile];
                    }

                    [testFileManager uploadFiles:testSDLFiles completionHandler:^(NSError * _Nullable error) {
                        expect(error).toNot(beNil());
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(5));
                    for (int i = 0; i < 4; i += 1) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                    }

                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.lastObject;
                    sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_dataMissingError]);

                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                });
            });

            context(@"artwork upload failure", ^{
                __block NSMutableArray<SDLArtwork *> *testArtworks = nil;

                beforeEach(^{
                    testArtworks = [NSMutableArray array];
                });

                it(@"should return an empty artwork name array if all artwork uploads failed", ^{
                    NSArray<UIImage *> *images = [FileManagerSpecHelper imagesForCount:5];
                    for(int i = 0; i < images.count; i += 1) {
                        SDLArtwork *artwork = [SDLArtwork artworkWithImage:images[i] asImageFormat:SDLArtworkImageFormatPNG];
                        [testArtworks addObject:artwork];
                    }

                    [testFileManager uploadArtworks:testArtworks completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                        expect(artworkNames).to(beEmpty());
                        expect(error).toNot(beNil());
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(5));
                    for (int i = 0; i < images.count; i += 1) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_dataMissingError]);
                    }

                    expect(testFileManager.bytesAvailable).to(equal(initialSpaceAvailable));
                });

                it(@"should not include a single failed upload in the artwork names", ^{
                    NSArray<UIImage *> *images = [FileManagerSpecHelper imagesForCount:5];
                    for(int i = 0; i < images.count; i += 1) {
                        SDLArtwork *artwork = [SDLArtwork artworkWithImage:images[i] asImageFormat:SDLArtworkImageFormatPNG];
                        [testArtworks addObject:artwork];
                    }

                    [testFileManager uploadArtworks:testArtworks completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                        expect(artworkNames).to(haveCount(images.count - 1));
                        expect(error).toNot(beNil());
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(5));
                    for (int i = 0; i < images.count - 1; i += 1) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                    }
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.lastObject;
                    sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_dataMissingError]);

                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                });

                it(@"should not return any errors that are overwrite errors", ^{
                    NSArray<UIImage *> *images = [FileManagerSpecHelper imagesForCount:5];
                    for(int i = 0; i < images.count; i++) {
                        SDLArtwork *artwork = [SDLArtwork artworkWithImage:images[i] asImageFormat:SDLArtworkImageFormatPNG];
                        [testArtworks addObject:artwork];
                    }

                    [testFileManager uploadArtworks:testArtworks completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                        expect(artworkNames).to(haveCount(images.count));
                        expect(error).to(beNil());
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(5));
                    
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                    sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_cannotOverwriteError]);

                    for (int i = 1; i < images.count; i++) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                    }

                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                });

                it(@"should not return an error if all the errors are overwrite errors", ^{
                    NSArray<UIImage *> *images = [FileManagerSpecHelper imagesForCount:5];
                    for(int i = 0; i < images.count; i += 1) {
                        SDLArtwork *artwork = [SDLArtwork artworkWithImage:images[i] asImageFormat:SDLArtworkImageFormatPNG];
                        [testArtworks addObject:artwork];
                    }

                    [testFileManager uploadArtworks:testArtworks completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                        expect(artworkNames).to(haveCount(images.count));
                        expect(error).to(beNil());
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(5));
                    for (int i = 0; i < images.count; i += 1) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_cannotOverwriteError]);
                    }

                    expect(testFileManager.bytesAvailable).to(equal(initialSpaceAvailable));
                });
            });
        });

        context(@"files succeed with progress block", ^{
            __block NSMutableDictionary *testFileManagerResponses;
            __block NSMutableDictionary *testFileManagerProgressResponses;
            __block int testTotalFileCount;

            beforeEach(^{
                testFileManagerResponses = [[NSMutableDictionary alloc] init];
                testFileManagerProgressResponses = [[NSMutableDictionary alloc] init];
            });

            context(@"when uploading files", ^{
                it(@"should upload 1 small file from memory without error", ^{
                    NSString *testFileName = [NSString stringWithFormat:@"TestSmallFileMemory%d", 0];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];

                    [testFileManager uploadFiles:testSDLFiles progressHandler:^BOOL(SDLFileName * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                        expect(fileName).to(equal(testFileName));
                        expect(uploadPercentage).to(beCloseTo(1.0));
                        expect(error).to(beNil());
                        return YES;
                    } completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(beNil());
                    }];

                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);

                    expect(testFileManager.pendingTransactions.count).to(equal(1));
                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                });

                it(@"should upload a 5 small files from memory without error", ^{
                    for(int i = 0; i < 5; i += 1) {
                        NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                        SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                        testSDLFile.overwrite = true;
                        [testSDLFiles addObject:testSDLFile];
                    }

                    __block NSUInteger numberOfFilesDone = 0;
                    [testFileManager uploadFiles:testSDLFiles progressHandler:^BOOL(SDLFileName * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                        numberOfFilesDone++;
                        expect(fileName).to(equal([NSString stringWithFormat:@"TestSmallFilesMemory%ld", numberOfFilesDone-1]));
                        expect(uploadPercentage).to(beCloseTo((float)numberOfFilesDone / 5.0));
                        expect(error).to(beNil());
                        return YES;
                    } completionHandler:^(NSError * _Nullable error) {
                        expect(error).to(beNil());
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(5));
                    for (int i = 0; i < 5; i += 1) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable - i, nil);
                    }

                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable - 4));
                });
            });

            context(@"when uploading artworks", ^{
                __block NSMutableArray<SDLArtwork *> *testArtworks = nil;
                __block NSMutableDictionary *testConnectionManagerResponses;
                __block NSMutableArray<NSString*> *expectedArtworkNames = nil;

                beforeEach(^{
                    testArtworks = [NSMutableArray array];
                    testConnectionManagerResponses = [NSMutableDictionary dictionary];
                    expectedArtworkNames = [NSMutableArray array];
                    testTotalFileCount = 0;
                });

                it(@"should upload 1 artwork without error", ^{
                    NSArray<UIImage *> *images = [FileManagerSpecHelper imagesForCount:1];

                    SDLArtwork *testArtwork = [SDLArtwork artworkWithImage:images.firstObject asImageFormat:SDLArtworkImageFormatPNG];
                    [testArtworks addObject:testArtwork];
                    [expectedArtworkNames addObject:testArtwork.name];

                    [testFileManager uploadArtworks:testArtworks progressHandler:^BOOL(NSString * _Nonnull artworkName, float uploadPercentage, NSError * _Nullable error) {
                        expect(artworkName).to(equal(testArtwork.name));
                        expect(uploadPercentage).to(beCloseTo(1.0));
                        expect(error).to(beNil());
                        return YES;
                    } completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                        expect(artworkNames).to(haveCount(1));
                        expect(artworkNames).to(contain(testArtwork.name));
                        expect(error).to(beNil());
                    }];

                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);

                    expect(testFileManager.pendingTransactions.count).to(equal(1));
                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                });

                it(@"should upload multiple artworks without error", ^{
                    NSArray<UIImage *> *images = [FileManagerSpecHelper imagesForCount:200];

                    for (UIImage *image in images) {
                        SDLArtwork *testArtwork = [SDLArtwork artworkWithImage:image asImageFormat:SDLArtworkImageFormatPNG];
                        [testArtworks addObject:testArtwork];
                        [expectedArtworkNames addObject:testArtwork.name];
                    }

                    __block NSUInteger artworksDone = 0;
                    [testFileManager uploadArtworks:testArtworks progressHandler:^BOOL(NSString * _Nonnull artworkName, float uploadPercentage, NSError * _Nullable error) {
                        artworksDone++;
                        expect(artworkName).to(equal(expectedArtworkNames[artworksDone - 1]));
                        expect(uploadPercentage).to(beCloseTo((float)artworksDone / 200.0).within(0.01));
                        expect(error).to(beNil());
                        return YES;
                    } completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
                        expect(artworkNames).to(haveCount(200));
                        expect(error).to(beNil());
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(200));
                    for (int i = 0; i < 200; i += 1) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable - i, nil);
                    }

                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable - 199));
                });
            });
        });

        context(@"when an upload is canceled while in progress by the cancel parameter of the progress handler", ^{
            __block NSMutableDictionary *testResponses;
            __block NSMutableDictionary *testProgressResponses;

            beforeEach(^{
                testResponses = [[NSMutableDictionary alloc] init];
                testProgressResponses = [[NSMutableDictionary alloc] init];
            });

            it(@"should cancel the remaining files if cancel is triggered after first upload", ^{
                for(int i = 0; i < 5; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];
                }

                __block NSUInteger numberOfFilesDone = 0;
                [testFileManager uploadFiles:testSDLFiles progressHandler:^BOOL(SDLFileName * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                    numberOfFilesDone++;
                    expect(fileName).to(equal([NSString stringWithFormat:@"TestSmallFilesMemory%ld", numberOfFilesDone-1]));
                    expect(uploadPercentage).to(beCloseTo((float)numberOfFilesDone / 5.0));

                    if (numberOfFilesDone == 1) {
                        expect(error).to(beNil());
                        return NO;
                    } else {
                        expect(error).toNot(beNil());
                        return YES;
                    }
                } completionHandler:^(NSError * _Nullable error) {
                    expect(error).toNot(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(5));
                SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);

                for (int i = 1; i < 5; i++) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                    expect(sentOperation.cancelled).to(beTrue());
                    sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_fileUploadCanceled]);
                }
                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
            });

            it(@"should cancel the remaining files if cancel is triggered after half of the files are uploaded", ^{
                for(int i = 0; i < 5; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];
                }

                __block NSUInteger numberOfFilesDone = 0;
                [testFileManager uploadFiles:testSDLFiles progressHandler:^BOOL(SDLFileName * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                    numberOfFilesDone++;
                    expect(fileName).to(equal([NSString stringWithFormat:@"TestSmallFilesMemory%ld", numberOfFilesDone-1]));
                    expect(uploadPercentage).to(beCloseTo((float)numberOfFilesDone / 5.0));

                    if (numberOfFilesDone <= 3) {
                        expect(error).to(beNil());
                    } else {
                        expect(error).toNot(beNil());
                    }

                    if (numberOfFilesDone == 3) {
                        return NO;
                    } else {
                        return YES;
                    }
                } completionHandler:^(NSError * _Nullable error) {
                    expect(error).toNot(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(5));
                for (int i = 0; i < 3; i++) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                }

                for (int i = 3; i < 5; i++) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                    expect(sentOperation.cancelled).to(beTrue());
                    sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_fileUploadCanceled]);
                }
                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
            });

            it(@"should not fail if there are no more files to cancel", ^{
                for(int i = 0; i < 5; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];
                }

                __block NSUInteger numberOfFilesDone = 0;
                [testFileManager uploadFiles:testSDLFiles progressHandler:^BOOL(SDLFileName * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                    numberOfFilesDone++;
                    expect(fileName).to(equal([NSString stringWithFormat:@"TestSmallFilesMemory%ld", numberOfFilesDone-1]));
                    expect(uploadPercentage).to(beCloseTo((float)numberOfFilesDone / 5));
                    expect(error).to(beNil());
                    return numberOfFilesDone == 5 ? NO : YES;
                } completionHandler:^(NSError * _Nullable error) {
                    expect(error).to(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(5));
                for (int i = 0; i < 5; i++) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                }
                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
            });
        });

        context(@"When an upload is canceled it should only cancel files that were passed with the same file array", ^{
            // Another group of uploads. These uploads should not be canceled when the other files are canceled.
            __block NSMutableArray<SDLFile *> *testOtherSDLFiles;

            beforeEach(^{
                testOtherSDLFiles = [[NSMutableArray alloc] init];
            });

            it(@"should only cancel the remaining files that were passed with the same file. Other files in the queue that were not passed in the same array should not be canceled", ^{
                // Files to be cancelled
                for(int i = 0; i < 5; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    [testSDLFiles addObject:testSDLFile];
                }

                // Files not to be cancelled
                for(int i = 0; i < 5; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestOtherFilesMemory%d", i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    [testOtherSDLFiles addObject:testSDLFile];
                }

                __block NSUInteger numberOfFilesDone = 0;
                [testFileManager uploadFiles:testSDLFiles progressHandler:^BOOL(SDLFileName * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
                    numberOfFilesDone++;
                    expect(fileName).to(equal([NSString stringWithFormat:@"TestSmallFilesMemory%ld", numberOfFilesDone-1]));
                    expect(uploadPercentage).to(beCloseTo((float)numberOfFilesDone / 5));

                    if (numberOfFilesDone == 1) {
                        expect(error).to(beNil());
                    } else {
                        expect(error).toNot(beNil());
                    }

                    return NO;
                } completionHandler:^(NSError * _Nullable error) {
                    expect(error).toNot(beNil());
                }];

                [testFileManager uploadFiles:testOtherSDLFiles completionHandler:^(NSError * _Nullable error) {
                    expect(error).to(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(10));
                SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);

                for (int i = 1; i < 5; i++) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                    expect(sentOperation.cancelled).to(beTrue());
                    sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_fileUploadCanceled]);
                }

                for (int i = 5; i < 10; i++) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                    expect(sentOperation.cancelled).to(beFalse());
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                }
                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
            });
        });
    });

    context(@"When the file manager is passed multiple files to delete", ^{
        beforeEach(^{
            testFileManager.mutableRemoteFileNames = [NSMutableSet setWithObjects:@"AA", @"BB", @"CC", @"DD", @"EE", @"FF", nil];
            testFileManager.bytesAvailable = initialSpaceAvailable;
        });

        context(@"and all files are deleted successfully", ^{
            it(@"should not return an error when one remote file is deleted", ^{
                [testFileManager deleteRemoteFilesWithNames:@[@"AA"] completionHandler:^(NSError * _Nullable error) {
                    expect(error).to(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(1));
                SDLDeleteFileOperation *deleteOp = testFileManager.pendingTransactions.firstObject;
                deleteOp.completionHandler(YES, newBytesAvailable, nil);

                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                expect(testFileManager.remoteFileNames).toNot(contain(@"AA"));
            });

            it(@"should not return an error when all remote files are deleted", ^{
                [testFileManager deleteRemoteFilesWithNames:@[@"AA", @"BB", @"CC", @"DD", @"EE", @"FF"] completionHandler:^(NSError * _Nullable error) {
                    expect(error).to(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(6));
                for (int i = 0; i < 6; i++) {
                    SDLDeleteFileOperation *deleteOp = testFileManager.pendingTransactions[i];
                    deleteOp.completionHandler(YES, newBytesAvailable, nil);
                }

                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                expect(testFileManager.remoteFileNames).to(haveCount(0));
            });
        });

        context(@"and all files are not deleted successfully", ^{
            __block int testFailureIndexStart;
            __block int testFailureIndexEnd;

            beforeEach(^{
                testFailureIndexStart = -1;
                testFailureIndexEnd = INT8_MAX;
            });

            it(@"should return an error if the first remote file fails to delete", ^{
                [testFileManager deleteRemoteFilesWithNames:@[@"AA", @"BB", @"CC", @"DD", @"EE", @"FF"] completionHandler:^(NSError * _Nullable error) {
                    expect(error).toNot(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(6));
                SDLDeleteFileOperation *deleteOp = testFileManager.pendingTransactions.firstObject;
                deleteOp.completionHandler(NO, newBytesAvailable, [NSError sdl_fileManager_unableToDelete_ErrorWithUserInfo:@{}]);

                for (int i = 1; i < 6; i++) {
                    SDLDeleteFileOperation *deleteOp = testFileManager.pendingTransactions[i];
                    deleteOp.completionHandler(YES, newBytesAvailable, nil);
                }

                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                expect(testFileManager.remoteFileNames).to(haveCount(1));
            });

            it(@"should return an error if the last remote file fails to delete", ^{
                [testFileManager deleteRemoteFilesWithNames:@[@"AA", @"BB", @"CC", @"DD", @"EE", @"FF"] completionHandler:^(NSError * _Nullable error) {
                    expect(error).toNot(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(6));
                for (int i = 0; i < 5; i++) {
                    SDLDeleteFileOperation *deleteOp = testFileManager.pendingTransactions[i];
                    deleteOp.completionHandler(YES, newBytesAvailable, nil);
                }
                SDLDeleteFileOperation *deleteOp = testFileManager.pendingTransactions.lastObject;
                deleteOp.completionHandler(NO, newBytesAvailable, [NSError sdl_fileManager_unableToDelete_ErrorWithUserInfo:@{}]);

                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                expect(testFileManager.remoteFileNames).to(haveCount(1));
            });

            it(@"should return an error if all files fail to delete", ^{
                [testFileManager deleteRemoteFilesWithNames:@[@"AA", @"BB", @"CC", @"DD", @"EE", @"FF"] completionHandler:^(NSError * _Nullable error) {
                    expect(error).toNot(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(6));
                for (int i = 0; i < 6; i++) {
                    SDLDeleteFileOperation *deleteOp = testFileManager.pendingTransactions[i];
                    deleteOp.completionHandler(NO, newBytesAvailable, [NSError sdl_fileManager_unableToDelete_ErrorWithUserInfo:@{}]);
                }

                expect(testFileManager.bytesAvailable).to(equal(initialSpaceAvailable));
                expect(testFileManager.remoteFileNames).to(haveCount(6));
            });
        });
    });

    context(@"The file manager should handle exceptions correctly", ^{
        beforeEach(^{
            testFileManager.mutableRemoteFileNames = [NSMutableSet setWithObjects:@"AA", nil];
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

describe(@"SDLFileManager reupload failed files", ^{
    context(@"setting max upload attempts with the file manager configuration", ^{
        __block SDLFileManager *testFileManager = nil;
        __block TestConnectionManager *testConnectionManager = nil;
        __block SDLFileManagerConfiguration *testFileManagerConfiguration = nil;

        afterEach(^{
            [testFileManager stop];
        });

        it(@"should set the max upload attempts to 2 if the configuration properties are not set", ^{
            testFileManagerConfiguration = [SDLFileManagerConfiguration defaultConfiguration];
            testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager configuration:testFileManagerConfiguration];

            expect(testFileManager.maxFileUploadAttempts).to(equal(2));
            expect(testFileManager.maxArtworkUploadAttempts).to(equal(2));
        });

        it(@"should set the max upload attempts to 1 if retry attempts are disabled", ^{
            testFileManagerConfiguration = [[SDLFileManagerConfiguration alloc] initWithArtworkRetryCount:0 fileRetryCount:0];
            testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager configuration:testFileManagerConfiguration];

            expect(testFileManager.maxFileUploadAttempts).to(equal(1));
            expect(testFileManager.maxArtworkUploadAttempts).to(equal(1));
        });

        it(@"should set the max upload attempts to the corresponding file manager configuration retry attempt count + 1", ^{
            UInt8 artworkRetryCount = 5;
            UInt8 fileRetryCount = 3;
            testFileManagerConfiguration = [[SDLFileManagerConfiguration alloc] initWithArtworkRetryCount:artworkRetryCount fileRetryCount:fileRetryCount];
            testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager configuration:testFileManagerConfiguration];

            expect(testFileManager.maxArtworkUploadAttempts).to(equal((artworkRetryCount + 1)));
            expect(testFileManager.maxFileUploadAttempts).to(equal(fileRetryCount + 1));
        });
    });

    context(@"updating the failed upload count", ^{
        __block NSMutableDictionary<SDLFileName *, NSNumber<SDLUInt> *> *testFailedFileUploadsCount = nil;
        __block NSString *testFileName = @"Test File A";

        beforeEach(^{
            testFailedFileUploadsCount = [NSMutableDictionary dictionary];

            expect(testFailedFileUploadsCount).to(beEmpty());
        });

        it(@"should correctly add a file name", ^{
            testFailedFileUploadsCount = [SDLFileManager sdl_incrementFailedUploadCountForFileName:testFileName failedFileUploadsCount:testFailedFileUploadsCount];

            expect(testFailedFileUploadsCount[testFileName]).to(equal(1));
        });

        it(@"should correctly increment the count for a file name", ^{
            testFailedFileUploadsCount[testFileName] = @1;
            testFailedFileUploadsCount = [SDLFileManager sdl_incrementFailedUploadCountForFileName:testFileName failedFileUploadsCount:testFailedFileUploadsCount];

            expect(testFailedFileUploadsCount[testFileName]).to(equal(2));
        });
    });

    context(@"checking if a failed upload can be uploaded again", ^{
        __block TestConnectionManager *testConnectionManager = nil;
        __block SDLFileManager *testFileManager = nil;
        __block SDLFileManagerConfiguration *testFileManagerConfiguration = nil;
        __block NSMutableDictionary<SDLFileName *, NSNumber<SDLUInt> *> *testFailedFileUploadsCount = nil;
        __block SDLFile *testFile = nil;
        __block NSString *testFileName = @"Test File B";

        beforeEach(^{
            testConnectionManager = [[TestConnectionManager alloc] init];
            testFileManagerConfiguration = [[SDLFileManagerConfiguration alloc] initWithArtworkRetryCount:0 fileRetryCount:0];
            testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager configuration:testFileManagerConfiguration];
            testFileManager.suspended = YES;
            testFailedFileUploadsCount = [NSMutableDictionary dictionary];
            testFile = [[SDLFile alloc] initWithData:[@"someData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin" persistent:false];
        });

        afterEach(^{
            [testFileManager stop];
        });

        describe(@"the file cannot be uploaded again", ^{
            it(@"should not upload a file that is nil", ^{
                // Make sure we are in the ready state
                testFileManager.stateMachine = OCMClassMock([SDLStateMachine class]);
                OCMStub([testFileManager.stateMachine currentState]).andReturn(SDLFileManagerStateReady);
                expect([testFileManager.currentState isEqualToEnum:SDLFileManagerStateReady]).to(beTrue());

                testFile = nil;
                BOOL canUploadAgain = [testFileManager sdl_canFileBeUploadedAgain:testFile maxUploadCount:5 failedFileUploadsCount:testFailedFileUploadsCount];
                expect(canUploadAgain).to(equal(NO));
            });

            it(@"should not upload a file that has already been uploaded the max number of times", ^{
                // Make sure we are in the ready state
                testFileManager.stateMachine = OCMClassMock([SDLStateMachine class]);
                OCMStub([testFileManager.stateMachine currentState]).andReturn(SDLFileManagerStateReady);
                expect([testFileManager.currentState isEqualToEnum:SDLFileManagerStateReady]).to(beTrue());

                testFailedFileUploadsCount[testFileName] = @4;
                BOOL canUploadAgain = [testFileManager sdl_canFileBeUploadedAgain:testFile maxUploadCount:4 failedFileUploadsCount:testFailedFileUploadsCount];
                expect(canUploadAgain).to(equal(NO));
            });

            it(@"should not upload a file if the file manager is not in state ready", ^{
                // Make sure we are NOT in the ready state
                testFileManager.stateMachine = OCMClassMock([SDLStateMachine class]);
                OCMStub([testFileManager.stateMachine currentState]).andReturn(SDLFileManagerStateShutdown);
                expect([testFileManager.currentState isEqualToEnum:SDLFileManagerStateShutdown]).to(beTrue());

                testFailedFileUploadsCount[testFileName] = @4;
                BOOL canUploadAgain = [testFileManager sdl_canFileBeUploadedAgain:testFile maxUploadCount:4 failedFileUploadsCount:testFailedFileUploadsCount];
                expect(canUploadAgain).to(equal(NO));
            });
        });

        describe(@"the file can be uploaded again", ^{
            beforeEach(^{
                // Make sure we are in the ready state
                testFileManager.stateMachine = OCMClassMock([SDLStateMachine class]);
                OCMStub([testFileManager.stateMachine currentState]).andReturn(SDLFileManagerStateReady);
                expect([testFileManager.currentState isEqualToEnum:SDLFileManagerStateReady]).to(beTrue());
            });

            it(@"should upload a file that has not yet failed to upload", ^{
                testFailedFileUploadsCount = [NSMutableDictionary dictionary];
                BOOL canUploadAgain = [testFileManager sdl_canFileBeUploadedAgain:testFile maxUploadCount:2 failedFileUploadsCount:testFailedFileUploadsCount];
                expect(canUploadAgain).to(equal(YES));
            });

            it(@"should upload a file that has not been reuploaded the max number of times", ^{
                testFailedFileUploadsCount[testFileName] = @2;
                BOOL canUploadAgain = [testFileManager sdl_canFileBeUploadedAgain:testFile maxUploadCount:4 failedFileUploadsCount:testFailedFileUploadsCount];
                expect(canUploadAgain).to(equal(YES));
            });
        });
    });
});

QuickSpecEnd
