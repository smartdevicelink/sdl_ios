//
//  SDLProtocolReceivedMessageProcessor.h
//  SmartDeviceLink
//
//  Created by George Miller on 7/13/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

//#import "SDLProtocolReceivedMessageRouter.h"
#import <Foundation/Foundation.h>

#import "SDLProtocolHeader.h"
//@class SDLProtocolHeader;

/**
 * Handles decryption and creation of the message from header and payload
 */
typedef void (^StateMachineMessageReadyBlock)(BOOL, SDLProtocolHeader *, NSData *);

/// Class for processing received messages
@interface SDLProtocolReceivedMessageProcessor : NSObject

/**
 * Processes the reveive buffer into the state machine.
 * Loop through the given bytes and call the state machine to process each byte.
 * @param receiveBuffer Holds the incoming bytes from the receive buffer
 * @param messageReadyBlock Passes back a completed protocol message when one has been assembled
 */
-(void)processReceiveBuffer:(NSData *)receiveBuffer withMessageReadyBlock:(StateMachineMessageReadyBlock)messageReadyBlock;

@end
