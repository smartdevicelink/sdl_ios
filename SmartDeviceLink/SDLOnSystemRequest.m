//  SDLOnSystemRequest.m
//

#import "SDLOnSystemRequest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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
    NSError *error;
    return [parameters sdl_enumForName:SDLNameRequestType error:&error];
}

- (void)setRequestSubType:(nullable NSString *)requestSubType {
    [parameters sdl_setObject:requestSubType forName:SDLNameRequestSubType];
}

- (nullable NSString *)requestSubType {
    return [parameters sdl_objectForName:SDLNameRequestSubType ofClass:NSString.class];
}

- (void)setUrl:(nullable NSString *)url {
    [parameters sdl_setObject:url forName:SDLNameURL];
}

- (nullable NSString *)url {
    return [parameters sdl_objectForName:SDLNameURL ofClass:NSString.class];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    [parameters sdl_setObject:timeout forName:SDLNameTimeout];
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [parameters sdl_objectForName:SDLNameTimeout ofClass:NSNumber.class];
}

- (void)setFileType:(nullable SDLFileType)fileType {
    [parameters sdl_setObject:fileType forName:SDLNameFileType];
}

- (nullable SDLFileType)fileType {
    return [parameters sdl_enumForName:SDLNameFileType];
}

- (void)setOffset:(nullable NSNumber<SDLInt> *)offset {
    [parameters sdl_setObject:offset forName:SDLNameOffset];
}

- (nullable NSNumber<SDLInt> *)offset {
    return [parameters sdl_objectForName:SDLNameOffset ofClass:NSNumber.class];
}

- (void)setLength:(nullable NSNumber<SDLInt> *)length {
    [parameters sdl_setObject:length forName:SDLNameLength];
}

- (nullable NSNumber<SDLInt> *)length {
    return [parameters sdl_objectForName:SDLNameLength ofClass:NSNumber.class];
}

@end

NS_ASSUME_NONNULL_END
