//  SDLProtocolHeader.m
//


#import "SDLProtocolHeader.h"
#import "SDLV1ProtocolHeader.h"
#import "SDLV2ProtocolHeader.h"

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

- (instancetype)copyWithZone:(NSZone *)zone {
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (NSData *)data {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)parse:(NSData *)data {
    [self doesNotRecognizeSelector:_cmd];
}

- (NSString *)description {
    NSString* description = [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
    return description;
}

+ (SDLProtocolHeader *)headerForVersion:(UInt8)version {
    // TODO: some error handling here if unknown version is asked for,
    // but that needs to be balanced against future proofing. i.e. V3.
    // Requirements around V3 are as yet undefined so give a V2 header
    // lol wat.
    switch (version) {
        case 0: {
            return [[SDLV2ProtocolHeader alloc] initWithVersion:2];
        } break;
        case 1: {
            return [[SDLV1ProtocolHeader alloc] init];
        } break;
        case 2:
        case 3:
        case 4: {
            return [[SDLV2ProtocolHeader alloc] initWithVersion:version];
        } break;
        default: {
            return [[SDLV2ProtocolHeader alloc] initWithVersion:2];
        } break;
    }
}

@end