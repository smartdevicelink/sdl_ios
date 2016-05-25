#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLListFiles.h"
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
            errorResult = error;
            fileNamesResult = fileNames;
        }];
    });
    
    describe(@"running the operation", ^{
        beforeEach(^{
            [testOperation start];
        });
        
        it(@"should send a list files request", ^{
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLListFiles class]));
        });
        
        context(@"when a good response comes back", ^{
            
        });
        
        context(@"when a bad response comes back", ^{
            beforeEach(^{
                
            });
        });
    });
});

QuickSpecEnd
