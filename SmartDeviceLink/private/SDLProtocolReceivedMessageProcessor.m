//
//  SDLProtocolProcessMessageByte.m
//  SmartDeviceLink
//
//  Created by George Miller on 7/13/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import "SDLProtocolReceivedMessageProcessor.h"

#import "SDLLogMacros.h"
#import "SDLProtocolReceivedMessageRouter.h"

typedef NS_ENUM(NSUInteger, ProcessorState) {
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

@interface SDLProtocolReceivedMessageProcessor(){}
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
@end

@implementation SDLProtocolReceivedMessageProcessor

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _version = 0;
    _encrypted = NO;
    _frameType = 0x00;
    _dataLength = 0;
    _dataBytesRemaining = 0;

    [self resetState];
    return self;
}

- (void)resetState {
    // Flush Buffers
    _headerBuffer = [NSMutableData data];
    _payloadBuffer = [NSMutableData data];
    _dataBytesRemaining = 0;
    
    // Reset state
    _state = START_STATE;
}


- (void)processReceiveBuffer:(NSData *)receiveBuffer withMessageReadyBlock:(StateMachineMessageReadyBlock)messageReadyBlock {
    const BytePtr bytes = (BytePtr)receiveBuffer.bytes;
    BOOL messageIsComplete = NO;
    for (int i = 0; i < receiveBuffer.length; i++) {
        // If we have reached the end of a message, we need to immediately call the message ready block with the completed data, then reset the buffers and keep pumping data into the state machine
        messageIsComplete = [self sdl_processByte:(Byte)bytes[i]];
        if (messageIsComplete) {
            messageReadyBlock(_header, [self.payloadBuffer copy]);
            [self resetState];
        }
    }
}

/// This is the state machine. It processes a single byte of a message, checks for errors, and builds up a header buffer and a payload buffer.
/// When the header and payload are complete, this returns true to notify the calling funciton.
/// For reference: https://smartdevicelink.com/en/guides/sdl-overview-guides/protocol-spec/
/// If a byte comes in that does not conform to spec, the buffers are flushed and state is reset.
/// @param currentByte The byte currently being processed
/// @return YES if the byte processed is the last byte of a message, else NO
- (BOOL)sdl_processByte:(Byte)currentByte {
    SDLServiceType serviceType = 0x00;
    SDLFrameInfo controlFrameInfo = 0x00;
    BOOL messageHasEnded = NO;
    
    switch (self.state) {
        case START_STATE:
            [self resetState];
            
            // bits 0-3 for version. (b1111 0000)
            self.version = (currentByte & 0xF0 ) >> 4;

            // bit 4 for either encryption or compression, depending on version. (b0000 1000)
            if ((currentByte & 0x08 ) >> 3 == 1) {
                self.encrypted = YES;
            } else {
                self.encrypted = NO;
            }
            
            // bits 5-7 for frameType. (b0000 0111)
            self.frameType = (currentByte & 0x07) >> 0;

            self.state = SERVICE_TYPE_STATE;
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            if ((self.version < 1 || self.version > 5)) {
                self.state = ERROR_STATE;
                SDLLogD(@"Message Version is out of spec");
                break;
            }
            
            if ((self.frameType < SDLFrameTypeControl) || (self.frameType > SDLFrameTypeConsecutive)) {
                self.state = ERROR_STATE;
                SDLLogD(@"Message frameType is out of spec");
            }
            break;
            
        case SERVICE_TYPE_STATE:
            // 8 bits for service type
            serviceType = currentByte;
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            // ServiceType must be one of the defined types, else error.
            switch (serviceType) {
                case SDLServiceTypeControl:
                case SDLServiceTypeRPC:
                case SDLServiceTypeAudio:
                case SDLServiceTypeVideo:
                case SDLServiceTypeBulkData:
                    self.state = CONTROL_FRAME_INFO_STATE;
                    break;
                default:
                    self.state = ERROR_STATE;
                    SDLLogD(@"Message serviceType is out of spec");
                    break;
            }
            break;
            
        case CONTROL_FRAME_INFO_STATE:
            // 8 bits for frame information
            controlFrameInfo = currentByte;
            self.state = SESSION_ID_STATE;
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            // Check for errors. For these two frame types, the frame info should be 0x00
            if (((self.frameType == SDLFrameTypeFirst) || (self.frameType == SDLFrameTypeSingle)) && (controlFrameInfo != 0x00)){
                self.state = ERROR_STATE;
                SDLLogD(@"Message frameType is out of spec");
            }
            break;
            
        case SESSION_ID_STATE:
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            self.state = DATA_SIZE_1_STATE;
            break;
        
        // 32 bits for data size
        case DATA_SIZE_1_STATE:
            self.dataLength = 0;
            self.dataLength += (UInt32)(currentByte & 0xFF) << 24;
            self.state = DATA_SIZE_2_STATE;
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
            
        case DATA_SIZE_2_STATE:
            self.dataLength += (UInt32)(currentByte & 0xFF) << 16;
            self.state = DATA_SIZE_3_STATE;
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
            
        case DATA_SIZE_3_STATE:
            self.dataLength += (UInt32)(currentByte & 0xFF) << 8;
            self.state = DATA_SIZE_4_STATE;
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
            
        case DATA_SIZE_4_STATE:
            self.dataLength += (UInt32)(currentByte & 0xFF) << 0;
            self.state = MESSAGE_1_STATE;
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            // Set the counter for the data pump.
            self.dataBytesRemaining = self.dataLength;
            
            // Version 1 does not have a message ID so we skip to the data pump or the end.
            if (self.version == 1) {
                if (self.dataLength == 0) {
                    [self resetState];
                } else {
                    self.state = DATA_PUMP_STATE;
                }
            }
            
            Byte headerSize = 0;
            if (self.version == 1) {
                headerSize = 8;
            } else {
                headerSize = 12;
            }
            
            UInt32 maxMtuSize = 0;
            if (self.version <= 2) {
                maxMtuSize = 1500;
            } else {
                maxMtuSize = 131084;
            }
            
            // Error if the data length is greater than the MTU size for this version
            if (self.dataLength >= (maxMtuSize - headerSize)) {
                self.state = ERROR_STATE;
                SDLLogD(@"Data length exceeds MTU size");
                break;
            }
            
            // If this is the first frame, it is not encrypted, and the length is not 8 then error.
            if ((self.frameType == SDLFrameTypeFirst) && (self.dataLength != 8) && (self.encrypted == NO)) {
                self.state = ERROR_STATE;
                SDLLogD(@"Data length may not exceed 8 for non encrypted first frame");
                break;
            }
            
            break;
            
        // 32 bits for data size (version 2+)
        case MESSAGE_1_STATE:
            self.state = MESSAGE_2_STATE;
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
            
        case MESSAGE_2_STATE:
            self.state = MESSAGE_3_STATE;
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
            
        case MESSAGE_3_STATE:
            self.state = MESSAGE_4_STATE;
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
            
        case MESSAGE_4_STATE:
            if (self.dataLength == 0) {
                [self resetState];
                break;
            } else {
                self.state = DATA_PUMP_STATE;
            }
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            break;
        
        case DATA_PUMP_STATE:
            // The pump state takes bytes in and adds them to the payload array
            // Note that we do not set state here. If we are pumping, state will not change. If we are done pumping, we return the messageHasEnded and state will be reset externally.
            [self.payloadBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            self.dataBytesRemaining--;
            
            // If all the bytes have been read, then parse the header into an object and return the end of message
            if (self.dataBytesRemaining <= 0) {
                self.header = [SDLProtocolHeader headerForVersion:self.version];
                [self.header parse:self.headerBuffer];
                messageHasEnded = YES;
            }
            break;
            
        case ERROR_STATE:
        default:
            [self resetState];
            break;
    }
    
    return messageHasEnded;
}

@end
