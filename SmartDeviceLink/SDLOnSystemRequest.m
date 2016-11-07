//  SDLOnSystemRequest.m
//

#import "SDLOnSystemRequest.h"

#import "SDLNames.h"

@implementation SDLOnSystemRequest

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnSystemRequest]) {
    }
    return self;
}

- (void)setRequestType:(SDLRequestType)requestType {
    [self setObject:requestType forName:SDLNameRequestType];
}

- (SDLRequestType)requestType {
    NSObject *obj = [parameters objectForKey:SDLNameRequestType];
    return (SDLRequestType)obj;
}

- (void)setUrl:(NSString *)url {
    [self setObject:url forName:SDLNameURL];
}

- (NSString *)url {
    return [parameters objectForKey:SDLNameURL];
}

- (void)setTimeout:(NSNumber<SDLInt> *)timeout {
    [self setObject:timeout forName:SDLNameTimeout];
}

- (NSNumber<SDLInt> *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

- (void)setFileType:(SDLFileType)fileType {
    [self setObject:fileType forName:SDLNameFileType];
}

- (SDLFileType)fileType {
    NSObject *obj = [parameters objectForKey:SDLNameFileType];
    return (SDLFileType)obj;
}

- (void)setOffset:(NSNumber<SDLInt> *)offset {
    [self setObject:offset forName:SDLNameOffset];
}

- (NSNumber<SDLInt> *)offset {
    return [parameters objectForKey:SDLNameOffset];
}

- (void)setLength:(NSNumber<SDLInt> *)length {
    [self setObject:length forName:SDLNameLength];
}

- (NSNumber<SDLInt> *)length {
    return [parameters objectForKey:SDLNameLength];
}

@end
