#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLError.h"
#import "SDLListFiles.h"
#import "SDLListFilesResponse.h"
#import "SDLListFilesOperation.h"
#import "TestConnectionManager.h"


QuickSpecBegin(SDLListFilesOperationSpec)

describe(@"List Files Operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLListFilesOperation *testOperation = nil;
    
    __block BOOL successResult = NO;
    __block NSUInteger bytesAvailableResult = NO;
    __block NSError *errorResult = nil;
    __block NSArray<NSString *> *fileNamesResult = nil;
    
    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testOperation = [[SDLListFilesOperation alloc] initWithConnectionManager:testConnectionManager completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSArray<NSString *> * _Nonnull fileNames, NSError * _Nullable error) {
            successResult = success;
            bytesAvailableResult = bytesAvailable;
            fileNamesResult = fileNames;
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
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLListFiles class]));
        });
        
        context(@"when a good response comes back", ^{
            __block SDLListFilesResponse *goodResponse = nil;
            __block NSNumber *responseSpaceAvailable = nil;
            __block NSMutableArray *responseFileNames = nil;
            
            beforeEach(^{
                responseSpaceAvailable = @(11212512);
                responseFileNames = [NSMutableArray arrayWithArray:@[@"test1", @"test2"]];
                
                goodResponse = [[SDLListFilesResponse alloc] init];
                goodResponse.success = @YES;
                goodResponse.spaceAvailable = responseSpaceAvailable;
                goodResponse.filenames = responseFileNames;
                
                [testConnectionManager respondToLastRequestWithResponse:goodResponse];
            });
            
            it(@"should have called the completion handler with proper data", ^{
                expect(@(successResult)).to(equal(@YES));
                expect(@(bytesAvailableResult)).to(equal(responseSpaceAvailable));
                expect(fileNamesResult).to(haveCount(@(responseFileNames.count)));
                expect(fileNamesResult).to(contain(responseFileNames.firstObject));
                expect(errorResult).to(beNil());
            });
            
            it(@"should be set to finished", ^{
                expect(@(testOperation.finished)).to(equal(@YES));
                expect(@(testOperation.executing)).to(equal(@NO));
            });
        });
        
        context(@"when a bad response comes back", ^{
            __block SDLListFilesResponse *badResponse = nil;
            __block NSNumber *responseSpaceAvailable = nil;
            __block NSMutableArray *responseFileNames = nil;
            
            __block NSString *responseErrorDescription = nil;
            __block NSString *responseErrorReason = nil;
            
            beforeEach(^{
                responseSpaceAvailable = @(0);
                responseFileNames = [NSMutableArray arrayWithArray:@[]];
                
                responseErrorDescription = @"some description";
                responseErrorReason = @"some reason";
                
                badResponse = [[SDLListFilesResponse alloc] init];
                badResponse.success = @NO;
                badResponse.spaceAvailable = responseSpaceAvailable;
                badResponse.filenames = responseFileNames;
                
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
