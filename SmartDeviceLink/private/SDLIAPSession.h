//
//  SDLIAPSession.h
//

#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol SDLIAPSessionDelegate <NSObject>

- (void)streamsDidOpen;
- (void)streamsDidEnd;
- (void)streamHasSpaceToWrite;
- (void)streamDidError;
- (void)streamHasBytesAvailable:(NSInputStream *)inputStream;

@end
@interface SDLIAPSession : NSObject <NSStreamDelegate>

/**
 *  Convenience initializer for setting an accessory and protocol string.
 *
 *  @param accessory    The accessory with which to open a session
 *  @param protocol     The unique protocol string used to create the session with the accessory
 *  @return             A SDLIAPSession object
 */
- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory forProtocol:(NSString *)protocol iAPSessionDelegate:(id<SDLIAPSessionDelegate>)iAPSessionDelegate;

// document
- (void) closeSession;

// document
- (void)write:(NSMutableData *) data length: (NSUInteger) length  withCompletionHandler:(void (^)(NSInteger bytesWritten))completionHandler;

/**
 *  The accessory with which to open a session.  Should be refactored to remove need to  make this public
 */
@property (nullable, strong, nonatomic, readonly) EAAccessory *accessory;

/**
 *  The unique protocol string used to create the session with the accessory.
 */
@property (nullable, strong, nonatomic, readonly) NSString *protocolString;

/**
 *  The unique ID assigned to the session between the app and accessory. If no session exists the value will be 0.
 */
@property (assign, nonatomic, readonly) NSUInteger connectionID;

/**
 *  Returns whether the session has open I/O streams.
 */
@property (assign, nonatomic, readonly, getter=isSessionInProgress) BOOL sessionInProgress;

// document
@property(readonly) BOOL hasSpaceAvailable;
@property(readonly) BOOL bothStreamsOpen;
@property(readonly) BOOL isConnected;


@end

NS_ASSUME_NONNULL_END


