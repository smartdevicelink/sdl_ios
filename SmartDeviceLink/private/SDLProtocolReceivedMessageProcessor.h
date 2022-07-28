//
//  SDLProtocolReceivedMessageProcessor.h
//  SmartDeviceLink
//
//  Created by George Miller on 7/13/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//


// going to use this to call the router when a message is complete
typedef void (^StateMachineMessageReadyBlock)(BOOL, SDLProtocolHeader *, NSData *);

@interface SDLProtocolReceivedMessageProcessor : NSObject

@property (strong, nonatomic) NSMutableData *headerBuffer;
@property (strong, nonatomic) NSMutableData *payloadBuffer;

-(void)processReceiveBuffer:(NSData *)receiveBuffer withMessageReadyBlock:(StateMachineMessageReadyBlock)completionBlock;

@end
