//  SDLOnSystemRequest.m
//

#import "SDLOnSystemRequest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

@implementation SDLOnSystemRequest

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnSystemRequest]) {
    }
    return self;
}

- (void)setRequestType:(SDLRequestType)requestType {
    [parameters sdl_setObject:requestType forName:SDLNameRequestType];
}

- (SDLRequestType)requestType {
    NSObject *obj = [parameters sdl_objectForName:SDLNameRequestType];
    return (SDLRequestType)obj;
}

- (void)setUrl:(NSString *)url {
    [parameters sdl_setObject:url forName:SDLNameURL];
}

- (NSString *)url {
    return [parameters sdl_objectForName:SDLNameURL];
}

- (void)setTimeout:(NSNumber<SDLInt> *)timeout {
    [parameters sdl_setObject:timeout forName:SDLNameTimeout];
}

- (NSNumber<SDLInt> *)timeout {
    return [parameters sdl_objectForName:SDLNameTimeout];
}

- (void)setFileType:(SDLFileType)fileType {
    [parameters sdl_setObject:fileType forName:SDLNameFileType];
}

- (SDLFileType)fileType {
    NSObject *obj = [parameters sdl_objectForName:SDLNameFileType];
    return (SDLFileType)obj;
}

- (void)setOffset:(NSNumber<SDLInt> *)offset {
    [parameters sdl_setObject:offset forName:SDLNameOffset];
}

- (NSNumber<SDLInt> *)offset {
    return [parameters sdl_objectForName:SDLNameOffset];
}

- (void)setLength:(NSNumber<SDLInt> *)length {
    [parameters sdl_setObject:length forName:SDLNameLength];
}

- (NSNumber<SDLInt> *)length {
    return [parameters sdl_objectForName:SDLNameLength];
}

@end
