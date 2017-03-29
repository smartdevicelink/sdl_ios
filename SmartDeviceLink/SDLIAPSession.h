//
//  SDLIAPSession.h
//

#import "SDLIAPSessionDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>

@class SDLStreamDelegate;

@interface SDLIAPSession : NSObject

@property (strong, atomic) EAAccessory  * _Nullable accessory;
@property (strong, atomic) NSString * _Nullable protocol;
@property (strong, atomic) EASession * _Nullable easession;
@property (weak) id<SDLIAPSessionDelegate> delegate;
@property (strong, atomic, nullable) SDLStreamDelegate *streamDelegate;

- (instancetype)initWithAccessory:(EAAccessory *)accessory
                      forProtocol:(NSString *)protocol;

- (BOOL)start;
- (void)stop;
- (void)sendData:(NSData *)data;
@end
