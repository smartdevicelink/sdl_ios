#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLError.h"
#import "SDLFile.h"
#import "SDLFileWrapper.h"
#import "SDLGlobals.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLUploadFileOperation.h"
#import "SDLVersion.h"
#import "TestConnectionManager.h"
#import <zlib.h>

@interface UploadFileOperationSpecHelpers : NSObject

+ (void)testPutFiles:(NSArray<SDLPutFile *> *)putFiles data:(NSData *)testFileData file:(SDLFile *)testFile;

@end

@implementation UploadFileOperationSpecHelpers

+ (void)testPutFiles:(NSArray<SDLPutFile *> *)putFiles data:(NSData *)testFileData file:(SDLFile *)testFile {
    // Test all packets for offset, length, and data
    for (NSUInteger index = 0; index < putFiles.count; index++) {
        SDLPutFile *putFile = putFiles[index];

        NSUInteger mtuSize = [[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeBulkData];
        NSData *testBulkFileData = [testFileData subdataWithRange:NSMakeRange((index * mtuSize), MIN(putFile.length.unsignedIntegerValue, mtuSize))];
        unsigned long testBulkFileDataCrc = crc32(0, testBulkFileData.bytes, (uInt)testBulkFileData.length);

        expect(putFile.offset).to(equal(@(index * mtuSize)));
        expect(putFile.persistentFile).to(equal(@NO));
        expect(putFile.sdlFileName).to(equal(testFile.name));
        expect(putFile.bulkData).to(equal(testBulkFileData));
        expect(putFile.crc).to(equal([NSNumber numberWithUnsignedLong:testBulkFileDataCrc]));

        // Length is used to inform the SDL Core of the total incoming packet size
        if (index == 0) {
            // The first putfile sent should have the full file size
            expect(putFile.length).to(equal(@([testFile fileSize])));
        } else if (index == putFiles.count - 1) {
            // The last pufile contains the remaining data size
            expect(putFile.length).to(equal(@([testFile fileSize] - (index * mtuSize))));
        } else {
            // All other putfiles contain the max data size for a putfile packet
            expect(putFile.length).to(equal(@(mtuSize)));
        }
    }
}

@end

QuickSpecBegin(SDLUploadFileOperationSpec)

describe(@"Streaming upload of data", ^{
    __block NSString *testFileName = nil;
    __block NSData *testFileData = nil;
    __block SDLFile *testFile = nil;
    __block SDLFileWrapper *testFileWrapper = nil;
    __block NSUInteger numberOfPutFiles = 0;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLUploadFileOperation *testOperation = nil;

    __block BOOL successResult = NO;
    __block NSUInteger bytesAvailableResult = NO;
    __block NSError *errorResult = nil;

    beforeEach(^{
        [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = [SDLVersion versionWithString:@"2.0.0"];

        testFileName = nil;
        testFileData = nil;
        testFile = nil;
        testFileWrapper = nil;
        numberOfPutFiles = 0;

        testOperation = nil;
        testConnectionManager = [[TestConnectionManager alloc] init];

        successResult = NO;
        bytesAvailableResult = NO;
        errorResult = nil;
    });

    describe(@"When uploading data", ^{
        context(@"data should be split into smaller packets if too large to send all at once", ^{
            it(@"should split the data from a short chunk of text in memory correctly", ^{
                testFileName = @"TestSmallMemory";
                testFileData = [@"test1234" dataUsingEncoding:NSUTF8StringEncoding];
                testFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];
                __block NSInteger spaceLeft = 11212512;

                testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                    expect(success).to(beTrue());
                    expect(bytesAvailable).to(equal(spaceLeft));
                    expect(error).to(beNil());
                }];

                numberOfPutFiles = ((([testFile fileSize] - 1) / [[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeBulkData]) + 1);

                testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
                [testOperation start];

                NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
                expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));
                [UploadFileOperationSpecHelpers testPutFiles:putFiles data:testFileData file:testFile];

                __block SDLPutFileResponse *goodResponse = nil;

                // We must do some cleanup here otherwise the unit test cases will crash
                for (int i = 0; i < numberOfPutFiles; i++) {
                    spaceLeft -= 1024;
                    goodResponse = [[SDLPutFileResponse alloc] init];
                    goodResponse.success = @YES;
                    goodResponse.spaceAvailable = @(spaceLeft);
                    [testConnectionManager respondToRequestWithResponse:goodResponse requestNumber:i error:nil];
                }

                expect(testOperation.finished).toEventually(beTrue());
                expect(testOperation.executing).toEventually(beFalse());
            });

            it(@"should split the data from a large image in memory correctly", ^{
                testFileName = @"TestLargeMemory";
                UIImage *testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
                testFileData = UIImageJPEGRepresentation(testImage, 1.0);
                testFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];
                __block NSInteger spaceLeft = 11212512;

                testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                    expect(success).to(beTrue());
                    expect(bytesAvailable).to(equal(spaceLeft));
                    expect(error).to(beNil());
                }];

                numberOfPutFiles = ((([testFile fileSize] - 1) / [[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeBulkData]) + 1);

                testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
                [testOperation start];

                NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
                expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));
                [UploadFileOperationSpecHelpers testPutFiles:putFiles data:testFileData file:testFile];

                __block SDLPutFileResponse *goodResponse = nil;

                // We must do some cleanup here otherwise the unit test cases will crash
                for (int i = 0; i < numberOfPutFiles; i++) {
                    spaceLeft -= 1024;
                    goodResponse = [[SDLPutFileResponse alloc] init];
                    goodResponse.success = @YES;
                    goodResponse.spaceAvailable = @(spaceLeft);
                    [testConnectionManager respondToRequestWithResponse:goodResponse requestNumber:i error:nil];
                }

                expect(testOperation.finished).toEventually(beTrue());
                expect(testOperation.executing).toEventually(beFalse());
            });

            it(@"should split the data from a small text file correctly", ^{
                NSString *fileName = @"testFileJSON";
                testFileName = fileName;
                NSString *textFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"json"];
                NSURL *textFileURL = [[NSURL alloc] initFileURLWithPath:textFilePath];
                testFile = [SDLFile fileAtFileURL:textFileURL name:fileName];
                testFileData = [[NSData alloc] initWithContentsOfURL:textFileURL];
                __block NSInteger spaceLeft = 11212512;

                testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                    expect(success).to(beTrue());
                    expect(bytesAvailable).to(equal(spaceLeft));
                    expect(error).to(beNil());
                }];

                numberOfPutFiles = ((([testFile fileSize] - 1) / [[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeBulkData]) + 1);

                testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
                [testOperation start];

                NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
                expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));
                [UploadFileOperationSpecHelpers testPutFiles:putFiles data:testFileData file:testFile];

                __block SDLPutFileResponse *goodResponse = nil;

                // We must do some cleanup here otherwise the unit test cases will crash
                for (int i = 0; i < numberOfPutFiles; i++) {
                    spaceLeft -= 1024;
                    goodResponse = [[SDLPutFileResponse alloc] init];
                    goodResponse.success = @YES;
                    goodResponse.spaceAvailable = @(spaceLeft);
                    [testConnectionManager respondToRequestWithResponse:goodResponse requestNumber:i error:nil];
                }

                expect(testOperation.finished).toEventually(beTrue());
                expect(testOperation.executing).toEventually(beFalse());
            });

            it(@"should split the data from a large image file correctly", ^{
                NSString *fileName = @"testImagePNG";
                testFileName = fileName;
                NSString *imageFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"png"];
                NSURL *imageFileURL = [[NSURL alloc] initFileURLWithPath:imageFilePath];
                testFile = [SDLFile fileAtFileURL:imageFileURL name:fileName];
                __block NSInteger spaceLeft = 11212512;

                // For testing: get data to check if data chunks are being created correctly
                testFileData = [[NSData alloc] initWithContentsOfURL:imageFileURL];

                testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                    expect(success).to(beTrue());
                    expect(bytesAvailable).to(equal(spaceLeft));
                    expect(error).to(beNil());
                }];

                numberOfPutFiles = ((([testFile fileSize] - 1) / [[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeBulkData]) + 1);

                testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
                [testOperation start];

                NSArray<SDLPutFile *> *putFiles = testConnectionManager.receivedRequests;
                expect(@(putFiles.count)).to(equal(@(numberOfPutFiles)));
                [UploadFileOperationSpecHelpers testPutFiles:putFiles data:testFileData file:testFile];

                __block SDLPutFileResponse *goodResponse = nil;

                // We must do some cleanup here otherwise the unit test cases will crash
                for (int i = 0; i < numberOfPutFiles; i++) {
                    spaceLeft -= 1024;
                    goodResponse = [[SDLPutFileResponse alloc] init];
                    goodResponse.success = @YES;
                    goodResponse.spaceAvailable = @(spaceLeft);
                    [testConnectionManager respondToRequestWithResponse:goodResponse requestNumber:i error:nil];
                }

                expect(testOperation.finished).toEventually(beTrue());
                expect(testOperation.executing).toEventually(beFalse());
            });
        });
    });

    describe(@"When a response to the data upload comes back", ^{
        beforeEach(^{
            testFileName = @"TestLargeMemory";
            UIImage *testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            testFileData = UIImageJPEGRepresentation(testImage, 1.0);
            testFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];
            testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                successResult = success;
                bytesAvailableResult = bytesAvailable;
                errorResult = error;
            }];

            NSUInteger mtuSize = [[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeBulkData];

            numberOfPutFiles = ((([testFile fileSize] - 1) / mtuSize) + 1);

            testConnectionManager = [[TestConnectionManager alloc] init];
            testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
            [testOperation start];
        });

        context(@"If data was sent successfully", ^{
            __block SDLPutFileResponse *goodResponse = nil;
            __block NSInteger spaceLeft = 0;

            beforeEach(^{
                goodResponse = nil;
                spaceLeft = 11212512;
            });

            it(@"should have called the completion handler with success only if all packets were sent successfully", ^{
                for (int i = 0; i < numberOfPutFiles; i++) {
                    spaceLeft -= 1024;
                    goodResponse = [[SDLPutFileResponse alloc] init];
                    goodResponse.success = @YES;
                    goodResponse.spaceAvailable = @(spaceLeft);
                    [testConnectionManager respondToRequestWithResponse:goodResponse requestNumber:i error:nil];
                }

                expect(successResult).toEventually(beTrue());
                expect(bytesAvailableResult).toEventually(equal(spaceLeft));
                expect(errorResult).toEventually(beNil());

                expect(testOperation.finished).toEventually(beTrue());
                expect(testOperation.executing).toEventually(beFalse());
            });
        });

        context(@"If data was not sent successfully", ^{
            __block SDLPutFileResponse *response = nil;
            __block NSString *responseErrorDescription = nil;
            __block NSString *responseErrorReason = nil;
            __block NSInteger spaceLeft = 0;

            beforeEach(^{
                response = nil;
                responseErrorDescription = nil;
                responseErrorReason = nil;
                spaceLeft = 11212512;
            });

            it(@"should have called the completion handler with error if the first packet was not sent successfully", ^{
                for (int i = 0; i < numberOfPutFiles; i++) {
                    spaceLeft -= 1024;
                    response = [[SDLPutFileResponse alloc] init];
                    response.spaceAvailable = @(spaceLeft);
                    NSError *error = nil;

                    if (i == 0) {
                        // Only the first packet is sent unsuccessfully
                        response.success = @NO;
                        responseErrorDescription = @"some description";
                        responseErrorReason = @"some reason";
                        error = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason];
                    } else  {
                        response.success = @YES;
                    }

                    [testConnectionManager respondToRequestWithResponse:response requestNumber:i error:error];
                }

                expect(errorResult.localizedDescription).toEventually(match(responseErrorDescription));
                expect(errorResult.localizedFailureReason).toEventually(match(responseErrorReason));
                expect(successResult).toEventually(beFalse());
            });

            it(@"should have called the completion handler with error if the last packet was not sent successfully", ^{
                for (int i = 0; i < numberOfPutFiles; i++) {
                    spaceLeft -= 1024;
                    response = [[SDLPutFileResponse alloc] init];
                    response.spaceAvailable = @(spaceLeft);
                    NSError *error = nil;

                    if (i == (numberOfPutFiles - 1)) {
                        // Only the last packet is sent unsuccessfully
                        response.success = @NO;
                        responseErrorDescription = @"some description";
                        responseErrorReason = @"some reason";
                        error = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason];
                    } else  {
                        response.success = @YES;
                    }

                    [testConnectionManager respondToRequestWithResponse:response requestNumber:i error:error];
                }

                expect(errorResult.localizedDescription).toEventually(match(responseErrorDescription));
                expect(errorResult.localizedFailureReason).toEventually(match(responseErrorReason));
                expect(successResult).toEventually(beFalse());
            });

            it(@"should have called the completion handler with error if all packets were not sent successfully", ^{
                for (int i = 0; i < numberOfPutFiles; i++) {
                    spaceLeft -= 1024;
                    response = [[SDLPutFileResponse alloc] init];
                    response.success = @NO;
                    response.spaceAvailable = @(spaceLeft);

                    responseErrorDescription = @"some description";
                    responseErrorReason = @"some reason";

                    [testConnectionManager respondToRequestWithResponse:response requestNumber:i error:[NSError sdl_lifecycle_unknownRemoteErrorWithDescription:responseErrorDescription andReason:responseErrorReason]];
                }

                expect(errorResult.localizedDescription).toEventually(match(responseErrorDescription));
                expect(errorResult.localizedFailureReason).toEventually(match(responseErrorReason));
                expect(successResult).toEventually(beFalse());
            });
        });
    });

    describe(@"when an incorrect file url is passed", ^{
        it(@"should have called the completion handler with an error", ^{
            NSString *fileName = @"testImagePNG";
            testFileName = fileName;
            NSString *imageFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"png"];
            NSURL *imageFileURL = [[NSURL alloc] initWithString:imageFilePath]; // This will fail because local file paths need to be init with initFileURLWithPath
            testFile = [SDLFile fileAtFileURL:imageFileURL name:fileName];

            testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                expect(success).to(beFalse());
                expect(error).to(equal([NSError sdl_fileManager_fileDoesNotExistError]));
            }];

            testConnectionManager = [[TestConnectionManager alloc] init];
            testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
            [testOperation start];
        });
    });

    describe(@"when empty data is passed", ^{
        it(@"should have called the completion handler with an error", ^{
            testFileName = @"TestEmptyMemory";
            testFileData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
            testFile = [SDLFile fileWithData:testFileData name:testFileName fileExtension:@"bin"];

            testFileWrapper = [SDLFileWrapper wrapperWithFile:testFile completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
                expect(error).to(equal([NSError sdl_fileManager_fileDoesNotExistError]));
                expect(success).to(beFalse());
            }];

            testConnectionManager = [[TestConnectionManager alloc] init];
            testOperation = [[SDLUploadFileOperation alloc] initWithFile:testFileWrapper connectionManager:testConnectionManager];
            [testOperation start];
        });
    });
});

QuickSpecEnd
