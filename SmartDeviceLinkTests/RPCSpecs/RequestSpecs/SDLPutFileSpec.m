//
//  SDLPutFileSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFileType.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLPutFile.h"

#import <zlib.h>


@interface SDLPutFile()
+ (unsigned long)sdl_getCRC32ChecksumForBulkData:(NSData *)data;
@end

QuickSpecBegin(SDLPutFileSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPutFile* testRequest = [[SDLPutFile alloc] init];
        
        testRequest.sdlFileName = @"fileName";
        testRequest.fileType = SDLFileTypeJPEG;
        testRequest.persistentFile = @YES;
        testRequest.systemFile = @NO;
        testRequest.offset = @987654321;
        testRequest.length = @123456789;
        testRequest.crc = @0xffffffff;
        
        expect(testRequest.sdlFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal(SDLFileTypeJPEG));
        expect(testRequest.persistentFile).to(equal(@YES));
        expect(testRequest.systemFile).to(equal(@NO));
        expect(testRequest.offset).to(equal(@987654321));
        expect(testRequest.length).to(equal(@123456789));
        expect(testRequest.crc).to(equal(0xffffffff));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.syncFileName).to(equal(@"fileName"));
#pragma clang diagnostic pop
    });
    
    it(@"Should get and set correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameRequest:
                                           @{SDLRPCParameterNameParameters:
                                                @{ SDLRPCParameterNameSyncFileName:@"fileName",
                                                    SDLRPCParameterNameFileType:SDLFileTypeJPEG,
                                                    SDLRPCParameterNamePersistentFile:@YES,
                                                    SDLRPCParameterNameSystemFile:@NO,
                                                    SDLRPCParameterNameOffset:@987654321,
                                                    SDLRPCParameterNameLength:@123456789,
                                                   SDLRPCParameterNameCRC:@0xffffffff},
                                                    SDLRPCParameterNameOperationName:SDLRPCFunctionNamePutFile}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLPutFile* testRequest = [[SDLPutFile alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.sdlFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal(SDLFileTypeJPEG));
        expect(testRequest.persistentFile).to(equal(@YES));
        expect(testRequest.systemFile).to(equal(@NO));
        expect(testRequest.offset).to(equal(@987654321));
        expect(testRequest.length).to(equal(@123456789));
        expect(testRequest.crc).to(equal(@0xffffffff));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.syncFileName).to(equal(@"fileName"));
#pragma clang diagnostic pop
    });
});

describe(@"When creating a CRC32 checksum for the bulk data", ^{
    it(@"should create a checksum for data", ^{
        NSData *testFileData = [@"Somerandomtextdata" dataUsingEncoding:NSUTF8StringEncoding];
        unsigned long testFileCRC32Checksum = [SDLPutFile sdl_getCRC32ChecksumForBulkData:testFileData];

        expect(testFileCRC32Checksum).to(equal(testFileCRC32Checksum));
    });

    it(@"should not create a checksum if the data is nil", ^{
        NSData *testFileData = nil;
        unsigned long testFileCRC32Checksum = [SDLPutFile sdl_getCRC32ChecksumForBulkData:testFileData];

        expect(testFileCRC32Checksum).to(equal(0));
    });

    it(@"should not create a checksum if the data is empty", ^{
        NSData *testFileData = [NSData data];
        unsigned long testFileCRC32Checksum = [SDLPutFile sdl_getCRC32ChecksumForBulkData:testFileData];

        expect(testFileCRC32Checksum).to(equal(0));
    });
});

describe(@"initializers", ^{
    context(@"init", ^{
        SDLPutFile *testRequest = [[SDLPutFile alloc] init];

        expect(testRequest.sdlFileName).to(beNil());
        expect(testRequest.fileType).to(beNil());
        expect(testRequest.persistentFile).to(beNil());
        expect(testRequest.systemFile).to(beNil());
        expect(testRequest.offset).to(beNil());
        expect(testRequest.length).to(beNil());
        expect(testRequest.crc).to(beNil());
        expect(testRequest.bulkData).to(beNil());

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.syncFileName).to(beNil());
#pragma clang diagnostic pop
    });

    context(@"initWithFileName:fileType:", ^{
        SDLPutFile *testRequest = [[SDLPutFile alloc] initWithFileName:@"fileName" fileType:SDLFileTypeWAV];

        expect(testRequest.sdlFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal(SDLFileTypeWAV));
        expect(testRequest.persistentFile).to(beNil());
        expect(testRequest.systemFile).to(beNil());
        expect(testRequest.offset).to(beNil());
        expect(testRequest.length).to(beNil());
        expect(testRequest.crc).to(beNil());
        expect(testRequest.bulkData).to(beNil());

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.syncFileName).to(equal(@"fileName"));
#pragma clang diagnostic pop
    });

    context(@"initWithFileName:fileType:persistentFile:", ^{
        SDLPutFile* testRequest = [[SDLPutFile alloc] initWithFileName:@"fileName" fileType:SDLFileTypePNG persistentFile:false];

        expect(testRequest.sdlFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal(SDLFileTypePNG));
        expect(testRequest.persistentFile).to(beFalse());
        expect(testRequest.systemFile).to(beNil());
        expect(testRequest.offset).to(beNil());
        expect(testRequest.length).to(beNil());
        expect(testRequest.crc).to(beNil());
        expect(testRequest.bulkData).to(beNil());

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.syncFileName).to(equal(@"fileName"));
#pragma clang diagnostic pop
    });

    context(@"initWithFileName:fileType:persistentFile:systemFile:offset:length:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLPutFile *testRequest = [[SDLPutFile alloc] initWithFileName:@"fileName" fileType:SDLFileTypeMP3 persistentFile:true systemFile:true offset:45 length:34];
#pragma clang diagnostic pop

        expect(testRequest.sdlFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal(SDLFileTypeMP3));
        expect(testRequest.persistentFile).to(beTrue());
        expect(testRequest.systemFile).to(beTrue());
        expect(testRequest.offset).to(equal(@45));
        expect(testRequest.length).to(equal(34));
        expect(testRequest.crc).to(beNil());
        expect(testRequest.bulkData).to(beNil());

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.syncFileName).to(equal(@"fileName"));
#pragma clang diagnostic pop
    });

    context(@"initWithFileName:fileType:persistentFile:systemFile:offset:length:crc:", ^{
        SDLPutFile* testRequest = [[SDLPutFile alloc] initWithFileName:@"fileName" fileType:SDLFileTypeMP3 persistentFile:true systemFile:true offset:45 length:34 crc:0xffffffff];

        expect(testRequest.sdlFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal(SDLFileTypeMP3));
        expect(testRequest.persistentFile).to(beTrue());
        expect(testRequest.systemFile).to(beTrue());
        expect(testRequest.offset).to(equal(@45));
        expect(testRequest.length).to(equal(@34));
        expect(testRequest.crc).to(equal(0xffffffff));
        expect(testRequest.bulkData).to(beNil());

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.syncFileName).to(equal(@"fileName"));
#pragma clang diagnostic pop
    });

    context(@"initWithFileName:fileType:persistentFile:systemFile:offset:length:bulkData:", ^{
        NSData *testFileData = [@"someTextData" dataUsingEncoding:NSUTF8StringEncoding];
        unsigned long testFileCRC32Checksum = [SDLPutFile sdl_getCRC32ChecksumForBulkData:testFileData];

        SDLPutFile* testRequest = [[SDLPutFile alloc] initWithFileName:@"fileName" fileType:SDLFileTypeAAC persistentFile:true systemFile:true offset:5 length:4 bulkData:testFileData];

        expect(testRequest.sdlFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal(SDLFileTypeAAC));
        expect(testRequest.persistentFile).to(beTrue());
        expect(testRequest.systemFile).to(beTrue());
        expect(testRequest.offset).to(equal(@5));
        expect(testRequest.length).to(equal(@4));
        expect(testRequest.bulkData).to(equal(testFileData));
        expect(testRequest.crc).to(equal(testFileCRC32Checksum));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.syncFileName).to(equal(@"fileName"));
#pragma clang diagnostic pop
    });
});

QuickSpecEnd
