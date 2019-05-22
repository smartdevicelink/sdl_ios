//
//  SDLIAPSession.h
//

#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface SDLIAPSession : NSObject <NSStreamDelegate>

/**
 * The input stream for the session is open when a `NSStreamEventOpenCompleted` event is received for the input stream. The input stream is closed when the stream status is `NSStreamStatusClosed`.
 */
@property (nonatomic, assign) BOOL isInputStreamOpen;

/**
 * The output stream for the session is open when a `NSStreamEventOpenCompleted` event is received for the output stream. The output stream has been closed when the stream status is `NSStreamStatusClosed`.
 */
@property (nonatomic, assign) BOOL isOutputStreamOpen;

/**
 *  The accessory with which to open a session.
 */
@property (nullable, strong, nonatomic) EAAccessory *accessory;

/**
 *  The unique protocol string used to create the session with the accessory.
 */
@property (nullable, strong, nonatomic) NSString *protocolString;

/**
 *  The session created between the app and the accessory.
 */
@property (nullable, strong, nonatomic) EASession *eaSession;

/**
 *  Returns whether or not both the input and output streams for the session are closed.
 */
@property (assign, readonly, getter=isStopped) BOOL stopped;

/**
 *  Convenience initializer for setting an accessory and protocol string.
 *
 *  @param accessory    The accessory with which to open a session
 *  @param protocol     The unique protocol string used to create the session with the accessory
 *  @return             A SDLIAPSession object
 */
- (instancetype)initWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol;

/**
 *  Creates a session with the accessory and protocol string.
 *
 *  @return Whether or not the session was created successfully.
 */
- (BOOL)start;

/**
 *  Stops a session by closing the input and output streams and destroying the session.
 */
- (void)stop;

/**
 *  Opens a stream and schedules it in the run loop.
 *
 *  @param stream The stream to open
 */
- (void)startStream:(NSStream *)stream;

/**
 *  Closes a stream and removes it from the run loop.
 *
 *  @param stream The stream to close
 */
- (void)stopStream:(NSStream *)stream;

@end

NS_ASSUME_NONNULL_END
