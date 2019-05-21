//
//  SDLIAPSession.h
//

#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void (^SessionCompletionHandler)(BOOL success);

@interface SDLIAPSession : NSObject <NSStreamDelegate>

@property (nonatomic, assign) BOOL isInputStreamOpen;
@property (nonatomic, assign) BOOL isOutputStreamOpen;
@property (nullable, strong, nonatomic) EAAccessory *accessory;
@property (nullable, strong, nonatomic) NSString *protocolString;
@property (nullable, strong, nonatomic) EASession *eaSession;
@property (assign, readonly, getter=isStopped) BOOL stopped;

- (instancetype)initWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol;

- (BOOL)start;
- (void)stop;

- (void)startStream:(NSStream *)stream;
- (void)stopStream:(NSStream *)stream;

@end

NS_ASSUME_NONNULL_END
