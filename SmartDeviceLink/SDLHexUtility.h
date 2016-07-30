//
//  SDLHexUtility.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

@interface SDLHexUtility : NSObject

+ (NSString *)getHexString:(UInt8 *)bytes length:(NSUInteger)length;
+ (NSString *)getHexString:(NSData *)data;

@end
