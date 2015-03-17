//
//  SDLPutFileSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPutFile.h"
#import "SDLNames.h"

QuickSpecBegin(SDLPutFileSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPutFile* testRequest = [[SDLPutFile alloc] init];
        
        testRequest.syncFileName = @"fileName";
        testRequest.fileType = [SDLFileType GRAPHIC_JPEG];
        testRequest.persistentFile = [NSNumber numberWithBool:YES];
        testRequest.systemFile = [NSNumber numberWithBool:NO];
        testRequest.offset = @987654321;
        testRequest.length = @123456789;
        
        expect(testRequest.syncFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal([SDLFileType GRAPHIC_JPEG]));
        expect(testRequest.persistentFile).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.systemFile).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.offset).to(equal(@987654321));
        expect(testRequest.length).to(equal(@123456789));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_syncFileName:@"fileName",
                                                   NAMES_fileType:[SDLFileType GRAPHIC_JPEG],
                                                   NAMES_persistentFile:[NSNumber numberWithBool:YES],
                                                   NAMES_systemFile:[NSNumber numberWithBool:NO],
                                                   NAMES_offset:@987654321,
                                                   NAMES_length:@123456789},
                                             NAMES_operation_name:NAMES_PutFile}} mutableCopy];
        SDLPutFile* testRequest = [[SDLPutFile alloc] initWithDictionary:dict];
        
        expect(testRequest.syncFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal([SDLFileType GRAPHIC_JPEG]));
        expect(testRequest.persistentFile).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.systemFile).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.offset).to(equal(@987654321));
        expect(testRequest.length).to(equal(@123456789));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLPutFile* testRequest = [[SDLPutFile alloc] init];
        
        expect(testRequest.syncFileName).to(beNil());
        expect(testRequest.fileType).to(beNil());
        expect(testRequest.persistentFile).to(beNil());
        expect(testRequest.systemFile).to(beNil());
        expect(testRequest.offset).to(beNil());
        expect(testRequest.length).to(beNil());
    });
});

QuickSpecEnd