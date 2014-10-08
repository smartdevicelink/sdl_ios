//
//  SDLHexUtility.m
//  SmartDeviceLink
//

#import "SDLHexUtility.h"

@implementation SDLHexUtility

+ (NSString*)getHexString:(UInt8 *)bytes length:(int)length {
	NSMutableString* ret = [NSMutableString stringWithCapacity:(length * 2)];
	for (int i = 0; i < length; i++) {
		[ret appendFormat:@"%02X", ((Byte*)bytes)[i]];
	}
	return ret;
}

+ (NSString *)getHexString:(NSData *)data {
	return [self getHexString:(Byte*)data.bytes length:(int)data.length];
}


@end
