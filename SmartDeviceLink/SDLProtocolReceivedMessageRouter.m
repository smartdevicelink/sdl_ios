//  SDLProtocolReceivedMessageRouter.m
//

//  This class gets handed the SDLProtocol messages as they are received and decides what happens to them and where they are sent on to.

#import "SDLProtocolReceivedMessageRouter.h"
#import "SDLLogMacros.h"
#import "SDLProtocolMessage.h"
#import "SDLProtocolMessageAssembler.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolReceivedMessageRouter ()

@property (strong, nonatomic) NSMutableDictionary<NSNumber *, SDLProtocolMessageAssembler *> *messageAssemblers;

@end


@implementation SDLProtocolReceivedMessageRouter

- (instancetype)init {
    if (self = [super init]) {
        self.messageAssemblers = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    return self;
}

- (void)handleReceivedMessage:(SDLProtocolMessage *)message {
    SDLFrameType frameType = message.header.frameType;

    switch (frameType) {
        case SDLFrameTypeSingle: {
            [self sdl_dispatchProtocolMessage:message];
        } break;
        case SDLFrameTypeControl: {
            [self sdl_dispatchControlMessage:message];
        } break;
        case SDLFrameTypeFirst: // fallthrough
        case SDLFrameTypeConsecutive: {
            [self sdl_dispatchMultiPartMessage:message];
        } break;
        default: break;
    }
}

- (void)sdl_dispatchProtocolMessage:(SDLProtocolMessage *)message {
    if ([self.delegate respondsToSelector:@selector(onProtocolMessageReceived:)]) {
        [self.delegate onProtocolMessageReceived:message];
    }
}

- (void)sdl_dispatchControlMessage:(SDLProtocolMessage *)message {
    switch (message.header.frameData) {
        case SDLFrameInfoStartServiceACK: {
            if ([self.delegate respondsToSelector:@selector(handleProtocolStartServiceACKMessage:)]) {
                [self.delegate handleProtocolStartServiceACKMessage:message];
            }
        } break;
        case SDLFrameInfoStartServiceNACK: {
            if ([self.delegate respondsToSelector:@selector(handleProtocolStartServiceNAKMessage:)]) {
                [self.delegate handleProtocolStartServiceNAKMessage:message];
            }
        } break;
        case SDLFrameInfoEndServiceACK: {
            if ([self.delegate respondsToSelector:@selector(handleProtocolEndServiceACKMessage:)]) {
                [self.delegate handleProtocolEndServiceACKMessage:message];
            }
        } break;
        case SDLFrameInfoEndServiceNACK: {
            if ([self.delegate respondsToSelector:@selector(handleProtocolStartServiceNAKMessage:)]) {
                [self.delegate handleProtocolEndServiceNAKMessage:message];
            }
        } break;
        case SDLFrameInfoHeartbeat: {
            if ([self.delegate respondsToSelector:@selector(handleHeartbeatForSession:)]) {
                [self.delegate handleHeartbeatForSession:message.header.sessionID];
            }
        } break;
        case SDLFrameInfoHeartbeatACK: {
            if ([self.delegate respondsToSelector:@selector(handleHeartbeatACK)]) {
                [self.delegate handleHeartbeatACK];
            }
        } break;
        case SDLFrameInfoTransportEventUpdate: {
            if ([self.delegate respondsToSelector:@selector(handleTransportEventUpdateMessage:)]) {
                [self.delegate handleTransportEventUpdateMessage:message];
            }
        } break;
        default: break; // Other frame data is possible, but we don't care about them
    }
}

- (void)sdl_dispatchMultiPartMessage:(SDLProtocolMessage *)message {
    // Pass multipart messages to an assembler and call delegate when done.
    NSNumber *sessionID = [NSNumber numberWithUnsignedChar:message.header.sessionID];

    SDLProtocolMessageAssembler *assembler = self.messageAssemblers[sessionID];
    if (assembler == nil) {
        assembler = [[SDLProtocolMessageAssembler alloc] initWithSessionID:message.header.sessionID];
        self.messageAssemblers[sessionID] = assembler;
    }

    SDLMessageAssemblyCompletionHandler completionHandler = ^void(BOOL done, SDLProtocolMessage *assembledMessage) {
        if (done) {
            [self sdl_dispatchProtocolMessage:assembledMessage];
        }
    };
    [assembler handleMessage:message withCompletionHandler:completionHandler];
}

@end

NS_ASSUME_NONNULL_END
