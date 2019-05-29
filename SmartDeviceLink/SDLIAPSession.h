//
//  SDLIAPSession.h
//

#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface SDLIAPSession : NSObject <NSStreamDelegate>

/**
 *  The accessory with which to open a session.
 */
@property (nullable, strong, nonatomic, readonly) EAAccessory *accessory;

/**
 *  The session created between the app and the accessory.
 */
@property (nullable, strong, nonatomic, readonly) EASession *eaSession;

/**
 *  The unique protocol string used to create the session with the accessory.
 */
@property (nullable, strong, nonatomic, readonly) NSString *protocolString;

/**
 *  Returns whether or not both the input and output streams for the session are closed.
 */
@property (assign, readonly, getter=isStopped) BOOL stopped;

/**
 *  The unique ID assigned to the session between the app and accessory. If no session exists the value will be 0.
 */
@property (assign, nonatomic, readonly) NSUInteger connectionID;

/**
 *  Returns whether the session has open I/O streams.
 */
@property (assign, nonatomic, readonly, getter=isSessionInProgress) BOOL sessionInProgress;

/**
 *  Convenience initializer for setting an accessory and protocol string.
 *
 *  @param accessory    The accessory with which to open a session
 *  @param protocol     The unique protocol string used to create the session with the accessory
 *  @return             A SDLIAPSession object
 */
- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory forProtocol:(NSString *)protocol;

/**
 *  Starts a session.
 */
- (void)startSession;

/**
 *  Stops the current session.
 */
- (void)destroySession;

@end

NS_ASSUME_NONNULL_END
