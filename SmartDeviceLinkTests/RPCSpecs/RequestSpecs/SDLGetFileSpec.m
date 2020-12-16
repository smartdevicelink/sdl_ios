//
//  SDLGetFileSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetFile.h"
#import "SDLFileType.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLGetFileSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testFileName = nil;
    __block NSString *testAppServiceId = nil;
    __block SDLFileType testFileType = nil;
    __block int testOffset = 45;
    __block int testLength = 67;

    beforeEach(^{
        testFileName = @"testFileName";
        testAppServiceId = @"testAppServiceId";
        testFileType = SDLFileTypePNG;
    });

    it(@"Should set and get correctly", ^{
        SDLGetFile *testRequest = [[SDLGetFile alloc] init];
        testRequest.fileName = testFileName;
        testRequest.appServiceId = testAppServiceId;
        testRequest.fileType = testFileType;
        testRequest.offset = @(testOffset);
        testRequest.length = @(testLength);

        expect(testRequest.fileName).to(equal(testFileName));
        expect(testRequest.appServiceId).to(equal(testAppServiceId));
        expect(testRequest.fileType).to(equal(testFileType));
        expect(testRequest.offset).to(equal(testOffset));
        expect(testRequest.length).to(equal(testLength));
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameFileName:testFileName,
                                               SDLRPCParameterNameAppServiceId:testAppServiceId,
                                               SDLRPCParameterNameFileType:testFileType,
                                               SDLRPCParameterNameOffset:@(testOffset),
                                               SDLRPCParameterNameLength:@(testLength)
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetFile}};
        SDLGetFile *testRequest = [[SDLGetFile alloc] initWithDictionary:dict];

        expect(testRequest.fileName).to(equal(testFileName));
        expect(testRequest.appServiceId).to(equal(testAppServiceId));
        expect(testRequest.fileType).to(equal(testFileType));
        expect(testRequest.offset).to(equal(testOffset));
        expect(testRequest.length).to(equal(testLength));
    });

    it(@"Should initialize correctly with initWithFileName:", ^{
        SDLGetFile *testRequest = [[SDLGetFile alloc] initWithFileName:testFileName];

        expect(testRequest.fileName).to(equal(testFileName));
        expect(testRequest.appServiceId).to(beNil());
        expect(testRequest.fileType).to(beNil());
        expect(testRequest.offset).to(beNil());
        expect(testRequest.length).to(beNil());
    });

    it(@"Should initialize correctly with initWithFileName:appServiceId:fileType:", ^{
        SDLGetFile *testRequest = [[SDLGetFile alloc] initWithFileName:testFileName appServiceId:testAppServiceId fileType:testFileType];

        expect(testRequest.fileName).to(equal(testFileName));
        expect(testRequest.appServiceId).to(equal(testAppServiceId));
        expect(testRequest.fileType).to(equal(testFileType));
        expect(testRequest.offset).to(beNil());
        expect(testRequest.length).to(beNil());
    });

    it(@"Should initialize correctly with initWithFileName:appServiceId:fileType:offset:length:", ^{
        SDLGetFile *testRequest = [[SDLGetFile alloc] initWithFileName:testFileName appServiceId:testAppServiceId fileType:testFileType offset:testOffset length:testLength];

        expect(testRequest.fileName).to(equal(testFileName));
        expect(testRequest.appServiceId).to(equal(testAppServiceId));
        expect(testRequest.fileType).to(equal(testFileType));
        expect(testRequest.offset).to(equal(testOffset));
        expect(testRequest.length).to(equal(testLength));
    });

    it(@"Should return nil if not set", ^{
        SDLGetFile *testRequest = [[SDLGetFile alloc] init];

        expect(testRequest.fileName).to(beNil());
        expect(testRequest.appServiceId).to(beNil());
        expect(testRequest.fileType).to(beNil());
        expect(testRequest.offset).to(beNil());
        expect(testRequest.length).to(beNil());
    });
});

QuickSpecEnd


