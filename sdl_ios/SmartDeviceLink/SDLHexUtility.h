//
//  SDLHexUtility.h
//  SmartDeviceLink
//

@import Foundation;

@interface SDLHexUtility : NSObject

+ (NSString *)getHexString:(UInt8 *)bytes length:(int)length;
+ (NSString *)getHexString:(NSData *)data;

@end
