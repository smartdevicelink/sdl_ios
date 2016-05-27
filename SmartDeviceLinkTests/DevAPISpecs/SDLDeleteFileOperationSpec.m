#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteFile.h"
#import "SDLDeleteFileOperation.h"
#import "SDLDeleteFileResponse.h"
#import "SDLError.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLDeleteFileOperationSpec)

describe(@"Delete File Operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLDeleteFileOperation *testOperation = nil;
    
    __block NSString *deleteFileName = nil;
    __block BOOL successResult = NO;
    __block NSUInteger bytesAvailableResult = NO;
    __block NSError *errorResult = nil;
    
    beforeEach(^{
        deleteFileName = @"Some File";
        testConnectionManager = [[TestConnectionManager alloc] init];
        
        testOperation = [[SDLDeleteFileOperation alloc] initWithFileName:deleteFileName connectionManager:testConnectionManager completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
            successResult = success;
            bytesAvailableResult = bytesAvailable;
            errorResult = error;
        }];
    });
    
    it(@"should have a priority of 'very high'", ^{
        expect(@(testOperation.queuePriority)).to(equal(@(NSOperationQueuePriorityVeryHigh)));
    });
    
    describe(@"running the operation", ^{
        beforeEach(^{
            [testOperation start];
        });
        
        it(@"should send a list files request", ^{
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLDeleteFile class]));
        });
        
        context(@"when a good response comes back", ^{
            __block SDLDeleteFileResponse *goodResponse = nil;
            __block NSNumber *responseSpaceAvailable = nil;
            
            beforeEach(^{
                responseSpaceAvailable = @(11212512);
                
                goodResponse = [[SDLDeleteFileResponse alloc] init];
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
            __block SDLDeleteFileResponse *badResponse = nil;
            __block NSNumber *responseSpaceAvailable = nil;
            
            __block NSString *responseErrorDescription = nil;
            __block NSString *responseErrorReason = nil;
            
            beforeEach(^{
                responseSpaceAvailable = @(0);
                
                responseErrorDescription = @"some description";
                responseErrorReason = @"some reason";
                
                badResponse = [[SDLDeleteFileResponse alloc] init];
                badResponse.success = @NO;
                badResponse.spaceAvailable = responseSpaceAvailable;
                
                [testConnectionManager respondToLastRequestWithResponse:badResponse error:[NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason]];
            });
            
            it(@"should have called completion handler with error", ^{
                expect(errorResult.localizedDescription).to(match(responseErrorDescription));
                expect(errorResult.localizedFailureReason).to(match(responseErrorReason));
                expect(@(successResult)).to(equal(@NO));
            });
        });
    });
});

QuickSpecEnd
