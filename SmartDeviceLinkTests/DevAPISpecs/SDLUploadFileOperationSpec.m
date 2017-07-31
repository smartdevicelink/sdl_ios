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

describe(@"Streaming upload of data", ^{
    __block NSString *testFileName = nil;
    __block NSData *testFileData = nil;
    __block SDLFile *testFile = nil;
    __block SDLFileWrapper *testFileWrapper = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLUploadFileOperation *testOperation = nil;

    __block BOOL successResult = NO;
    __block NSUInteger bytesAvailableResult = NO;
    __block NSError *errorResult = nil;

    __block SDLPutFileResponse *goodResponse = nil;
    __block NSNumber *responseSpaceAvailable = nil;
    __block NSMutableArray<NSString *> *responseFileNames = nil;

    __block SDLPutFileResponse *badResponse = nil;
    __block NSString *responseErrorDescription = nil;
    __block NSString *responseErrorReason = nil;

    context(@"When a small amount of data is uploaded from memory", ^{
        beforeEach(^{
            // Test with a low MTU size
            [SDLGlobals sharedGlobals].maxHeadUnitVersion = 2;

            testFileName = @"TestFile";
            testFileData = [@"t" dataUsingEncoding:NSUTF8StringEncoding];
            testFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];
            testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                successResult = success;
                bytesAvailableResult = bytesAvailable;
                errorResult = error;
            }];

            testConnectionManager = [[TestConnectionManager alloc] init];
            testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
            [testOperation start];
        });

        context(@"When all putfiles are sent successfully", ^{
            it(@"A successful response should be returned", ^{
                NSUInteger numberOfPutFiles = (((testFileData.length - 1) / [SDLGlobals sharedGlobals].maxMTUSize) + 1);
                NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
                expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));

                // Test all packets for offset, length, and data
                for (NSUInteger index = 0; index < numberOfPutFiles; index++) {
                    SDLPutFile *putFile = putFiles[index];

                    expect(putFile.offset).to(equal(@(index * [SDLGlobals sharedGlobals].maxMTUSize)));
                    expect(putFile.persistentFile).to(equal(@NO));
                    expect(putFile.syncFileName).to(equal(testFileName));
                    expect(putFile.bulkData).to(equal([testFileData subdataWithRange:NSMakeRange((index * [SDLGlobals sharedGlobals].maxMTUSize), MIN(putFile.length.unsignedIntegerValue, [SDLGlobals sharedGlobals].maxMTUSize))]));
                    // Length is used to inform the SDL Core of the total incoming packet size
                    if (index == 0) {
                        // The first putfile sent should have the full file size
                        expect(putFile.length).to(equal(@(testFileData.length)));
                    } else if (index == numberOfPutFiles - 1) {
                        // The last pufile contains the remaining data size
                        expect(putFile.length).to(equal(@(testFileData.length - (index * [SDLGlobals sharedGlobals].maxMTUSize))));
                    } else {
                        // All other putfiles contain the max data size
                        expect(putFile.length).to(equal(@([SDLGlobals sharedGlobals].maxMTUSize)));
                    }
                }

                for (int i = 0; i < numberOfPutFiles; i += 1) {
                    responseSpaceAvailable = @(11212512);
                    responseFileNames = [NSMutableArray arrayWithArray:@[@"test1", @"test2"]];

                    goodResponse = [[SDLPutFileResponse alloc] init];
                    goodResponse.success = @YES;
                    goodResponse.spaceAvailable = responseSpaceAvailable;

                    [testConnectionManager respondToLastRequestWithResponse:goodResponse];

                    // Sent data should be deleted
                    SDLPutFile *putFile = putFiles[i];
                    expect(putFile.bulkData).toEventually(beNil());
                }

                expect(@(successResult)).toEventually(equal(@YES));
                expect(@(bytesAvailableResult)).toEventually(equal(responseSpaceAvailable));
                expect(errorResult).toEventually(beNil());

                expect(@(testOperation.finished)).toEventually(equal(@YES));
                expect(@(testOperation.executing)).toEventually(equal(@NO));
            });
        });

        context(@"When putfiles are not uploaded successfully", ^{
            it(@"An unsuccessful response should be returned", ^{
                NSUInteger numberOfPutFiles = (((testFileData.length - 1) / [SDLGlobals sharedGlobals].maxMTUSize) + 1);

                NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
                expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));

                responseSpaceAvailable = @(20);
                responseErrorDescription = @"some description";
                responseErrorReason = @"some reason";

                badResponse = [[SDLPutFileResponse alloc] init];
                badResponse.success = @NO;
                badResponse.spaceAvailable = responseSpaceAvailable;

                [testConnectionManager respondToLastRequestWithResponse:badResponse error:[NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason]];

                // Sent data should be deleted
                SDLPutFile *putFile = putFiles[0];
                expect(putFile.bulkData).toEventually(beNil());

                expect(errorResult.localizedDescription).toEventually(match(responseErrorDescription));
                expect(errorResult.localizedFailureReason).toEventually(match(responseErrorReason));
                expect(@(successResult)).toEventually(equal(@NO));
                expect(@(bytesAvailableResult)).toEventually(equal(@0));

                expect(@(testOperation.finished)).toEventually(equal(@YES));
                expect(@(testOperation.executing)).toEventually(equal(@NO));
            });
        });
    });

    context(@"When a large amount of data is uploaded from memory", ^{
        beforeEach(^{
            // Test with a low MTU size
            [SDLGlobals sharedGlobals].maxHeadUnitVersion = 1;

            testFileName = @"TestFile";
            testFileData = [@"tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt" dataUsingEncoding:NSUTF8StringEncoding];
            testFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];
            testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                successResult = success;
                bytesAvailableResult = bytesAvailable;
                errorResult = error;
            }];

            testConnectionManager = [[TestConnectionManager alloc] init];
            testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
            [testOperation start]; // A
        });

        context(@"When all putfiles are sent successfully", ^{
            it(@"A successful response should be returned", ^{
                NSUInteger numberOfPutFiles = (((testFileData.length - 1) / [SDLGlobals sharedGlobals].maxMTUSize) + 1);

                NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
                expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));

                // Test all packets for offset, length, and data.
                for (NSUInteger index = 0; index < numberOfPutFiles; index++) {
                    SDLPutFile *putFile = putFiles[index];

                    expect(putFile.offset).to(equal(@(index * [SDLGlobals sharedGlobals].maxMTUSize)));
                    expect(putFile.persistentFile).to(equal(@NO));
                    expect(putFile.syncFileName).to(equal(testFileName));
                    expect(putFile.bulkData).to(equal([testFileData subdataWithRange:NSMakeRange((index * [SDLGlobals sharedGlobals].maxMTUSize), MIN(putFile.length.unsignedIntegerValue, [SDLGlobals sharedGlobals].maxMTUSize))]));

                    if (index == 0) {
                        expect(putFile.length).to(equal(@(testFileData.length)));
                    } else if (index == numberOfPutFiles - 1) {
                        expect(putFile.length).to(equal(@(testFileData.length - (index * [SDLGlobals sharedGlobals].maxMTUSize))));
                    } else {
                        expect(putFile.length).to(equal(@([SDLGlobals sharedGlobals].maxMTUSize)));
                    }
                }

                for (int i = 0; i < numberOfPutFiles; i += 1) {
                    responseSpaceAvailable = @(11212512);
                    responseFileNames = [NSMutableArray arrayWithArray:@[@"test1", @"test2"]];

                    goodResponse = [[SDLPutFileResponse alloc] init];
                    goodResponse.success = @YES;
                    goodResponse.spaceAvailable = responseSpaceAvailable;

                    [testConnectionManager respondToLastRequestWithResponse:goodResponse];
                }

                // Sent data should be deleted
                SDLPutFile *putFile = putFiles[numberOfPutFiles - 1];
                expect(putFile.bulkData).toEventually(beNil());

                expect(@(successResult)).toEventually(equal(@YES));
                expect(@(bytesAvailableResult)).toEventually(equal(responseSpaceAvailable));
                expect(errorResult).toEventually(beNil());

                expect(@(testOperation.finished)).toEventually(equal(@YES));
                expect(@(testOperation.executing)).toEventually(equal(@NO));
            });
        });
        context(@"When putfiles are not sent successfully", ^{
            it(@"An unsuccessful response should be returned", ^{
                NSUInteger numberOfPutFiles = (((testFileData.length - 1) / [SDLGlobals sharedGlobals].maxMTUSize) + 1);

                NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
                expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));

                // Send a bad response for one of the putfiles
                responseSpaceAvailable = @(20);
                responseErrorDescription = @"some description";
                responseErrorReason = @"some reason";
                badResponse = [[SDLPutFileResponse alloc] init];
                badResponse.success = @NO;
                badResponse.spaceAvailable = responseSpaceAvailable;
                [testConnectionManager respondToLastRequestWithResponse:badResponse error:[NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason]];

                // Send good responses for the rest of the putfiles
                for (int i = 1; i < numberOfPutFiles; i += 1) {
                    responseSpaceAvailable = @(11212512);
                    responseFileNames = [NSMutableArray arrayWithArray:@[@"test1", @"test2"]];

                    goodResponse = [[SDLPutFileResponse alloc] init];
                    goodResponse.success = @YES;
                    goodResponse.spaceAvailable = responseSpaceAvailable;

                    [testConnectionManager respondToLastRequestWithResponse:goodResponse];
                }

                // Sent data should be deleted
                SDLPutFile *putFile = putFiles[numberOfPutFiles - 1];
                expect(putFile.bulkData).toEventually(beNil());

                expect(errorResult.localizedDescription).toEventually(match(responseErrorDescription));
                expect(errorResult.localizedFailureReason).toEventually(match(responseErrorReason));
                expect(@(successResult)).toEventually(equal(@NO));
                expect(@(bytesAvailableResult)).toEventually(equal(@0));

                expect(@(testOperation.finished)).toEventually(equal(@YES));
                expect(@(testOperation.executing)).toEventually(equal(@NO));
            });
        });
    });

    context(@"When a large amount of data is uploaded from disk", ^{
        beforeEach(^{
            // Set the head unit size small so we have a low MTU size
            [SDLGlobals sharedGlobals].maxHeadUnitVersion = 2;

            responseSpaceAvailable = @(11212512);

            UIImage *testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            testFileName = @"testFileImage";
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
        });

        context(@"When all putfiles are sent successfully", ^{
            it(@"A successful response should be returned", ^{
                NSUInteger numberOfPutFiles = (((testFileData.length - 1) / [SDLGlobals sharedGlobals].maxMTUSize) + 1);

                NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
                expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));

                // Test all PutFiles pieces for offset & length.
                for (NSUInteger index = 0; index < numberOfPutFiles; index++) {
                    SDLPutFile *putFile = putFiles[index];

                    expect(putFile.offset).to(equal(@(index * [SDLGlobals sharedGlobals].maxMTUSize)));
                    expect(putFile.persistentFile).to(equal(@NO));
                    expect(putFile.syncFileName).to(equal(testFileName));
                    expect(putFile.bulkData).to(equal([testFileData subdataWithRange:NSMakeRange((index * [SDLGlobals sharedGlobals].maxMTUSize), MIN(putFile.length.unsignedIntegerValue, [SDLGlobals sharedGlobals].maxMTUSize))]));

                    // First Putfile has some differences due to informing core of the total incoming packet size.
                    if (index == 0) {
                        expect(putFile.length).to(equal(@(testFileData.length)));
                    } else if (index == numberOfPutFiles - 1) {
                        expect(putFile.length).to(equal(@(testFileData.length - (index * [SDLGlobals sharedGlobals].maxMTUSize))));
                    } else {
                        expect(putFile.length).to(equal(@([SDLGlobals sharedGlobals].maxMTUSize)));
                    }
                }

                NSInteger spaceLeft = 11212512;
                for (int i = 0; i < numberOfPutFiles; i += 1) {
                    if (i != 0) {
                        spaceLeft -= putFiles[i].length.integerValue;
                    } else {
                        spaceLeft -= putFiles[1].length.integerValue;
                    }
                    responseFileNames = [NSMutableArray arrayWithArray:@[@"test1", @"test2"]];

                    goodResponse = [[SDLPutFileResponse alloc] init];
                    goodResponse.success = @YES;
                    goodResponse.spaceAvailable = @(spaceLeft);

                    [testConnectionManager respondToRequestWithResponse:goodResponse requestNumber:i error:nil];
                }

                // Sent data should be deleted
                SDLPutFile *putFile = putFiles[numberOfPutFiles - 1];
                expect(putFile.bulkData).toEventually(beNil());

                expect(@(successResult)).toEventually(equal(@YES));
                expect(@(bytesAvailableResult)).toEventually(equal(spaceLeft));
                expect(errorResult).toEventually(beNil());

                expect(@(testOperation.finished)).toEventually(equal(@YES));
                expect(@(testOperation.executing)).toEventually(equal(@NO));
            });
        });
        context(@"When putfiles are not sent successfully", ^{
            it(@"An unsuccessful response should be returned", ^{
                NSUInteger numberOfPutFiles = (((testFileData.length - 1) / [SDLGlobals sharedGlobals].maxMTUSize) + 1);

                NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
                expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));

                responseSpaceAvailable = @(20);
                responseErrorDescription = @"some description";
                responseErrorReason = @"some reason";
                badResponse = [[SDLPutFileResponse alloc] init];
                badResponse.success = @NO;
                badResponse.spaceAvailable = responseSpaceAvailable;

                // Send bad responses for all of the putfiles
                for (int i = 0; i < numberOfPutFiles; i += 1) {
                    [testConnectionManager respondToLastRequestWithResponse:badResponse error:[NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason]];
                }

                // Sent data should be deleted
                SDLPutFile *putFile = putFiles[numberOfPutFiles - 1];
                expect(putFile.bulkData).toEventually(beNil());

                expect(errorResult.localizedDescription).toEventually(match(responseErrorDescription));
                expect(errorResult.localizedFailureReason).toEventually(match(responseErrorReason));
                expect(@(successResult)).toEventually(equal(@NO));
                expect(@(bytesAvailableResult)).toEventually(equal(@0));

                expect(@(testOperation.finished)).toEventually(equal(@YES));
                expect(@(testOperation.executing)).toEventually(equal(@NO));
            });
        });
    });
});

QuickSpecEnd
