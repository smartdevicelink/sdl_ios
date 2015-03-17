//
//  SDLProtocolMessageAssemblerSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLProtocolMessageAssembler.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLNames.h"

QuickSpecBegin(SDLProtocolMessageAssemblerSpec)

describe(@"HandleMessage Tests", ^ {
    it(@"Should assemble the message properly", ^ {
        const NSUInteger dataLength = 2000;
        
        char dummyBytes[dataLength];
        
        const char testPayloadHeader[12] = {0x20, 0x55, 0x64, 0x73, 0x12, 0x34, 0x43, 0x21, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
        
        NSMutableData* payloadData = [NSMutableData dataWithBytes:testPayloadHeader length:12];
        [payloadData appendBytes:dummyBytes length:dataLength];
        
        SDLV2ProtocolMessage* testMessage = [[SDLV2ProtocolMessage alloc] init];
        SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
        
        //First frame
        testHeader.frameType = SDLFrameType_First;
        testHeader.serviceType = SDLServiceType_BulkData;
        testHeader.frameData = 1;
        testHeader.sessionID = 0x16;
        testHeader.bytesInPayload = 8;
        
        testMessage.header = testHeader;
        
        const char firstPayload[8] = {(payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF, (payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, ceil(payloadData.length / 500.0)};
        testMessage.payload = [NSData dataWithBytes:firstPayload length:8];
        
        SDLProtocolMessageAssembler* assembler = [[SDLProtocolMessageAssembler alloc] initWithSessionID:0x16];
        
        __block BOOL verified = NO;
        
        SDLMessageAssemblyCompletionHandler incompleteHandler = ^void(BOOL done, SDLProtocolMessage* assembledMessage) {
            verified = YES;
            
            expect([NSNumber numberWithBool:done]).to(equal([NSNumber numberWithBool:NO]));
            expect(assembledMessage).to(beNil());
        };
        
        [assembler handleMessage:testMessage withCompletionHandler:incompleteHandler];
        
        expect([NSNumber numberWithBool:verified]).to(beTruthy());
        verified = NO;
        
        testMessage.header.frameType = SDLFrameType_Consecutive;
        testMessage.header.bytesInPayload = 500;
        
        NSUInteger frameNumber = 1;
        NSUInteger offset = 0;
        while ((offset + 500) < payloadData.length) {
            //Consecutive frames
            testMessage.header.frameData = frameNumber;
            testMessage.payload = [payloadData subdataWithRange:NSMakeRange(offset, 500)];
            [assembler handleMessage:testMessage withCompletionHandler:incompleteHandler];
            
            expect([NSNumber numberWithBool:verified]).to(beTruthy());
            verified = NO;
            
            frameNumber++;
            offset += 500;
        }
        
        //Final frame
        testMessage.header.frameData = 0;
        testMessage.payload = [payloadData subdataWithRange:NSMakeRange(offset, payloadData.length - offset)];
        [assembler handleMessage:testMessage withCompletionHandler: ^void(BOOL done, SDLProtocolMessage* assembledMessage) {
            verified = YES;
            
            //At the moment, this test fails because the completion handler is accidentally called twice
            expect([NSNumber numberWithBool:done]).to(equal([NSNumber numberWithBool:YES]));
            
            expect(assembledMessage.payload).to(equal(payloadData));
            expect([NSNumber numberWithInteger:[assembledMessage header].frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Single]));
            expect([NSNumber numberWithInteger:[assembledMessage header].serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_BulkData]));
            expect([NSNumber numberWithInteger:[assembledMessage header].frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_SingleFrame]));
            expect([NSNumber numberWithInteger:[assembledMessage header].sessionID]).to(equal(@0x16));
            expect([NSNumber numberWithInteger:[assembledMessage header].bytesInPayload]).to(equal([NSNumber numberWithInteger:payloadData.length]));
        }];
        
        expect([NSNumber numberWithBool:verified]).to(beTruthy());
    });
});

QuickSpecEnd
