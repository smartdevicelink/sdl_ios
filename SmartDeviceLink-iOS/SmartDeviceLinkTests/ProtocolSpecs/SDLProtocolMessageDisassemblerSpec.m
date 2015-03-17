//
//  SDLProtocolMessageDisassemblerSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLProtocolMessageDisassembler.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLNames.h"

QuickSpecBegin(SDLProtocolMessageDisassemblerSpec)

describe(@"Disassemble Tests", ^ {
    it(@"Should assemble the message properly", ^ {
        //Allocate 2000 bytes, and use it as sample data
        const NSUInteger dataLength = 2000;
        char dummyBytes[dataLength];
        
        const char testPayloadHeader[12] = {0x20, 0x55, 0x64, 0x73, 0x12, 0x34, 0x43, 0x21, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
        
        NSMutableData* payloadData = [NSMutableData dataWithBytes:testPayloadHeader length:12];
        [payloadData appendBytes:dummyBytes length:dataLength];
        
        SDLV2ProtocolMessage* testMessage = [[SDLV2ProtocolMessage alloc] init];
        SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
        
        testHeader.frameType = SDLFrameType_Single;
        testHeader.serviceType = SDLServiceType_BulkData;
        testHeader.frameData = SDLFrameData_SingleFrame;
        testHeader.sessionID = 0x84;
        testHeader.bytesInPayload = (UInt32)payloadData.length;
        
        testMessage.header = testHeader;
        testMessage.payload = payloadData;
        
        NSArray* messageList = [SDLProtocolMessageDisassembler disassemble:testMessage withLimit:512];
        
        //Payload length per message
        UInt32 payloadLength = 500;//MTU(512)-header length(12)
        
        const char firstPayload[8] = {(payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF, (payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, ceil(1.0 * payloadData.length / payloadLength)};
        
        SDLProtocolMessage* message = [messageList objectAtIndex:0];
        
        //First frame
        expect(message.payload).to(equal([NSData dataWithBytes:firstPayload length:8]));
        
        expect([NSNumber numberWithInteger:[message header].frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_First]));
        expect([NSNumber numberWithInteger:[message header].serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_BulkData]));
        expect([NSNumber numberWithInteger:[message header].frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_FirstFrame]));
        expect([NSNumber numberWithInteger:[message header].sessionID]).to(equal(@0x84));
        expect([NSNumber numberWithInteger:[message header].bytesInPayload]).to(equal(@8));
        
        NSUInteger offset = 0;
        for (int i = 1; i < messageList.count - 1; i++) {
            message = [messageList objectAtIndex:i];
            
            //Consecutive frames
            expect(message.payload).to(equal([NSData dataWithData:[payloadData subdataWithRange:NSMakeRange(offset, payloadLength)]]));
            
            expect([NSNumber numberWithInteger:[message header].frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Consecutive]));
            expect([NSNumber numberWithInteger:[message header].serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_BulkData]));
            expect([NSNumber numberWithInteger:[message header].frameData]).to(equal([NSNumber numberWithInteger:i]));
            expect([NSNumber numberWithInteger:[message header].sessionID]).to(equal(@0x84));
            expect([NSNumber numberWithInteger:[message header].bytesInPayload]).to(equal([NSNumber numberWithInteger:payloadLength]));
            
            offset += payloadLength;
        }
        
        message = [messageList lastObject];
        
        NSUInteger remaining = payloadData.length - offset;
        
        //Last frame
        expect(message.payload).to(equal([NSData dataWithData:[payloadData subdataWithRange:NSMakeRange(offset, remaining)]]));
        
        expect([NSNumber numberWithInteger:[message header].frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Consecutive]));
        expect([NSNumber numberWithInteger:[message header].serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_BulkData]));
        expect([NSNumber numberWithInteger:[message header].frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_ConsecutiveLastFrame]));
        expect([NSNumber numberWithInteger:[message header].sessionID]).to(equal(@0x84));
        expect([NSNumber numberWithInteger:[message header].bytesInPayload]).to(equal([NSNumber numberWithInteger:remaining]));
    });
});

QuickSpecEnd