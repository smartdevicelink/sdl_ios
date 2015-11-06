#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteFileResponse.h"
#import "SDLError.h"
#import "SDLFile.h"
#import "SDLFileManager.h"
#import "SDLListFiles.h"
#import "SDLListFilesResponse.h"
#import "SDLNotificationConstants.h"
#import "SDLRPCResponse.h"


@interface TestConnectionManager : NSObject<SDLConnectionManager>

@property (copy, nonatomic, readonly) NSMutableArray<__kindof SDLRPCRequest *> *receivedRequests;
@property (copy, nonatomic) SDLRequestCompletionHandler lastRequestBlock;

@property (assign, nonatomic) BOOL respondToListFiles;
@property (strong, nonatomic) SDLListFilesResponse *listFilesResponse;

- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response;
- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response error:(NSError *)error;

@end


@implementation TestConnectionManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _receivedRequests = [NSMutableArray<__kindof SDLRPCRequest *> array];
    
    _respondToListFiles = NO;
    
    return self;
}

- (void)sendRequest:(__kindof SDLRPCRequest *)request withCompletionHandler:(SDLRequestCompletionHandler)block {
    [self.receivedRequests addObject:request];
    self.lastRequestBlock = block;
}

- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response {
    self.lastRequestBlock(self.receivedRequests.lastObject, response, nil);
}

- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response error:(NSError *)error {
    self.lastRequestBlock(self.receivedRequests.lastObject, response, error);
}

@end


QuickSpecBegin(SDLFileManagerSpec)

describe(@"SDLFileManager", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    
    __block SDLListFilesResponse *testListFilesResponse = nil;
    __block NSArray<NSString *> *testListFilesResponseFileNames = nil;
    __block NSNumber *testListFilesResponseSpaceAvailable = nil;
    
    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = [[SDLFileManager alloc] initWithConnectionManager:testConnectionManager];
        
        testListFilesResponseFileNames = @[@"testFile1", @"testFile2", @"testFile3"];
        testListFilesResponseSpaceAvailable = @25;
        testListFilesResponse = [[SDLListFilesResponse alloc] init];
        testListFilesResponse.spaceAvailable = testListFilesResponseSpaceAvailable;
        testListFilesResponse.filenames = [NSMutableArray arrayWithArray:testListFilesResponseFileNames];
        testConnectionManager.listFilesResponse = testListFilesResponse;
    });
    
    describe(@"before receiving a connect notification", ^{
        it(@"should be in the not connected state", ^{
            expect(@(testFileManager.state)).to(equal(@(SDLFileManagerStateNotConnected)));
        });
        
        it(@"bytesAvailable should be 0", ^{
            expect(@(testFileManager.bytesAvailable)).to(equal(@0));
        });
        
        it(@"remoteFileNames should be empty", ^{
            expect(testFileManager.remoteFileNames).to(beEmpty());
        });
        
        it(@"allowOverwrite should be false by default", ^{
            expect(@(testFileManager.allowOverwrite)).to(equal(@YES));
        });
    });
    
    describe(@"after receiving a connect notification", ^{
        beforeEach(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidConnectNotification object:nil];
        });
        
        it(@"should have sent the connection manager a ListFiles request", ^{
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLListFiles class]));
        });
        
        describe(@"before receiving a ListFiles response", ^{
            it(@"should be in the waiting state", ^{
                expect(@(testFileManager.state)).to(equal(@(SDLFileManagerStateWaiting)));
            });
            
            xdescribe(@"entering files before a response then receiving the response", ^{
                it(@"should immediately start sending queued files", ^{
                    
                });
            });
        });
        
        describe(@"after receiving a ListFiles response", ^{
            beforeEach(^{
                [testConnectionManager respondToLastRequestWithResponse:testListFilesResponse];
            });
            
            it(@"should be in the ready state", ^{
                expect(@(testFileManager.state)).to(equal(@(SDLFileManagerStateReady)));
            });
            
            it(@"should properly set the remote file names", ^{
                expect(testFileManager.remoteFileNames).to(equal(testListFilesResponseFileNames));
            });
            
            it(@"should properly set the space available", ^{
                expect(@(testFileManager.bytesAvailable)).to(equal(testListFilesResponseSpaceAvailable));
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
                        expect(testFileManager.remoteFileNames).to(haveCount(@(testListFilesResponseFileNames.count)));
                    });
                });
                
                context(@"when the file is known", ^{
                    __block NSString *someKnownFileName = nil;
                    __block BOOL completionSuccess = NO;
                    __block NSUInteger completionBytesAvailable = 0;
                    __block NSError *completionError = nil;
                    __block NSUInteger newSpaceAvailable = 600;
                    
                    beforeEach(^{
                        someKnownFileName = testListFilesResponseFileNames.firstObject;
                        [testFileManager deleteRemoteFileWithName:someKnownFileName completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                            completionSuccess = success;
                            completionBytesAvailable = bytesAvailable;
                            completionError = error;
                        }];
                        
                        SDLDeleteFileResponse *deleteResponse = [[SDLDeleteFileResponse alloc] init];
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
                    
                    it(@"should return the correct error", ^{
                        expect(completionError).to(equal(beNil()));
                    });
                });
            });
            
            xdescribe(@"uploading a new file", ^{
                __block NSString *fileNameAlreadyExists = @"testFile1";
                __block SDLFile *testUploadFile = nil;
                
                xcontext(@"when there is a remote file named the same thing", ^{
                    beforeEach(^{
                        
                    });
                    
                    describe(@"when allow overwrite is true", ^{
                        
                    });
                });
                
                xcontext(@"when there is not a remote file named the same thing", ^{
                    
                });
            });
            
            xdescribe(@"force uploading a file", ^{
                
            });
        });
    });
});

QuickSpecEnd
