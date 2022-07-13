//
//  SDLProtocolReceivedMessageProcessor.h
//  SmartDeviceLink
//
//  Created by George Miller on 7/13/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import "SDLProtocolReceivedMessageRouter.h"

#ifndef SDLProtocolReceivedMessageProcessor_h
#define SDLProtocolReceivedMessageProcessor_h

typedef NS_ENUM(NSUInteger, stateEnum){
    START_STATE = 0x0,
    SERVICE_TYPE_STATE = 0x02,
    CONTROL_FRAME_INFO_STATE = 0x03,
    SESSION_ID_STATE = 0x04,
    DATA_SIZE_1_STATE = 0x05,
    DATA_SIZE_2_STATE = 0x06,
    DATA_SIZE_3_STATE = 0x07,
    DATA_SIZE_4_STATE = 0x08,
    MESSAGE_1_STATE = 0x09,
    MESSAGE_2_STATE = 0x0A,
    MESSAGE_3_STATE = 0x0B,
    MESSAGE_4_STATE = 0x0C,
    DATA_PUMP_STATE = 0x0D,
    FINISHED_STATE = 0xFF,
    ERROR_STATE = -1,
};

// going to use this to call the router when a message is complete
typedef void (^CompletionBlock)(BOOL, SDLProtocolHeader *, NSData *);

@interface SDLProtocolReceivedMessageProcessor : NSObject{
    //state needs to persist between calls
    stateEnum state;
    
    //used for error checking.  Practically part of state.
    Byte version;
    Boolean encrypted;
    int frameType;
    int dataLength;
    int dataBytesRemaining;
    //UInt8 messageId; // we do not need it for the state machine.
    
    //these will hold our header and payload bytes
    //these also need to persist between calls, so they are global.
    NSMutableData *headerBuffer;
    NSMutableData *payloadBuffer;
}

-(void)stateMachineManager:(NSMutableData *)receiveBuffer withBlock:(CompletionBlock)completionBlock;

@end

#endif /* SDLProtocolProcessMessageByte_h */
