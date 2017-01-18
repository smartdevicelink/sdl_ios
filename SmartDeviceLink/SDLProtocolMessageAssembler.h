//  SDLSmartDeviceLinkProtocolMessageAssembler.h
//

#import <Foundation/Foundation.h>

@class SDLProtocolMessage;


typedef void (^SDLMessageAssemblyCompletionHandler)(BOOL done, SDLProtocolMessage *assembledMessage);


@interface SDLProtocolMessageAssembler : NSObject

@property (assign, nonatomic, readonly) UInt8 sessionID;
@property (assign, nonatomic) UInt32 frameCount; // number of consecutive frames required for reassembly
@property (assign, nonatomic) UInt32 expectedBytes;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSData *> *parts;

- (instancetype)initWithSessionID:(UInt8)sessionID;
- (void)handleMessage:(SDLProtocolMessage *)message withCompletionHandler:(SDLMessageAssemblyCompletionHandler)completionHandler;

@end
