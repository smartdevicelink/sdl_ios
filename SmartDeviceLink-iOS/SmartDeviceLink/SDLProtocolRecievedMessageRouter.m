//  SDLProtocolRecievedMessageRouter.m
//

//  This class gets handed the SDLProtocol messages as they are recieved and decides what happens to them and where they are sent on to.

#import "SDLProtocolRecievedMessageRouter.h"
#import "SDLProtocolMessage.h"
#import "SDLProtocolMessageAssembler.h"
#import "SDLDebugTool.h"



@interface SDLProtocolRecievedMessageRouter ()

@property (assign) BOOL alreadyDestructed;
@property (strong) NSMutableDictionary *messageAssemblers;

- (void)dispatchProtocolMessage:(SDLProtocolMessage *)message;
- (void)dispatchControlMessage:(SDLProtocolMessage *)message;
- (void)dispatchMultiPartMessage:(SDLProtocolMessage *)message;

@end


@implementation SDLProtocolRecievedMessageRouter

- (id)init {
    if (self = [super init]) {
        _alreadyDestructed = NO;
        self.messageAssemblers = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    return self;
}

- (void)handleRecievedMessage:(SDLProtocolMessage *)message {

    SDLFrameType frameType = message.header.frameType;

    switch (frameType) {
        case SDLFrameType_Single:
            [self dispatchProtocolMessage:message];
            break;

        case SDLFrameType_Control:
            [self dispatchControlMessage:message];
            break;

        case SDLFrameType_First:
        case SDLFrameType_Consecutive:
            [self dispatchMultiPartMessage:message];
            break;

        default:
            break;
    }

}

- (void)dispatchProtocolMessage:(SDLProtocolMessage *)message {
    [self.delegate onProtocolMessageReceived:message];
}

- (void)dispatchControlMessage:(SDLProtocolMessage *)message {

    if (message.header.frameData == SDLFrameData_StartSessionACK) {
        [self.delegate handleProtocolSessionStarted:message.header.serviceType
                                          sessionID:message.header.sessionID
                                            version:message.header.version];
    }
}

- (void)dispatchMultiPartMessage:(SDLProtocolMessage *)message {

    // Pass multipart messages to an assembler and call delegate when done.
    NSNumber *sessionID = [NSNumber numberWithUnsignedChar:message.header.sessionID];

    SDLProtocolMessageAssembler *assembler = self.messageAssemblers[sessionID];
    if (assembler == nil) {
        assembler = [[SDLProtocolMessageAssembler alloc] initWithSessionID:message.header.sessionID];
        self.messageAssemblers[sessionID] = assembler;
    }

    SDLMessageAssemblyCompletionHandler completionHandler = ^void(BOOL done, SDLProtocolMessage *assembledMessage) {
        if (done) {
            [self dispatchProtocolMessage:assembledMessage];
        }
    };
    [assembler handleMessage:message withCompletionHandler:completionHandler];

}

- (void)destructObjects {
    if(!self.alreadyDestructed) {
        self.alreadyDestructed = YES;
        self.delegate = nil;
    }
}

- (void)dispose {
    [self destructObjects];
}

- (void)dealloc {
    [self destructObjects];
}

@end
