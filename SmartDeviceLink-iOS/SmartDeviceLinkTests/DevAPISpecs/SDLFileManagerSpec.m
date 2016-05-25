#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteFileResponse.h"
#import "SDLError.h"
#import "SDLFile.h"
#import "SDLFileManager.h"
#import "SDLFileType.h"
#import "SDLListFiles.h"
#import "SDLListFilesResponse.h"
#import "SDLNotificationConstants.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLRPCResponse.h"
#import "TestConnectionManager.h"


QuickSpecBegin(SDLFileManagerSpec)

describe(@"SDLFileManager", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    
    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager];
    });
    
    describe(@"before receiving a connect notification", ^{
        it(@"should be in the shutdown state", ^{
            expect(testFileManager.currentState).to(match(SDLFileManagerStateShutdown));
        });
        
        it(@"bytesAvailable should be 0", ^{
            expect(@(testFileManager.bytesAvailable)).to(equal(@0));
        });
        
        it(@"remoteFileNames should be empty", ^{
            expect(testFileManager.remoteFileNames).to(beEmpty());
        });
        
        it(@"allowOverwrite should be NO by default", ^{
            expect(@(testFileManager.allowOverwrite)).to(equal(@NO));
        });
    });
    
    describe(@"after receiving a start message", ^{
        beforeEach(^{
            [testFileManager startManagerWithCompletionHandler:nil];
        });
        
        it(@"should have sent the connection manager a ListFiles request", ^{
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLListFiles class]));
        });
        
        describe(@"before receiving a ListFiles response", ^{
            it(@"should be in the fetching initial list state", ^{
                expect(testFileManager.currentState).to(match(SDLFileManagerStateFetchingInitialList));
            });
            
            xdescribe(@"entering files before a response then receiving the response", ^{
                it(@"should immediately start sending queued files", ^{
                    
                });
            });
        });
        
        describe(@"after receiving a ListFiles response", ^{
            __block SDLListFilesResponse *testListFilesResponse = nil;
            __block NSSet<NSString *> *testInitialFileNames = nil;
            __block NSNumber *testInitialSpaceAvailable = nil;
            
            beforeEach(^{
                testInitialFileNames = [NSSet setWithArray:@[@"testFile1", @"testFile2", @"testFile3"]];
                testInitialSpaceAvailable = @0;
                
                testListFilesResponse = [[SDLListFilesResponse alloc] init];
                testListFilesResponse.spaceAvailable = testInitialSpaceAvailable;
                testListFilesResponse.filenames = [NSMutableArray arrayWithArray:[testInitialFileNames allObjects]];
                
                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];
            });
            
            it(@"should be in the ready state", ^{
                expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
            });
            
            it(@"should properly set the remote file names", ^{
                expect(testFileManager.remoteFileNames).to(equal(testInitialFileNames));
            });
            
            it(@"should properly set the space available", ^{
                expect(@(testFileManager.bytesAvailable)).to(equal(testInitialSpaceAvailable));
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
                    });
                    
                    it(@"should return NO for success", ^{
                        expect(@(completionSuccess)).to(equal(@NO));
                    });
                    
                    it(@"should return 0 for bytesAvailable", ^{
                        expect(@(completionBytesAvailable)).to(equal(@0));
                    });
                    
                    it(@"should return the correct error", ^{
                        expect(completionError).to(equal([NSError sdl_fileManager_noKnownFileError]));
                    });
                    
                    it(@"should still contain all files", ^{
                        expect(testFileManager.remoteFileNames).to(haveCount(@(testInitialFileNames.count)));
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
                        
                        [testConnectionManager respondToLastRequestWithResponse:deleteResponse];
                    });
                    
                    it(@"should return YES for success", ^{
                        expect(@(completionSuccess)).to(equal(@YES));
                    });
                    
                    it(@"should return correct number of bytesAvailable", ^{
                        expect(@(completionBytesAvailable)).to(equal(@(newSpaceAvailable)));
                    });
                    
                    it(@"should set the new number of bytes to file manager's bytesAvailable property", ^{
                        expect(@(testFileManager.bytesAvailable)).to(equal(@(newSpaceAvailable)));
                    });
                    
                    it(@"should return without an error", ^{
                        expect(completionError).to(beNil());
                    });
                    
                    xit(@"should have removed the file", ^{
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
                        testUploadFile = [SDLFile ephemeralFileWithData:testFileData name:testFileName fileExtension:@"bin"];
                    });
                    
                    context(@"when allowing overwriting", ^{
                        beforeEach(^{
                            testFileManager.allowOverwrite = YES;
                            
                            [testFileManager uploadFile:testUploadFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                                completionSuccess = success;
                                completionBytesAvailable = bytesAvailable;
                                completionError = error;
                            }];
                            
                            sentPutFile = testConnectionManager.receivedRequests.lastObject;
                        });
                        
                        it(@"should set the file manager state to be waiting", ^{
                            expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                        });
                        
                        it(@"should create a putfile that is the correct size", ^{
                            expect(sentPutFile.length).to(equal(@(testFileData.length)));
                        });
                        
                        it(@"should create a putfile with the correct data", ^{
                            expect(sentPutFile.bulkData).to(equal(testFileData));
                        });
                        
                        it(@"should create a putfile with the correct file type", ^{
                            expect(sentPutFile.fileType.value).to(match([SDLFileType BINARY].value));
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
                            
                            it(@"should set the bytes available correctly", ^{
                                expect(@(testFileManager.bytesAvailable)).to(equal(testResponseBytesAvailable));
                            });
                            
                            it(@"should call the completion handler with the new bytes available", ^{
                                expect(@(completionBytesAvailable)).to(equal(testResponseBytesAvailable));
                            });
                            
                            it(@"should still have the file name available", ^{
                                expect(testFileManager.remoteFileNames).to(contain(testFileName));
                            });
                            
                            it(@"should call the completion handler with success YES", ^{
                                expect(@(completionSuccess)).to(equal(@YES));
                            });
                            
                            it(@"should call the completion handler with nil error", ^{
                                expect(completionError).to(beNil());
                            });
                            
                            it(@"should have the file manager state as ready", ^{
                                expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
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
                            
                            it(@"should set the bytes available correctly", ^{
                                expect(@(testFileManager.bytesAvailable)).to(equal(testResponseBytesAvailable));
                            });
                            
                            it(@"should call the completion handler with the new bytes available", ^{
                                expect(@(completionBytesAvailable)).to(equal(testResponseBytesAvailable));
                            });
                            
                            it(@"should still have the file name available", ^{
                                expect(testFileManager.remoteFileNames).to(contain(testFileName));
                            });
                            
                            it(@"should call the completion handler with success YES", ^{
                                expect(@(completionSuccess)).to(equal(testResponseSuccess));
                            });
                            
                            it(@"should call the completion handler with nil error", ^{
                                expect(completionError).to(beNil());
                            });
                            
                            it(@"should set the file manager state to ready", ^{
                                expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                            });
                        });
                        
                        context(@"when the connection errors without a response", ^{
                            beforeEach(^{
                                [testConnectionManager respondToLastRequestWithResponse:nil error:[NSError sdl_lifecycle_notReadyError]];
                            });
                            
                            it(@"should still have the file name available", ^{
                                expect(testFileManager.remoteFileNames).to(contain(testFileName));
                            });
                            
                            it(@"should call the completion handler with nil error", ^{
                                expect(completionError).to(equal([NSError sdl_lifecycle_notReadyError]));
                            });
                            
                            it(@"should set the file manager state to ready", ^{
                                expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                            });
                        });
                    });
                    
                    context(@"when allow overwrite is false", ^{
                        __block SDLRPCRequest *lastRequest = nil;
                        
                        beforeEach(^{
                            testFileManager.allowOverwrite = NO;
                            
                            [testFileManager uploadFile:testUploadFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                                completionSuccess = success;
                                completionBytesAvailable = bytesAvailable;
                                completionError = error;
                            }];
                            
                            lastRequest = testConnectionManager.receivedRequests.lastObject;
                        });
                        
                        it(@"should not have sent any putfiles", ^{
                            expect(lastRequest).toNot(beAnInstanceOf([SDLPutFile class]));
                        });
                        
                        it(@"should fail", ^{
                            expect(@(completionSuccess)).to(equal(@NO));
                        });
                        
                        it(@"should return the same bytes as the file manager", ^{
                            expect(@(completionBytesAvailable)).to(equal(@(testFileManager.bytesAvailable)));
                        });
                        
                        it(@"should return an error", ^{
                            expect(completionError).to(equal([NSError sdl_fileManager_cannotOverwriteError]));
                        });
                    });
                });
                
                context(@"when there is not a remote file named the same thing", ^{
                    beforeEach(^{
                        testFileName = @"not a test file";
                        testFileData = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
                        testUploadFile = [SDLFile ephemeralFileWithData:testFileData name:testFileName fileExtension:@"bin"];
                        
                        [testFileManager uploadFile:testUploadFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                            completionSuccess = success;
                            completionBytesAvailable = bytesAvailable;
                            completionError = error;
                        }];
                        
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
                        
                        it(@"should set the bytes available correctly", ^{
                            expect(@(testFileManager.bytesAvailable)).to(equal(testResponseBytesAvailable));
                        });
                        
                        it(@"should call the completion handler with the new bytes available", ^{
                            expect(@(completionBytesAvailable)).to(equal(testResponseBytesAvailable));
                        });
                        
                        it(@"should add the file name", ^{
                            expect(testFileManager.remoteFileNames).to(contain(testFileName));
                        });
                        
                        it(@"should call the completion handler with success YES", ^{
                            expect(@(completionSuccess)).to(equal(@YES));
                        });
                        
                        it(@"should call the completion handler with nil error", ^{
                            expect(completionError).to(beNil());
                        });
                        
                        it(@"should set the file manager state to ready", ^{
                            expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
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
                        
                        it(@"should set the bytes available correctly", ^{
                            expect(@(testFileManager.bytesAvailable)).to(equal(testResponseBytesAvailable));
                        });
                        
                        it(@"should call the completion handler with the new bytes available", ^{
                            expect(@(completionBytesAvailable)).to(equal(testResponseBytesAvailable));
                        });
                        
                        it(@"should not have the file name available", ^{
                            expect(testFileManager.remoteFileNames).toNot(contain(testFileName));
                        });
                        
                        it(@"should call the completion handler with success YES", ^{
                            expect(@(completionSuccess)).to(equal(testResponseSuccess));
                        });
                        
                        it(@"should call the completion handler with nil error", ^{
                            expect(completionError).to(beNil());
                        });
                        
                        it(@"should set the file manager state to ready", ^{
                            expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                        });
                    });
                    
                    context(@"when the connection errors without a response", ^{
                        beforeEach(^{
                            [testConnectionManager respondToLastRequestWithResponse:nil error:[NSError sdl_lifecycle_notReadyError]];
                        });
                        
                        it(@"should not have the file name available", ^{
                            expect(testFileManager.remoteFileNames).toNot(contain(testFileName));
                        });
                        
                        it(@"should call the completion handler with nil error", ^{
                            expect(completionError).to(equal([NSError sdl_lifecycle_notReadyError]));
                        });
                        
                        it(@"should set the file manager state to ready", ^{
                            expect(testFileManager.currentState).to(match(SDLFileManagerStateReady));
                        });
                    });
                });
            });
            
            describe(@"force uploading a file", ^{
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
                        testUploadFile = [SDLFile ephemeralFileWithData:testFileData name:testFileName fileExtension:@"bin"];
                    });
                    
                    context(@"when disallowing overwriting", ^{
                        beforeEach(^{
                            testFileManager.allowOverwrite = NO;
                            
                            [testFileManager forceUploadFile:testUploadFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                                completionSuccess = success;
                                completionBytesAvailable = bytesAvailable;
                                completionError = error;
                            }];
                            
                            sentPutFile = testConnectionManager.receivedRequests.lastObject;
                        });
                        
                        it(@"should create a putfile that is the correct size", ^{
                            expect(sentPutFile.length).to(equal(@(testFileData.length)));
                        });
                        
                        it(@"should create a putfile with the correct data", ^{
                            expect(sentPutFile.bulkData).to(equal(testFileData));
                        });
                        
                        it(@"should create a putfile with the correct file type", ^{
                            expect(sentPutFile.fileType.value).to(equal([SDLFileType BINARY].value));
                        });
                    });
                });
            });
        });
    });
});

QuickSpecEnd
