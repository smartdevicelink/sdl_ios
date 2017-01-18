//
//  SDLIAPSession.h
//

#import "SDLIAPSessionDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>

@class SDLStreamDelegate;

typedef void (^SessionCompletionHandler)(BOOL success);

@interface SDLIAPSession : NSObject

@property (strong, nonatomic) EAAccessory *accessory;
@property (strong, nonatomic) NSString *protocol;
@property (strong, nonatomic) EASession *easession;
@property (weak, nonatomic) id<SDLIAPSessionDelegate> delegate;
@property (strong, nonatomic) SDLStreamDelegate *streamDelegate;

- (instancetype)initWithAccessory:(EAAccessory *)accessory
                      forProtocol:(NSString *)protocol;

- (BOOL)start;
- (void)stop;

@end
