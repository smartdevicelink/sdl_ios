//
//  SDLIAPSession.h
//

#import "SDLIAPSessionDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>

@class SDLStreamDelegate;

typedef void (^SessionCompletionHandler)(BOOL success);

@interface SDLIAPSession : NSObject

@property (strong, atomic) EAAccessory *accessory;
@property (strong, atomic) NSString *protocol;
@property (strong, atomic) EASession *easession;
@property (weak) id<SDLIAPSessionDelegate> delegate;
@property (strong, atomic) SDLStreamDelegate *streamDelegate;

- (instancetype)initWithAccessory:(EAAccessory *)accessory
                      forProtocol:(NSString *)protocol;

- (BOOL)start;
- (void)stop;

@end
