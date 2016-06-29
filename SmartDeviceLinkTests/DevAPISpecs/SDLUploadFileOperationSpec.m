#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLError.h"
#import "SDLFile.h"
#import "SDLFileWrapper.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLUploadFileOperation.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLUploadFileOperationSpec)

describe(@"Upload File Operation", ^{
    __block NSString *testFileName = nil;
    __block NSData *testFileData = nil;
    __block SDLFile *testFile = nil;
    __block SDLFileWrapper *testFileWrapper = nil;
    
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLUploadFileOperation *testOperation = nil;
    
    __block BOOL successResult = NO;
    __block NSUInteger bytesAvailableResult = NO;
    __block NSError *errorResult = nil;
    
    beforeEach(^{
        testFileName = @"test file";
        testFileData = [@"test1234" dataUsingEncoding:NSUTF8StringEncoding];
        testFile = [SDLFile ephemeralFileWithData:testFileData name:testFileName fileExtension:@"bin"];
        testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
            successResult = success;
            bytesAvailableResult = bytesAvailable;
            errorResult = error;
        }];
        
        testConnectionManager = [[TestConnectionManager alloc] init];
        testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
    });
    
    it(@"should have a priority of 'very high'", ^{
        expect(@(testOperation.queuePriority)).to(equal(@(NSOperationQueuePriorityVeryHigh)));
    });
    
    describe(@"running the operation", ^{
        beforeEach(^{
            [testOperation start];
        });
        
        it(@"should send a list files request", ^{
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLPutFile class]));
        });
        
        context(@"when a good response comes back", ^{
            __block SDLPutFileResponse *goodResponse = nil;
            __block NSNumber *responseSpaceAvailable = nil;
            __block NSMutableArray *responseFileNames = nil;
            
            beforeEach(^{
                responseSpaceAvailable = @(11212512);
                responseFileNames = [NSMutableArray arrayWithArray:@[@"test1", @"test2"]];
                
                goodResponse = [[SDLPutFileResponse alloc] init];
                goodResponse.success = @YES;
                goodResponse.spaceAvailable = responseSpaceAvailable;
                
                [testConnectionManager respondToLastRequestWithResponse:goodResponse];
            });
            
            it(@"should have called the completion handler with proper data", ^{
                expect(@(successResult)).to(equal(@YES));
                expect(@(bytesAvailableResult)).to(equal(responseSpaceAvailable));
                expect(errorResult).to(beNil());
            });
            
            it(@"should be set to finished", ^{
                expect(@(testOperation.finished)).to(equal(@YES));
                expect(@(testOperation.executing)).to(equal(@NO));
            });
        });
        
        context(@"when a bad response comes back", ^{
            __block SDLPutFileResponse *badResponse = nil;
            __block NSNumber *responseSpaceAvailable = nil;
            
            __block NSString *responseErrorDescription = nil;
            __block NSString *responseErrorReason = nil;
            
            beforeEach(^{
                responseSpaceAvailable = @(0);
                
                responseErrorDescription = @"some description";
                responseErrorReason = @"some reason";
                
                badResponse = [[SDLPutFileResponse alloc] init];
                badResponse.success = @NO;
                badResponse.spaceAvailable = responseSpaceAvailable;
                
                [testConnectionManager respondToLastRequestWithResponse:badResponse error:[NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason]];
            });
            
            it(@"should have called completion handler with error", ^{
                expect(errorResult.localizedDescription).to(match(responseErrorDescription));
                expect(errorResult.localizedFailureReason).to(match(responseErrorReason));
                expect(@(successResult)).to(equal(@NO));
                expect(@(bytesAvailableResult)).to(equal(@0));
            });
        });
    });
});

QuickSpecEnd
