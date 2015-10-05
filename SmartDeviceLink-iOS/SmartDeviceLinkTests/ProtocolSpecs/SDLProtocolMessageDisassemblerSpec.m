//
//  SDLProtocolMessageDisassemblerSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLGlobals.h"
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
        
        SDLGlobals *globals = [[SDLGlobals alloc] init];
        globals.maxHeadUnitVersion = 2;
        
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
        
        NSArray* messageList = [SDLProtocolMessageDisassembler disassemble:testMessage withLimit:globals.maxMTUSize];
        
        //Payload length per message
        UInt32 payloadLength = 1012; // v1/2 MTU(1024) - header length(12)
        
        const char firstPayload[8] = {(payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF, (payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, ceil(1.0 * payloadData.length / payloadLength)};
        
        SDLProtocolMessage* message = messageList[0];
        
        //First frame
        expect(message.payload).to(equal([NSData dataWithBytes:firstPayload length:8]));
        
        expect(@(message.header.frameType)).to(equal(@(SDLFrameType_First)));
        expect(@(message.header.serviceType)).to(equal(@(SDLServiceType_BulkData)));
        expect(@(message.header.frameData)).to(equal(@(SDLFrameData_FirstFrame)));
        expect(@(message.header.sessionID)).to(equal(@0x84));
        expect(@(message.header.bytesInPayload)).to(equal(@8));
        
        NSUInteger offset = 0;
        for (int i = 1; i < messageList.count - 1; i++) {
            message = messageList[i];
            
            //Consecutive frames
            expect(message.payload).to(equal([NSData dataWithData:[payloadData subdataWithRange:NSMakeRange(offset, payloadLength)]]));
            
            expect(@(message.header.frameType)).to(equal(@(SDLFrameType_Consecutive)));
            expect(@(message.header.serviceType)).to(equal(@(SDLServiceType_BulkData)));
            expect(@(message.header.frameData)).to(equal(@(i)));
            expect(@(message.header.sessionID)).to(equal(@0x84));
            expect(@(message.header.bytesInPayload)).to(equal(@(payloadLength)));
            
            offset += payloadLength;
        }
        
        message = [messageList lastObject];
        
        NSUInteger remaining = payloadData.length - offset;
        
        //Last frame
        expect(message.payload).to(equal([NSData dataWithData:[payloadData subdataWithRange:NSMakeRange(offset, remaining)]]));
        
        expect(@(message.header.frameType)).to(equal(@(SDLFrameType_Consecutive)));
        expect(@(message.header.serviceType)).to(equal(@(SDLServiceType_BulkData)));
        expect(@(message.header.frameData)).to(equal(@(SDLFrameData_ConsecutiveLastFrame)));
        expect(@(message.header.sessionID)).to(equal(@0x84));
        expect(@(message.header.bytesInPayload)).to(equal(@(remaining)));
    });
});

QuickSpecEnd