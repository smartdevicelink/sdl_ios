//
//  SDLDebugToolConsole.h
//  SmartDeviceLink-iOS

#import <Foundation/Foundation.h>

@protocol SDLDebugToolConsole <NSObject>

@required
- (void)logInfo:(NSString *)info;

@end
