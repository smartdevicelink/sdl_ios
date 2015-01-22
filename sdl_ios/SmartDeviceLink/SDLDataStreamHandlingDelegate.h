//
//  SDLDataStreamHandlingDelegate.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>
#import "SDLAbstractProtocol.h"

@interface SDLDataStreamHandlingDelegate : NSObject <NSStreamDelegate>

@property (assign) SDLServiceType serviceType;
@property (strong, nonatomic) SDLAbstractProtocol *protocol;

@end
