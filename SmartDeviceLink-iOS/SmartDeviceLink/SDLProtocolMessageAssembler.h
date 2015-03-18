//  SDLSmartDeviceLinkProtocolMessageAssembler.h
//


#import "SDLProtocolMessage.h"

typedef void (^SDLMessageAssemblyCompletionHandler)(BOOL done, SDLProtocolMessage *assembledMessage);


@interface SDLProtocolMessageAssembler : NSObject

@property (assign, readonly) UInt8 sessionID;
@property (assign) UInt32 frameCount; // number of consecutive frames required for reassembly
@property (assign) UInt32 expectedBytes;
@property (strong) NSMutableDictionary *parts;

- (id)initWithSessionID:(UInt8)sessionID;
- (void)handleMessage:(SDLProtocolMessage *)message withCompletionHandler:(SDLMessageAssemblyCompletionHandler)completionHandler;

@end
