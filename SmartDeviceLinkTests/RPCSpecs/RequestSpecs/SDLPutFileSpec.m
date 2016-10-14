//
//  SDLPutFileSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFileType.h"
#import "SDLNames.h"
#import "SDLPutFile.h"


QuickSpecBegin(SDLPutFileSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPutFile* testRequest = [[SDLPutFile alloc] init];
        
        testRequest.syncFileName = @"fileName";
        testRequest.fileType = SDLFileTypeJPEG;
        testRequest.persistentFile = @YES;
        testRequest.systemFile = @NO;
        testRequest.offset = @987654321;
        testRequest.length = @123456789;
        
        expect(testRequest.syncFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal(SDLFileTypeJPEG));
        expect(testRequest.persistentFile).to(equal(@YES));
        expect(testRequest.systemFile).to(equal(@NO));
        expect(testRequest.offset).to(equal(@987654321));
        expect(testRequest.length).to(equal(@123456789));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameRequest:
                                           @{SDLNameParameters:
                                                 @{SDLNameSyncFileName:@"fileName",
                                                   SDLNameFileType:SDLFileTypeJPEG,
                                                   SDLNamePersistentFile:@YES,
                                                   SDLNameSystemFile:@NO,
                                                   SDLNameOffset:@987654321,
                                                   SDLNameLength:@123456789},
                                             SDLNameOperationName:SDLNamePutFile}} mutableCopy];
        SDLPutFile* testRequest = [[SDLPutFile alloc] initWithDictionary:dict];
        
        expect(testRequest.syncFileName).to(equal(@"fileName"));
        expect(testRequest.fileType).to(equal(SDLFileTypeJPEG));
        expect(testRequest.persistentFile).to(equal(@YES));
        expect(testRequest.systemFile).to(equal(@NO));
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
