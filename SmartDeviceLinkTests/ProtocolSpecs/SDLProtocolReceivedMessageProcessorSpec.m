//
//  SDLProtocolReceivedMessageProcessorSpec.m
//  SmartDeviceLinkTests
//
//  Created by George Miller on 8/9/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLProtocol.h"
#import "SDLProtocolReceivedMessageProcessor.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"

typedef NS_ENUM(NSInteger, ProcessorState) {
    START_STATE = 0x0,
    SERVICE_TYPE_STATE = 0x01,
    CONTROL_FRAME_INFO_STATE = 0x02,
    SESSION_ID_STATE = 0x03,
    DATA_SIZE_1_STATE = 0x04,
    DATA_SIZE_2_STATE = 0x05,
    DATA_SIZE_3_STATE = 0x06,
    DATA_SIZE_4_STATE = 0x07,
    MESSAGE_1_STATE = 0x08,
    MESSAGE_2_STATE = 0x09,
    MESSAGE_3_STATE = 0x0A,
    MESSAGE_4_STATE = 0x0B,
    DATA_PUMP_STATE = 0x0C,
    ERROR_STATE = -1,
};

@interface SDLProtocolReceivedMessageProcessor ()
// State management
@property (assign, nonatomic) ProcessorState state;

// Message assembly state
@property (strong, nonatomic) SDLProtocolHeader *header;
@property (strong, nonatomic) NSMutableData *headerBuffer;
@property (strong, nonatomic) NSMutableData *payloadBuffer;

// Error checking
@property (assign, nonatomic) UInt8 version;
@property (assign, nonatomic) BOOL encrypted;
@property (assign, nonatomic) SDLFrameType frameType;
@property (assign, nonatomic) UInt32 dataLength;
@property (assign, nonatomic) UInt32 dataBytesRemaining;
@property (assign, nonatomic) SDLServiceType serviceType;
@end

QuickSpecBegin(SDLProtocolReceivedMessageProcessorSpec)

// set up all test constants



describe(@"The received message processor", ^{
    __block SDLProtocolReceivedMessageProcessor *testProcessor = nil;
    __block NSMutableData *testBuffer;
    __block NSMutableData *testHeaderBuffer;
    __block SDLProtocolHeader *messageReadyHeader = nil;
    __block SDLProtocolHeader *expectedMessageReadyHeader = nil;
    __block NSData *messageReadyPayload = nil;
    __block NSData *expectedPayloadBuffer = nil;
    
    beforeEach(^{
        testProcessor = [[SDLProtocolReceivedMessageProcessor alloc] init];
        testBuffer = [NSMutableData data];
        testHeaderBuffer = [NSMutableData data];
        messageReadyHeader = nil;
        expectedMessageReadyHeader = nil;
        messageReadyPayload = nil;
    });
    
    //context(@"in START_STATE", ^{
    it(@"transitions to SERVICE_TYPE_STATE when in START_STATE, it receives a byte with a good version 1", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x11;
        [testBuffer appendBytes:&testByte length:1];
        
        expect(messageReadyPayload).toEventually(beNil());
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
            expect(messageReadyPayload).toEventually(beNil());
        }];
        expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(testProcessor.version).toEventually(equal(1));
    });
    it(@"transitions to SERVICE_TYPE_STATE when in START_STATE, it receives a byte with a good version 2", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x21;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
        
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(testProcessor.version).toEventually(equal(2));
    });
    it(@"transitions to SERVICE_TYPE_STATE when in START_STATE, it receives a byte with a good version 3", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x31;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(testProcessor.version).toEventually(equal(3));
    });
    it(@"transitions to SERVICE_TYPE_STATE when in START_STATE, it receives a byte with a good version 4", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x41;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(testProcessor.version).toEventually(equal(4));
    });
    it(@"transitions to SERVICE_TYPE_STATE when in START_STATE, it receives a byte with a good version 5", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x51;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(testProcessor.version).toEventually(equal(5));
    });
    it(@"resets state to START_STATE if the byte is not valid hen in START_STATE, it receives a byte with a bad version 0", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x01;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(START_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(testProcessor.version).toEventually(equal(0));
    });
    it(@"resets state to START_STATE if the byte is not valid when in START_STATE, it receives a byte with a bad version 6", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x61;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(START_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(testProcessor.version).toEventually(equal(0));
    });
    it(@"transitions to SERVICE_TYPE_STATE when in START_STATE, it receives a byte with a frameType of SDLFrameTypeControl", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x10;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
    });
    it(@"transitions to SERVICE_TYPE_STATE when in START_STATE, it receives a byte with a frameType of SDLFrameTypeSingle", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x11;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.frameType)).toEventually(equal(SDLFrameTypeSingle));
    });
    it(@"transitions to SERVICE_TYPE_STATE when in START_STATE, it receives a byte with a frameType of SDLFrameTypeFirst", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x12;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.frameType)).toEventually(equal(SDLFrameTypeFirst));
    });
    it(@"transitions to SERVICE_TYPE_STATE when in START_STATE, it receives a byte with a frameType of SDLFrameTypeConsecutive", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x13;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.frameType)).toEventually(equal(SDLFrameTypeConsecutive));
    });
    it(@"resets state to START_STATE when in START_STATE, it receives a byte with an invalid frameType of 6", ^{
        testProcessor.state = START_STATE;
        Byte testByte = 0x46; //0100 0 110
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(START_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.frameType)).toEventually(equal(0));
        expect(testProcessor.version).toEventually(equal(0));
        
    });
    it(@"transitions to CONTROL_FRAME_INFO_STATE when in SERVICE_TYPE_STATE, it receives a SDLServiceTypeControl byte", ^{
        testProcessor.state = SERVICE_TYPE_STATE;
        Byte testByte = SDLServiceTypeControl;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.serviceType)).toEventually(equal(SDLServiceTypeControl));
    });
    it(@"transitions to CONTROL_FRAME_INFO_STATE when in SERVICE_TYPE_STATE, it receives a SDLServiceTypeRPC byte", ^{
        testProcessor.state = SERVICE_TYPE_STATE;
        Byte testByte = SDLServiceTypeRPC;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.serviceType)).toEventually(equal(SDLServiceTypeRPC));
    });
    it(@"transitions to CONTROL_FRAME_INFO_STATE when in SERVICE_TYPE_STATE, it receives a SDLServiceTypeAudio byte", ^{
        testProcessor.state = SERVICE_TYPE_STATE;
        Byte testByte = SDLServiceTypeAudio;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.serviceType)).toEventually(equal(SDLServiceTypeAudio));
    });
    it(@"transitions to CONTROL_FRAME_INFO_STATE when in SERVICE_TYPE_STATE, it receives a SDLServiceTypeVideo byte", ^{
        testProcessor.state = SERVICE_TYPE_STATE;
        Byte testByte = SDLServiceTypeVideo;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.serviceType)).toEventually(equal(SDLServiceTypeVideo));
    });
    it(@"transitions to CONTROL_FRAME_INFO_STATE when in SERVICE_TYPE_STATE, it receives a SDLServiceTypeBulkData byte", ^{
        testProcessor.state = SERVICE_TYPE_STATE;
        Byte testByte = SDLServiceTypeBulkData;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.serviceType)).toEventually(equal(SDLServiceTypeBulkData));
    });
    it(@"resets state to START_STATE when in SERVICE_TYPE_STATE, it receives a invalid byte", ^{
        testProcessor.state = SERVICE_TYPE_STATE;
        Byte testByte = 0xFF;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(START_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.serviceType)).toEventually(equal(0));
    });
    it(@"transitions to SESSION_ID_STATE when in CONTROL_FRAME_INFO_STATE, it receives a valid byte", ^{
        testProcessor.state = CONTROL_FRAME_INFO_STATE;
        Byte testByte = 0x00;
        testProcessor.frameType = SDLFrameTypeFirst;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(SESSION_ID_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.frameType)).toEventually(equal(SDLFrameTypeFirst));
    });
    it(@"resets to START_STATE when in CONTROL_FRAME_INFO_STATE, it receives a byte where controlFrameInfo is not 0 and frameType is SDLFrameTypeFirst", ^{
        testProcessor.state = CONTROL_FRAME_INFO_STATE;
        Byte testByte = 0x01;
        testProcessor.frameType = SDLFrameTypeFirst;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(START_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.frameType)).toEventually(equal(0x00));
    });
    it(@"resets to START_STATE when in CONTROL_FRAME_INFO_STATE, it receives a byte where controlFrameInfo is not 0 and frameType is SDLFrameTypeSingle", ^{
        testProcessor.state = CONTROL_FRAME_INFO_STATE;
        Byte testByte = 0x01;
        testProcessor.frameType = SDLFrameTypeSingle;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(START_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.frameType)).toEventually(equal(0x00));
    });
    it(@"transitions to DATA_SIZE_1_STATE when in SESSION_ID_STATE, it receives a byte", ^{
        testProcessor.state = SESSION_ID_STATE;
        Byte testByte = 0x00;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(DATA_SIZE_1_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.dataLength)).toEventually(equal(0));
        
    });
    it(@"transitions to DATA_SIZE_2_STATE when in DATA_SIZE_1_STATE, it receives a byte", ^{
        testProcessor.state = DATA_SIZE_1_STATE;
        Byte testByte = 0x02;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(DATA_SIZE_2_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.dataLength)).toEventually(equal((UInt32)(testByte & 0xFF) << 24));
    });
    it(@"transitions to DATA_SIZE_3_STATE when in DATA_SIZE_2_STATE, it receives a byte", ^{
        testProcessor.state = DATA_SIZE_2_STATE;
        Byte testByte = 0x02;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(DATA_SIZE_3_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.dataLength)).toEventually(equal((UInt32)(testByte & 0xFF) << 16));
    });
    it(@"transitions to DATA_SIZE_4_STATE when in DATA_SIZE_3_STATE, it receives a byte", ^{
        testProcessor.state = DATA_SIZE_3_STATE;
        Byte testByte = 0x02;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(DATA_SIZE_4_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
        expect(@(testProcessor.dataLength)).toEventually(equal((UInt32)(testByte & 0xFF) << 8));
    });
    describe(@"when in DATA_SIZE_4_STATE and the version is 1", ^{
        beforeEach(^{
            testProcessor.state = DATA_SIZE_4_STATE;
            testProcessor.version = 1;
            
            messageReadyHeader = nil;
            messageReadyPayload = nil;
            
            //need a valid headerbuffer.
            Byte firstByte = ((testProcessor.version & 0x0f) << 4) + (0 << 3) + (1 & 0x07); //version 2 with no encryption, frametype 1
            UInt32 dataLength = 3;
            const Byte testBytes[8] = {firstByte, 0x00, 0x00, 0x00, (dataLength >> 24) & 0xff, (dataLength >> 16) & 0xff, (dataLength >> 8) & 0xff, (dataLength) & 0xff };
            [testHeaderBuffer appendBytes:&testBytes length:8];
            UInt32 messageID = 0;
            Byte messageIDBytes[4] = {(messageID >> 24) & 0xff, (messageID >> 16) & 0xff, (messageID >> 8) & 0xff, (messageID) & 0xff};
            [testHeaderBuffer appendBytes:&messageIDBytes length:4];
            
            testProcessor.headerBuffer = testHeaderBuffer;
            expectedMessageReadyHeader= [SDLProtocolHeader headerForVersion:testProcessor.version];
            [expectedMessageReadyHeader parse:testHeaderBuffer];
            
            expectedPayloadBuffer = [NSData data];
        });
        it(@"resets state to START_STATE when it receives a byte and determines the data length is 0", ^{

            Byte testByte = 0x00;
            [testBuffer appendBytes:&testByte length:1];
            messageReadyHeader = [SDLProtocolHeader headerForVersion:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;
            }];
            expect(@(testProcessor.state)).to(equal(START_STATE));
            expect(messageReadyHeader).toEventually(equal(expectedMessageReadyHeader));
            expect(messageReadyPayload).toEventually(equal(expectedPayloadBuffer));
            expect(@(testProcessor.dataLength)).toEventually(equal(0));
            expect(@(testProcessor.version)).toEventually(equal(0));
        });
        it(@"transitions to DATA_PUMP_STATE it receives a byte and determines the data length is greater than 0", ^{

            Byte testByte = 0x01;
            [testBuffer appendBytes:&testByte length:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;
            }];
            expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
            expect(messageReadyHeader).toEventually(beNil());
            expect(messageReadyPayload).toEventually(beNil());
            expect(@(testProcessor.dataLength)).toEventually(equal(1));
            expect(@(testProcessor.version)).toEventually(equal(1));
        });
        it(@"transitions to START_STATE when it receives a byte and determines the data length is ggreater than maxMtuSize", ^{
            testProcessor.serviceType = SDLServiceTypeControl;
            testProcessor.dataLength = 200000;
            
            Byte testByte = 0x00;
            [testBuffer appendBytes:&testByte length:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;
            }];
            expect(@(testProcessor.state)).to(equal(START_STATE));
            expect(messageReadyHeader).toEventually(beNil());
            expect(messageReadyPayload).toEventually(beNil());
            expect(@(testProcessor.serviceType)).toEventually(equal(0));
            expect(@(testProcessor.dataLength)).toEventually(equal(0));
            expect(@(testProcessor.version)).toEventually(equal(0));
        });
    });
    describe(@"when in DATA_SIZE_4_STATE and the version is greater than 1", ^{
        beforeEach(^{
            testProcessor.state = DATA_SIZE_4_STATE;
            messageReadyHeader = nil;
            messageReadyPayload = nil;
            
            testProcessor.version = 1;
            //need a valid headerbuffer.
            Byte firstByte = ((testProcessor.version & 0x0f) << 4) + (0 << 3) + (1 & 0x07); //version 2 with no encryption, frametype 1
            UInt32 dataLength = 3;
            const Byte testBytes[8] = {firstByte, 0x00, 0x00, 0x00, (dataLength >> 24) & 0xff, (dataLength >> 16) & 0xff, (dataLength >> 8) & 0xff, (dataLength) & 0xff };
            [testHeaderBuffer appendBytes:&testBytes length:8];
            UInt32 messageID = 0;
            Byte messageIDBytes[4] = {(messageID >> 24) & 0xff, (messageID >> 16) & 0xff, (messageID >> 8) & 0xff, (messageID) & 0xff};
            [testHeaderBuffer appendBytes:&messageIDBytes length:4];
            
            testProcessor.headerBuffer = testHeaderBuffer;
            expectedMessageReadyHeader= [SDLProtocolHeader headerForVersion:testProcessor.version];
            [expectedMessageReadyHeader parse:testHeaderBuffer];
            
            expectedPayloadBuffer = [NSData data];
            
        });
        it(@"transitions to MESSAGE_1_STATE when it receives a byte", ^{
            testProcessor.version = 2;
            testProcessor.dataLength = 0;
            
            Byte testByte = 0x00;
            [testBuffer appendBytes:&testByte length:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;
            }];
            expect(@(testProcessor.state)).to(equal(MESSAGE_1_STATE));
            expect(messageReadyHeader).toEventually(beNil());
            expect(messageReadyPayload).toEventually(beNil());
            expect(testProcessor.version).toEventually(equal(2));
        });
    });
    it(@"transitions to MESSAGE_2_STATE when in MESSAGE_1_STATE, it receives a byte", ^{
        testProcessor.state = MESSAGE_1_STATE;
        Byte testByte = 0x00;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(MESSAGE_2_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
    });
    it(@"transitions to MESSAGE_3_STATE when in MESSAGE_2_STATE, it receives a byte", ^{
        testProcessor.state = MESSAGE_2_STATE;
        Byte testByte = 0x00;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(MESSAGE_3_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
    });
    it(@"transitions to MESSAGE_4_STATE when in MESSAGE_3_STATE, it receives a byte", ^{
        testProcessor.state = MESSAGE_3_STATE;
        Byte testByte = 0x00;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
        }];
        expect(@(testProcessor.state)).to(equal(MESSAGE_4_STATE));
        expect(messageReadyHeader).toEventually(beNil());
        expect(messageReadyPayload).toEventually(beNil());
    });
    describe(@"when in MESSAGE_4_STATE, the version is greater than 1", ^{
        beforeEach(^{
            testProcessor.state = MESSAGE_4_STATE;
            testProcessor.version = 2;
            //need a valid headerbuffer.
            Byte firstByte = ((testProcessor.version & 0x0f) << 4) + (0 << 3) + (1 & 0x07); //version 2 with no encryption, frametype 1
            UInt32 dataLength = 3;
            const Byte testBytes[8] = {firstByte, 0x00, 0x00, 0x00, (dataLength >> 24) & 0xff, (dataLength >> 16) & 0xff, (dataLength >> 8) & 0xff, (dataLength) & 0xff };
            [testHeaderBuffer appendBytes:&testBytes length:8];
            UInt32 messageID = 0;
            Byte messageIDBytes[4] = {(messageID >> 24) & 0xff, (messageID >> 16) & 0xff, (messageID >> 8) & 0xff, (messageID) & 0xff};
            [testHeaderBuffer appendBytes:&messageIDBytes length:4];
            
            testProcessor.headerBuffer = testHeaderBuffer;
            expectedMessageReadyHeader= [SDLProtocolHeader headerForVersion:testProcessor.version];
            [expectedMessageReadyHeader parse:testHeaderBuffer];
            
            expectedPayloadBuffer = [NSData data];
            
            messageReadyHeader = nil;
            messageReadyPayload = nil;
            
            Byte testByte = 0x00;
            [testBuffer appendBytes:&testByte length:1];
        });
        it(@"resets state to START_STATE when datalength is 0 and it recieves a byte", ^{
            testProcessor.dataLength = 0;
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;
            }];
            expect(@(testProcessor.state)).to(equal(START_STATE));
            expect(messageReadyHeader).toEventually(equal(expectedMessageReadyHeader));
            expect(messageReadyPayload).toEventually(equal(expectedPayloadBuffer));
            expect(testProcessor.version).toEventually(equal(0));
        });
        it(@"transitions to DATA_PUMP_STATE when datalength is greater than 0 and it receives a byte", ^{
            testProcessor.dataLength = 1;
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;
            }];
            expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
            expect(messageReadyHeader).toEventually(beNil());
            expect(messageReadyPayload).toEventually(beNil());
            expect(testProcessor.version).toEventually(equal(2));
        });
    });
    describe(@"in DATA_PUMP_STATE", ^{
        beforeEach(^{
            testProcessor.state = DATA_PUMP_STATE;
            testProcessor.version = 3;
            //need a valid headerbuffer.
            Byte firstByte = ((testProcessor.version & 0x0f) << 4) + (0 << 3) + (1 & 0x07); //version 2 with no encryption, frametype 1
            UInt32 dataLength = 3;
            const Byte testBytes[8] = {firstByte, 0x00, 0x00, 0x00, (dataLength >> 24) & 0xff, (dataLength >> 16) & 0xff, (dataLength >> 8) & 0xff, (dataLength) & 0xff };
            [testHeaderBuffer appendBytes:&testBytes length:8];
            UInt32 messageID = 0;
            Byte messageIDBytes[4] = {(messageID >> 24) & 0xff, (messageID >> 16) & 0xff, (messageID >> 8) & 0xff, (messageID) & 0xff};
            [testHeaderBuffer appendBytes:&messageIDBytes length:4];
            
            testProcessor.headerBuffer = testHeaderBuffer;
            expectedMessageReadyHeader= [SDLProtocolHeader headerForVersion:testProcessor.version];
            [expectedMessageReadyHeader parse:testHeaderBuffer];
            
            Byte testByte = 0xBA;
            [testBuffer appendBytes:&testByte length:1];
        });
        it(@"Stays in DATA_PUMP_STATE when dataBytesRemaining is greater than 1 and it receives a byte", ^{
            testProcessor.dataBytesRemaining = 2;
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;
            }];
            expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
            expect(messageReadyHeader).toEventually(beNil());
            expect(messageReadyPayload).toEventually(beNil());
            expect(testProcessor.dataBytesRemaining).toEventually(equal(1));
            expect(testProcessor.version).toEventually(equal(3));
        });
        it(@"transitions to START_STATE when dataBytesRemaining is 1 and it receives a byte", ^{
            testProcessor.dataBytesRemaining = 1;
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;
            }];
            expect(@(testProcessor.state)).to(equal(START_STATE));
            expect(messageReadyHeader).toEventually(equal(expectedMessageReadyHeader));
            expect(messageReadyPayload).toEventually(equal(testBuffer));
            expect(testProcessor.dataBytesRemaining).toEventually(equal(0));
            expect(testProcessor.version).toEventually(equal(0));
        });
    });
});
    

QuickSpecEnd
