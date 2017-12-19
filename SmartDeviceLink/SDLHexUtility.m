//
//  SDLHexUtility.m
//  SmartDeviceLink
//

#import "SDLHexUtility.h"

@implementation SDLHexUtility

NS_ASSUME_NONNULL_BEGIN

// Using this function as a fail-safe, because we know this is successful.
+ (NSString *)getHexString:(UInt8 *)bytes length:(NSUInteger)length {
    NSMutableString *ret = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; i++) {
        [ret appendFormat:@"%02X", ((Byte *)bytes)[i]];
    }

    return ret;
}

static inline char itoh(char i) {
    if (i > 9) {
        return 'A' + (i - 10);
    }

    return '0' + i;
}

NSString *getHexString(NSData *data) {
    NSUInteger length;
    unsigned char *buffer, *bytes;

    length = data.length;
    bytes = (unsigned char *)data.bytes;
    buffer = malloc(length * 2);

    for (NSUInteger i = 0; i < length; i++) {
        buffer[i * 2] = (Byte)itoh((bytes[i] >> 4) & 0xF);
        buffer[(i * 2) + 1] = (Byte)itoh(bytes[i] & 0xF);
    }

    NSString *hexString = [[NSString alloc] initWithBytesNoCopy:buffer
                                                         length:length * 2
                                                       encoding:NSASCIIStringEncoding
                                                   freeWhenDone:YES];
    // HAX: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/#//apple_ref/occ/instm/NSString/initWithBytesNoCopy:length:encoding:freeWhenDone:
    // If there is an error allocating the string, we must free the buffer and fall back to the less performant method.
    if (!hexString) {
        free(buffer);
        hexString = [SDLHexUtility getHexString:bytes length:length];
    }

    return hexString;
}

+ (NSString *)getHexString:(NSData *)data {
    return getHexString(data);
}


@end

NS_ASSUME_NONNULL_END
