#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLError.h"
#import "SDLFile.h"
#import "SDLFileWrapper.h"
#import "SDLGlobals.h"
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
        // Set the head unit size small so we have a low MTU size
        [SDLGlobals globals].maxHeadUnitVersion = 2;
    });
    
    context(@"running a small file operation", ^{
        beforeEach(^{
            testFileName = @"test file";
            testFileData = [@"test1234" dataUsingEncoding:NSUTF8StringEncoding];
            testFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];
            testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                successResult = success;
                bytesAvailableResult = bytesAvailable;
                errorResult = error;
            }];
            
            testConnectionManager = [[TestConnectionManager alloc] init];
            testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
            
            [testOperation start];
            [NSThread sleepForTimeInterval:0.5];
        });
        
        it(@"should have a priority of 'normal'", ^{
            expect(@(testOperation.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
        });
        
        it(@"should send putfiles", ^{
            SDLPutFile *putFile = testConnectionManager.receivedRequests.lastObject;
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLPutFile class]));
            expect(putFile.bulkData).to(equal(testFileData));
            expect(putFile.length).to(equal(@(testFileData.length)));
            expect(putFile.offset).to(equal(@0));
            expect(putFile.persistentFile).to(equal(@NO));
            expect(putFile.syncFileName).to(equal(testFileName));
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
                expect(@(successResult)).toEventually(equal(@YES));
                expect(@(bytesAvailableResult)).toEventually(equal(responseSpaceAvailable));
                expect(errorResult).toEventually(beNil());
            });
            
            it(@"should be set to finished", ^{
                expect(@(testOperation.finished)).toEventually(equal(@YES));
                expect(@(testOperation.executing)).toEventually(equal(@NO));
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
                expect(errorResult.localizedDescription).toEventually(match(responseErrorDescription));
                expect(errorResult.localizedFailureReason).toEventually(match(responseErrorReason));
                expect(@(successResult)).toEventually(equal(@NO));
                expect(@(bytesAvailableResult)).toEventually(equal(@0));
            });
        });
    });
    
    context(@"sending a large file", ^{
        beforeEach(^{
            UIImage *testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            
            testFileName = @"test file";
            testFileData = UIImageJPEGRepresentation(testImage, 0.80);
            testFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];
            testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                successResult = success;
                bytesAvailableResult = bytesAvailable;
                errorResult = error;
            }];
            
            testConnectionManager = [[TestConnectionManager alloc] init];
            testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
            
            [testOperation start];
            [NSThread sleepForTimeInterval:0.5];
        });
        
        it(@"should send correct putfiles", ^{
            NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
            
            NSUInteger numberOfPutFiles = (((testFileData.length - 1) / [SDLGlobals globals].maxMTUSize) + 1);
            expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));

            // Test all PutFiles pieces for offset & length.
            for (NSUInteger index = 0; index < numberOfPutFiles; index++) {
                SDLPutFile *putFile = putFiles[index];
                
                expect(putFile.offset).to(equal(@(index * [SDLGlobals globals].maxMTUSize)));
                expect(putFile.persistentFile).to(equal(@NO));
                expect(putFile.syncFileName).to(equal(testFileName));
                expect(putFile.bulkData).to(equal([testFileData subdataWithRange:NSMakeRange((index * [SDLGlobals globals].maxMTUSize), MIN(putFile.length.unsignedIntegerValue, [SDLGlobals globals].maxMTUSize))]));

                // First Putfile has some differences due to informing core of the total incoming packet size.
                if (index == 0) {
                    expect(putFile.length).to(equal(@(testFileData.length)));
                } else if (index == numberOfPutFiles - 1) {
                    expect(putFile.length).to(equal(@(testFileData.length - (index * [SDLGlobals globals].maxMTUSize))));
                } else {
                    expect(putFile.length).to(equal(@([SDLGlobals globals].maxMTUSize)));
                }
            }
            
        });
    });
});

QuickSpecEnd
