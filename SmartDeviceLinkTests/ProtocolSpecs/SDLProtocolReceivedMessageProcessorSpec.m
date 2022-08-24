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

@property (assign, nonatomic) UInt8 version;
@property (assign, nonatomic) BOOL encrypted;
@property (assign, nonatomic) SDLFrameType frameType;
@property (assign, nonatomic) UInt32 dataLength;
@property (assign, nonatomic) UInt32 dataBytesRemaining;
@property (assign, nonatomic) SDLServiceType serviceType;
@end

QuickSpecBegin(SDLProtocolReceivedMessageProcessorSpec)

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

    it(@"test processor should be initialized correctly", ^{
        expect(@(testProcessor.state)).to(equal(START_STATE));
        expect(@(testProcessor.version)).to(equal(0));
        expect(@(testProcessor.encrypted)).to(equal(NO));
        expect(@(testProcessor.frameType)).to(equal(SDLFrameTypeControl));
        expect(@(testProcessor.dataLength)).to(equal(0));
        expect(@(testProcessor.dataBytesRemaining)).to(equal(0));
        expect(@(testProcessor.serviceType)).to(equal(SDLServiceTypeControl));
    });
    
    describe(@"when in START_STATE", ^{
        it(@"should transition to next state when receiving version 1", ^{
            Byte testByte = 0x11;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(testProcessor.version).to(equal(1));
                expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
            }];
        });

        it(@"should transition to next state when receiving version 2", ^{
            Byte testByte = 0x21;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(testProcessor.version).to(equal(2));
                expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
            }];
        });

        it(@"should transition to next state when receiving version 3", ^{
            Byte testByte = 0x31;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(testProcessor.version).to(equal(3));
                expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));

            }];
        });

        it(@"should transition to next state when receiving version 4", ^{
            Byte testByte = 0x41;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(testProcessor.version).to(equal(4));
                expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
            }];
        });

        it(@"should transition to next state when receiving version 5", ^{
            Byte testByte = 0x51;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(testProcessor.version).to(equal(5));
                expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
            }];
        });

        it(@"should transition to next state when receiving a byte with a frameType of SDLFrameTypeControl", ^{
            Byte testByte = 0x10;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
            }];
        });

        it(@"should transition to next state when receiving a byte with a frameType of SDLFrameTypeSingle", ^{
            Byte testByte = 0x11;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.frameType)).to(equal(SDLFrameTypeSingle));
            }];
        });

        it(@"should transition to next state when receiving a byte with a frameType of SDLFrameTypeFirst", ^{
            Byte testByte = 0x12;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.frameType)).to(equal(SDLFrameTypeFirst));
            }];
        });

        it(@"should transition to next state when receiving a byte with a frameType of SDLFrameTypeConsecutive", ^{
            Byte testByte = 0x13;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(SERVICE_TYPE_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.frameType)).to(equal(SDLFrameTypeConsecutive));
            }];
        });

        it(@"should reset state when receiving a byte with a bad version 0", ^{
            Byte testByte = 0x01;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(START_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(testProcessor.version).to(equal(0));
                expect(testProcessor.headerBuffer).to(equal([NSMutableData data]));
                expect(testProcessor.payloadBuffer).to(equal([NSMutableData data]));
            }];
        });

        it(@"should reset state when receiving a byte with a bad version 6", ^{
            Byte testByte = 0x61;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(START_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(testProcessor.version).to(equal(0));
                expect(testProcessor.headerBuffer).to(equal([NSMutableData data]));
                expect(testProcessor.payloadBuffer).to(equal([NSMutableData data]));
            }];
        });

        it(@"should reset state when receiving a byte with an invalid frameType of 6", ^{
            Byte testByte = 0x46; //0100 0 110
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(START_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.frameType)).to(equal(0));
                expect(testProcessor.version).to(equal(0));
            }];
        });
    });

    // transitions to CONTROL_FRAME_INFO_STATE when in SERVICE_TYPE_STATE
    describe(@"when in SERVICE_TYPE_STATE", ^{

        beforeEach(^{
            testProcessor.state = SERVICE_TYPE_STATE;
        });

        it(@"should transition to next state when receiving a SDLServiceTypeControl byte", ^{
            Byte testByte = SDLServiceTypeControl;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.serviceType)).to(equal(SDLServiceTypeControl));
            }];
        });

        it(@"should transition to next state when receiving a SDLServiceTypeRPC byte", ^{
            Byte testByte = SDLServiceTypeRPC;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.serviceType)).to(equal(SDLServiceTypeRPC));
            }];
        });

        it(@"should transition to next state when receiving a SDLServiceTypeAudio byte", ^{
            Byte testByte = SDLServiceTypeAudio;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.serviceType)).to(equal(SDLServiceTypeAudio));
            }];
        });

        it(@"should transition to next state when receiving a SDLServiceTypeVideo byte", ^{
            Byte testByte = SDLServiceTypeVideo;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.serviceType)).to(equal(SDLServiceTypeVideo));
            }];
        });

        it(@"should transition to next state when receiving a SDLServiceTypeBulkData byte", ^{
            Byte testByte = SDLServiceTypeBulkData;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(CONTROL_FRAME_INFO_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.serviceType)).to(equal(SDLServiceTypeBulkData));
            }];
        });

        it(@"should reset state when receiving an invalid byte", ^{
            Byte testByte = 0xFF;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(START_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.serviceType)).to(equal(SDLServiceTypeControl));
                expect(testProcessor.headerBuffer).to(equal([NSMutableData data]));
                expect(testProcessor.payloadBuffer).to(equal([NSMutableData data]));
            }];
        });
    });

    describe(@"when in CONTROL_FRAME_INFO_STATE", ^{

        beforeEach(^{
            testProcessor.state = CONTROL_FRAME_INFO_STATE;
        });

        it(@"should transition to next state when receiving a valid byte", ^{
            Byte testByte = 0x00;
            testProcessor.frameType = SDLFrameTypeFirst;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(SESSION_ID_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.frameType)).to(equal(SDLFrameTypeFirst));
            }];
        });

        it(@"should reset state when receiving a byte where controlFrameInfo is not 0 and frameType is SDLFrameTypeFirst", ^{
            Byte testByte = 0x01;
            testProcessor.frameType = SDLFrameTypeFirst;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(START_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.frameType)).to(equal(SDLFrameTypeControl));
                expect(testProcessor.headerBuffer).to(equal([NSMutableData data]));
                expect(testProcessor.payloadBuffer).to(equal([NSMutableData data]));
            }];
        });

        it(@"should resets state when receiving a byte where controlFrameInfo is not 0 and frameType is SDLFrameTypeSingle", ^{
            Byte testByte = 0x01;
            testProcessor.frameType = SDLFrameTypeSingle;
            [testBuffer appendBytes:&testByte length:1];

            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(START_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.frameType)).to(equal(SDLFrameTypeControl));
                expect(testProcessor.headerBuffer).to(equal([NSMutableData data]));
                expect(testProcessor.payloadBuffer).to(equal([NSMutableData data]));
            }];
        });
    });

    it(@"should transition to DATA_SIZE_1_STATE when in SESSION_ID_STATE and receiving a byte", ^{
        testProcessor.state = SESSION_ID_STATE;
        Byte testByte = 0x00;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;
            
            expect(@(testProcessor.state)).to(equal(DATA_SIZE_1_STATE));
            expect(messageReadyHeader).to(beNil());
            expect(messageReadyPayload).to(beNil());
            expect(@(testProcessor.dataLength)).to(equal(0));
        }];
    });

    it(@"should transition to DATA_SIZE_2_STATE when in DATA_SIZE_1_STATE and receiving a byte", ^{
        testProcessor.state = DATA_SIZE_1_STATE;
        Byte testByte = 0x02;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;

            expect(@(testProcessor.state)).to(equal(DATA_SIZE_2_STATE));
            expect(messageReadyHeader).to(beNil());
            expect(messageReadyPayload).to(beNil());
            expect(@(testProcessor.dataLength)).to(equal((UInt32)(testByte & 0xFF) << 24));
        }];
    });

    it(@"should transitions to DATA_SIZE_3_STATE when in DATA_SIZE_2_STATE and receiving a byte", ^{
        testProcessor.state = DATA_SIZE_2_STATE;
        Byte testByte = 0x02;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;

            expect(@(testProcessor.state)).to(equal(DATA_SIZE_3_STATE));
            expect(messageReadyHeader).to(beNil());
            expect(messageReadyPayload).to(beNil());
            expect(@(testProcessor.dataLength)).to(equal((UInt32)(testByte & 0xFF) << 16));
        }];
    });

    it(@"should transition to DATA_SIZE_4_STATE when in DATA_SIZE_3_STATE and receiving a byte", ^{
        testProcessor.state = DATA_SIZE_3_STATE;
        Byte testByte = 0x02;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;

            expect(@(testProcessor.state)).to(equal(DATA_SIZE_4_STATE));
            expect(messageReadyHeader).to(beNil());
            expect(messageReadyPayload).to(beNil());
            expect(@(testProcessor.dataLength)).to(equal((UInt32)(testByte & 0xFF) << 8));
        }];
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

        it(@"should reset state when receiving a byte and determines the data length is 0", ^{
            Byte testByte = 0x00;
            [testBuffer appendBytes:&testByte length:1];
            messageReadyHeader = [SDLProtocolHeader headerForVersion:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(messageReadyHeader).to(equal(expectedMessageReadyHeader));
                expect(messageReadyPayload).to(equal(expectedPayloadBuffer));
                expect(@(testProcessor.dataLength)).to(equal(0));
            }];

            expect(@(testProcessor.state)).to(equal(START_STATE));
            expect(@(testProcessor.version)).to(equal(0));
            expect(testProcessor.headerBuffer).to(equal([NSMutableData data]));
            expect(testProcessor.payloadBuffer).to(equal([NSMutableData data]));
        });

        it(@"should transition to DATA_PUMP_STATE when receiving a byte and determines the data length is greater than 0", ^{
            Byte testByte = 0x01;
            [testBuffer appendBytes:&testByte length:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.dataLength)).to(equal(1));
                expect(@(testProcessor.version)).to(equal(1));
            }];
        });

        it(@"should transition to START_STATE when receiving a byte and determines the data length is greater than maxMtuSize", ^{
            testProcessor.serviceType = SDLServiceTypeControl;
            testProcessor.dataLength = 200000;
            
            Byte testByte = 0x00;
            [testBuffer appendBytes:&testByte length:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(START_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(@(testProcessor.serviceType)).to(equal(0));
                expect(@(testProcessor.dataLength)).to(equal(0));
                expect(@(testProcessor.version)).to(equal(0));
            }];
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

        it(@"should transition to MESSAGE_1_STATE when it receives a byte", ^{
            testProcessor.version = 2;
            testProcessor.dataLength = 0;
            
            Byte testByte = 0x00;
            [testBuffer appendBytes:&testByte length:1];
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(MESSAGE_1_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(testProcessor.version).to(equal(2));
            }];
        });
    });

    it(@"should transition to MESSAGE_2_STATE when in MESSAGE_1_STATE, it receives a byte", ^{
        testProcessor.state = MESSAGE_1_STATE;
        Byte testByte = 0x00;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;

            expect(@(testProcessor.state)).to(equal(MESSAGE_2_STATE));
            expect(messageReadyHeader).to(beNil());
            expect(messageReadyPayload).to(beNil());
        }];
    });

    it(@"should transition to MESSAGE_3_STATE when in MESSAGE_2_STATE and  it receives a byte", ^{
        testProcessor.state = MESSAGE_2_STATE;
        Byte testByte = 0x00;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;

            expect(@(testProcessor.state)).to(equal(MESSAGE_3_STATE));
            expect(messageReadyHeader).to(beNil());
            expect(messageReadyPayload).to(beNil());
        }];
    });

    it(@"should transition to MESSAGE_4_STATE when in MESSAGE_3_STATE and it receives a byte", ^{
        testProcessor.state = MESSAGE_3_STATE;
        Byte testByte = 0x00;
        [testBuffer appendBytes:&testByte length:1];
        
        [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
            messageReadyHeader = header;
            messageReadyPayload = payload;

            expect(@(testProcessor.state)).to(equal(MESSAGE_4_STATE));
            expect(messageReadyHeader).to(beNil());
            expect(messageReadyPayload).to(beNil());
        }];
    });

    describe(@"when in MESSAGE_4_STATE and version is greater than 1", ^{
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

        it(@"should reset state when data length is 0 and receiving a byte", ^{
            testProcessor.dataLength = 0;
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(messageReadyHeader).to(equal(expectedMessageReadyHeader));
                expect(messageReadyPayload).to(equal(expectedPayloadBuffer));
            }];
            expect(testProcessor.version).to(equal(0));
            expect(testProcessor.headerBuffer).to(equal([NSMutableData data]));
            expect(testProcessor.payloadBuffer).to(equal([NSMutableData data]));
            expect(@(testProcessor.state)).to(equal(START_STATE));
        });

        it(@"should transition to DATA_PUMP_STATE when datalength is greater than 0 and receiving a byte", ^{
            testProcessor.dataLength = 1;
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(testProcessor.version).to(equal(2));
            }];
        });
    });

    describe(@"in DATA_PUMP_STATE", ^{
        beforeEach(^{
            testProcessor.state = DATA_PUMP_STATE;
            testProcessor.version = 3;
            //need a valid header buffer.
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

        it(@"should stay in current state when dataBytesRemaining is greater than 1 and receiving a byte", ^{
            testProcessor.dataBytesRemaining = 2;
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(@(testProcessor.state)).to(equal(DATA_PUMP_STATE));
                expect(messageReadyHeader).to(beNil());
                expect(messageReadyPayload).to(beNil());
                expect(testProcessor.dataBytesRemaining).to(equal(1));
                expect(testProcessor.version).to(equal(3));
            }];
        });

        it(@"should transition to START_STATE when dataBytesRemaining is 1 and receiving a byte", ^{
            testProcessor.dataBytesRemaining = 1;
            
            [testProcessor processReceiveBuffer:testBuffer withMessageReadyBlock:^(SDLProtocolHeader *header, NSData *payload) {
                messageReadyHeader = header;
                messageReadyPayload = payload;

                expect(messageReadyHeader).to(equal(expectedMessageReadyHeader));
                expect(messageReadyPayload).to(equal(testBuffer));
                expect(testProcessor.dataBytesRemaining).to(equal(0));
            }];
            expect(@(testProcessor.state)).to(equal(START_STATE));
            expect(testProcessor.version).to(equal(0));
        });
    });
});


QuickSpecEnd
