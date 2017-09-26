//  SDLProtocolHeader.m
//


#import "SDLProtocolHeader.h"
#import "SDLV1ProtocolHeader.h"
#import "SDLV2ProtocolHeader.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLProtocolHeader

@synthesize version = _version;
@synthesize size = _size;


- (instancetype)init {
    if (self = [super init]) {
        _version = 0;
        _size = 0;
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (nullable NSData *)data {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)parse:(NSData *)data {
    [self doesNotRecognizeSelector:_cmd];
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
    return description;
}

+ (__kindof SDLProtocolHeader *)headerForVersion:(UInt8)version {
    // VERSION DEPENDENT CODE
    switch (version) {
        case 1: {
            return [[SDLV1ProtocolHeader alloc] init];
        } break;
        case 2: // Fallthrough
        case 3: // Fallthrough
        case 4: // Fallthrough
        case 5: {
            return [[SDLV2ProtocolHeader alloc] initWithVersion:version];
        } break;
        default: {
            // Assume V2 header for unknown header versions and hope it doesn't break
            return [[SDLV2ProtocolHeader alloc] initWithVersion:version];
        } break;
    }
}

// For use in decoding a stream of bytes.
// Pass in bytes representing message (or beginning of message)
// Looks at and parses first byte to determine version.
+ (UInt8)determineVersion:(NSData *)data {
    UInt8 firstByte = ((UInt8 *)data.bytes)[0];
    UInt8 version = firstByte >> 4;
    return version;
}

@end

NS_ASSUME_NONNULL_END
