//
//  SDLDebugToolConsole.h
//  SmartDeviceLink-iOS

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLDebugToolConsole <NSObject>

@required
- (void)logInfo:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
