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

- (BOOL)compressed {
    return _encrypted;
}

- (void)setCompressed:(BOOL)compressed {
    _encrypted = compressed;
}

- (id)copyWithZone:(NSZone *)zone {
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
        case 4: {
            return [[SDLV2ProtocolHeader alloc] initWithVersion:version];
        } break;
        default: {
            NSString *reason = [NSString stringWithFormat:@"The version of header that is being created is unknown: %@", @(version)];
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:@{ @"requestedVersion": @(version) }];
        } break;
    }
}

@end
