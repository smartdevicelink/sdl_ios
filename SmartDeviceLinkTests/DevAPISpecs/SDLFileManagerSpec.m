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

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManagerConfiguration = [[SDLFileManagerConfiguration alloc] initWithArtworkRetryCount:0 fileRetryCount:0];
        testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager configuration:testFileManagerConfiguration];
        testFileManager.suspended = YES;
        testFileManager.mutableRemoteFileNames = [NSMutableSet setWithArray:testInitialFileNames];
        testFileManager.bytesAvailable = initialSpaceAvailable;
    });

    afterEach(^{
        [testFileManager stop];
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

        it(@"should set the maximum number of upload attempts to 1", ^{
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

            beforeEach(^{
                [testFileManager stop];
                SDLListFilesOperation *operation = testFileManager.pendingTransactions.firstObject;
                operation.completionHandler(YES, initialSpaceAvailable, testInitialFileNames, nil);
            });

            it(@"should remain in the stopped state after receiving the response if disconnected", ^{
                expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateShutdown));
                expect(@(completionHandlerCalled)).toEventually(equal(@YES));
            });
        });

        describe(@"after receiving a ListFiles error", ^{
            beforeEach(^{
                SDLListFilesOperation *operation = testFileManager.pendingTransactions.firstObject;
                operation.completionHandler(NO, initialSpaceAvailable, testInitialFileNames, [NSError sdl_fileManager_unableToStartError]);
            });

            it(@"should handle the error properly", ^{
                expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateStartupError));
                expect(testFileManager.remoteFileNames).toEventually(beEmpty());
                expect(@(testFileManager.bytesAvailable)).toEventually(equal(initialSpaceAvailable));
            });
        });

        describe(@"after receiving a ListFiles response", ^{
            beforeEach(^{
                SDLListFilesOperation *operation = testFileManager.pendingTransactions.firstObject;
                operation.completionHandler(YES, initialSpaceAvailable, testInitialFileNames, nil);
            });

            it(@"the file manager should be in the correct state", ^{
                expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateReady));
                expect(testFileManager.remoteFileNames).toEventually(equal(testInitialFileNames));
                expect(@(testFileManager.bytesAvailable)).toEventually(equal(@(initialSpaceAvailable)));
            });
        });
    });

    describe(@"deleting a file", ^{
        __block BOOL completionSuccess = NO;
        __block NSUInteger completionBytesAvailable = 0;
        __block NSError *completionError = nil;

        beforeEach(^{
            [testFileManager.stateMachine setToState:SDLFileManagerStateReady fromOldState:SDLFileManagerStateShutdown callEnterTransition:NO];
        });

        // TODO: Here, removing all running of operations
        context(@"when the file is unknown", ^{
            beforeEach(^{
                NSString *someUnknownFileName = @"Some Unknown File Name";
                [testFileManager deleteRemoteFileWithName:someUnknownFileName completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                    completionSuccess = success;
                    completionBytesAvailable = bytesAvailable;
                    completionError = error;
                }];

                SDLDeleteFileOperation *operation = testFileManager.pendingTransactions.firstObject;
                operation.completionHandler(NO, initialSpaceAvailable, [NSError sdl_fileManager_noKnownFileError]);
            });

            it(@"should return the correct data", ^{
                expect(@(completionSuccess)).toEventually(equal(@NO));
                expect(@(completionBytesAvailable)).toEventually(equal(@250));
                expect(completionError).toEventually(equal([NSError sdl_fileManager_noKnownFileError]));
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

    describe(@"uploading a new file", ^{
        __block NSString *testFileName = nil;
        __block SDLFile *testUploadFile = nil;
        __block BOOL completionSuccess = NO;
        __block NSUInteger completionBytesAvailable = 0;
        __block NSError *completionError = nil;

        __block NSData *testFileData = nil;

        beforeEach(^{
            [testFileManager.stateMachine setToState:SDLFileManagerStateReady fromOldState:SDLFileManagerStateShutdown callEnterTransition:NO];
        });

        context(@"when there is a remote file with the same file name", ^{
            beforeEach(^{
                testFileName = [testInitialFileNames lastObject];
                testFileData = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
                testUploadFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];
            });

            context(@"when the file's overwrite property is YES", ^{
                context(@"when the connection returns a success", ^{
                    beforeEach(^{
                        testUploadFile.overwrite = YES;

                        [testFileManager uploadFile:testUploadFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                            completionSuccess = success;
                            completionBytesAvailable = bytesAvailable;
                            completionError = error;
                        }];
                    });
                });

                beforeEach(^{
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                });

                it(@"should set the file manager state to be waiting and set correct data", ^{
                    expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                    expect(testFileManager.uploadedEphemeralFileNames).to(beEmpty());

                    expect(completionBytesAvailable).to(equal(newBytesAvailable));
                    expect(completionSuccess).to(equal(YES));
                    expect(completionError).to(beNil());

                    expect(@(testFileManager.bytesAvailable)).to(equal(newBytesAvailable));
                    expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                    expect(testFileManager.remoteFileNames).to(contain(testFileName));
                    expect(testFileManager.uploadedEphemeralFileNames).to(contain(testFileName));
                });

                context(@"when the connection returns failure", ^{
                    beforeEach(^{
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                        sentOperation.fileWrapper.completionHandler(NO, failureSpaceAvailabe, [NSError sdl_fileManager_fileUploadCanceled]);
                    });

                    it(@"should set the file manager data correctly", ^{
                        expect(testFileManager.bytesAvailable).toEventually(equal(initialSpaceAvailable));
                        expect(testFileManager.remoteFileNames).toEventually(contain(testFileName));
                        expect(testFileManager.currentState).toEventually(match(SDLFileManagerStateReady));
                        expect(testFileManager.uploadedEphemeralFileNames).to(beEmpty());

                        expect(completionBytesAvailable).to(equal(failureSpaceAvailabe));
                        expect(completionSuccess).to(equal(@NO));
                        expect(completionError).toNot(beNil());

                        expect(testFileManager.failedFileUploadsCount[testFileName]).to(equal(1));
                    });
                });
            });

            context(@"when allow overwrite is NO", ^{
                __block NSString *testUploadFileName = nil;
                __block Boolean testUploadOverwrite = NO;

                beforeEach(^{
                    testUploadFileName = [testInitialFileNames lastObject];
                });

                it(@"should not upload the file if persistance is YES", ^{
                    SDLFile *persistantFile = [[SDLFile alloc] initWithData:testFileData name:testUploadFileName fileExtension:@"bin" persistent:YES];
                    persistantFile.overwrite = testUploadOverwrite;

                    [testFileManager uploadFile:persistantFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                        expect(@(success)).to(beFalse());
                        expect(@(bytesAvailable)).to(equal(@(testFileManager.bytesAvailable)));
                        expect(error).to(equal([NSError sdl_fileManager_cannotOverwriteError]));
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(0));
                });

                it(@"should upload the file if persistance is NO", ^{
                    SDLFile *unPersistantFile = [[SDLFile alloc] initWithData:testFileData name:testUploadFileName fileExtension:@"bin" persistent:NO];
                    unPersistantFile.overwrite = testUploadOverwrite;

                    [testFileManager uploadFile:unPersistantFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
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
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), YES, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [[UIColor blackColor] setFill];
            CGContextFillRect(context, CGRectMake(0, 0, 5, 5));
            UIImage *blackSquareImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            testUIImage = blackSquareImage;

            [testFileManager.stateMachine setToState:SDLFileManagerStateReady fromOldState:SDLFileManagerStateShutdown callEnterTransition:NO];
        });

        it(@"should not upload the artwork again and simply return the artwork name when sending artwork that has already been uploaded", ^{
            expectedArtworkName = testInitialFileNames.firstObject;

            [testFileManager uploadArtwork:[SDLArtwork artworkWithImage:testUIImage name:expectedArtworkName asImageFormat:SDLArtworkImageFormatPNG] completionHandler:^(BOOL success, NSString * _Nonnull artworkName, NSUInteger bytesAvailable, NSError * _Nullable error) {
                expect(success).to(beFalse());
                expect(bytesAvailable).to(equal(initialSpaceAvailable));
                expect(error).toNot(beNil());
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
            __block NSMutableDictionary *testConnectionManagerResponses;
            __block NSMutableDictionary *expectedFailedUploads;
            __block NSError *expectedError;
            __block int testFailureIndexStart;
            __block int testFailureIndexEnd;

            beforeEach(^{
                testConnectionManagerResponses = [[NSMutableDictionary alloc] init];
                expectedFailedUploads = [[NSMutableDictionary alloc] init];
                expectedError = nil;
            });

            context(@"file upload failure", ^{
                beforeEach(^{
                    testFailureIndexStart = -1;
                    testFailureIndexEnd = INT8_MAX;
                });

                it(@"should return an error when all files fail", ^{
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
                    for (int i = 0; i < 5; i += 1) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, nil);
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
                    sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, nil);

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
                    sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, nil);

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
                        sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, nil);
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
                    sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, nil);

                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
                });

                it(@"should not return any errors that are overwrite errors", ^{
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
                    for (int i = 0; i < images.count; i += 1) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];

                        if (i % 2 == 0) {
                            sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_cannotOverwriteError]);
                        } else {
                            sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                        }
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
                        expect(artworkNames).to(haveCount(images.count - 1));
                        expect(error).toNot(beNil());
                    }];

                    expect(testFileManager.pendingTransactions.count).to(equal(5));
                    for (int i = 0; i < images.count; i += 1) {
                        SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions[i];
                        sentOperation.fileWrapper.completionHandler(NO, failureBytesAvailable, [NSError sdl_fileManager_cannotOverwriteError]);
                    }

                    expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
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
                        expect(uploadPercentage).to(beCloseTo(100.0));
                        expect(error).toNot(beNil());
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
                        expect(uploadPercentage).to(beCloseTo(numberOfFilesDone / 5));
                        expect(error).toNot(beNil());
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
                        expect(uploadPercentage).to(beCloseTo(100.0));
                        expect(error).toNot(beNil());
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
                        expect(artworkName).to(equal(expectedArtworkNames[artworksDone]));
                        expect(uploadPercentage).to(beCloseTo(artworksDone / 200));
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
                    expect(uploadPercentage).to(beCloseTo(numberOfFilesDone / 5));
                    expect(error).toNot(beNil());
                    return numberOfFilesDone == 1 ? NO : YES;
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
                    expect(uploadPercentage).to(beCloseTo(numberOfFilesDone / 5));
                    expect(error).toNot(beNil());
                    return numberOfFilesDone == 3 ? NO : YES;
                } completionHandler:^(NSError * _Nullable error) {
                    expect(error).toNot(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(5));
                for (int i = 0; i < 3; i++) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
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
                    expect(uploadPercentage).to(beCloseTo(numberOfFilesDone / 5));
                    expect(error).to(beNil());
                    return numberOfFilesDone == 5 ? NO : YES;
                } completionHandler:^(NSError * _Nullable error) {
                    expect(error).to(beNil());
                }];

                expect(testFileManager.pendingTransactions.count).to(equal(5));
                for (int i = 0; i < 5; i++) {
                    SDLUploadFileOperation *sentOperation = testFileManager.pendingTransactions.firstObject;
                    sentOperation.fileWrapper.completionHandler(YES, newBytesAvailable, nil);
                }
                expect(testFileManager.bytesAvailable).to(equal(newBytesAvailable));
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

                // Files to be cancelled
                for(int i = 0; i < 5; i += 1) {
                    NSString *testFileName = [NSString stringWithFormat:@"TestSmallFilesMemory%d", i];
                    SDLFile *testSDLFile = [SDLFile fileWithData:[@"someTextData" dataUsingEncoding:NSUTF8StringEncoding] name:testFileName fileExtension:@"bin"];
                    testSDLFile.overwrite = true;
                    [testSDLFiles addObject:testSDLFile];
                }

                // Files not to be cancelled
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
                    expect(uploadPercentage).to(beCloseTo(numberOfFilesDone / 5));
                    expect(error).toNot(beNil());
                    return numberOfFilesDone == 1 ? NO : YES;
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

                waitUntilTimeout(1.0, ^(void (^done)(void)){
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
                        for(int i = 0; i < expectedSuccessfulFileNames.count; i += 1) {
                            expect(testFileManager.remoteFileNames).to(contain(expectedSuccessfulFileNames[i]));
                        }
                        done();
                    }];
                });
            });
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
