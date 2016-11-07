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
        
        describe(@"after receiving a ListFiles response", ^{
            __block SDLListFilesResponse *testListFilesResponse = nil;
            __block NSSet<NSString *> *testInitialFileNames = nil;
            
            beforeEach(^{
                testInitialFileNames = [NSSet setWithArray:@[@"testFile1", @"testFile2", @"testFile3"]];
                
                testListFilesResponse = [[SDLListFilesResponse alloc] init];
                testListFilesResponse.success = @YES;
                testListFilesResponse.spaceAvailable = @(initialSpaceAvailable);
                testListFilesResponse.filenames = [NSMutableArray arrayWithArray:[testInitialFileNames allObjects]];
                
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
                            expect(sentPutFile.fileType.value).to(match([SDLFileType BINARY].value));
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
                                expect(@(completionBytesAvailable)).to(equal(testResponseBytesAvailable));
                                expect(@(completionSuccess)).to(equal(@YES));
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
                                expect(completionError).to(beNil());
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
                            expect(@(completionBytesAvailable)).to(equal(testResponseBytesAvailable));
                            expect(@(completionSuccess)).to(equal(@YES));
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
                            expect(completionError).to(beNil());
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
