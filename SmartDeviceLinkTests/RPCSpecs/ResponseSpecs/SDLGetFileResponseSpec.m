//
//  SDLGetFileResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFileType.h"
#import "SDLGetFileResponse.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLGetFileResponseSpec)

describe(@"Getter/Setter Tests", ^{
    __block int testOffset = 34;
    __block int testLength = 2;
    __block SDLFileType testFileType = nil;
    __block int testCrc = 2267295;

    beforeEach(^{
        testFileType = SDLFileTypeJPEG;
    });

    it(@"Should set and get correctly", ^{
        SDLGetFileResponse *testResponse = [[SDLGetFileResponse alloc] init];
        testResponse.offset = @(testOffset);
        testResponse.length = @(testLength);
        testResponse.fileType = testFileType;
        testResponse.crc = @(testCrc);

        expect(testResponse.offset).to(equal(testOffset));
        expect(testResponse.length).to(equal(testLength));
        expect(testResponse.fileType).to(equal(testFileType));
        expect(testResponse.crc).to(equal(testCrc));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameResponse:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameOffset:@(testOffset),
                                               SDLRPCParameterNameLength:@(testLength),
                                               SDLRPCParameterNameFileType:testFileType,
                                               SDLRPCParameterNameCRC:@(testCrc)
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetFile}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetFileResponse *testResponse = [[SDLGetFileResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testResponse.offset).to(equal(testOffset));
        expect(testResponse.length).to(equal(testLength));
        expect(testResponse.fileType).to(equal(testFileType));
        expect(testResponse.crc).to(equal(testCrc));
    });

    it(@"Should get correctly when initialized with initWithOffset:length:fileType:crc:", ^{
        SDLGetFileResponse *testResponse = [[SDLGetFileResponse alloc] initWithOffset:testOffset length:testLength fileType:testFileType crc:testCrc];

        expect(testResponse.offset).to(equal(testOffset));
        expect(testResponse.length).to(equal(testLength));
        expect(testResponse.fileType).to(equal(testFileType));
        expect(testResponse.crc).to(equal(testCrc));
    });

    it(@"Should return nil if not set", ^{
        SDLGetFileResponse *testResponse = [[SDLGetFileResponse alloc] init];

        expect(testResponse.offset).to(beNil());
        expect(testResponse.length).to(beNil());
        expect(testResponse.fileType).to(beNil());
        expect(testResponse.crc).to(beNil());
    });
});

QuickSpecEnd



