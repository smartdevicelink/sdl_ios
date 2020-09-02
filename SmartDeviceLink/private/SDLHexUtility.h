//
//  SDLHexUtility.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLHexUtility : NSObject

+ (NSString *)getHexString:(UInt8 *)bytes length:(NSUInteger)length;
+ (NSString *)getHexString:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
