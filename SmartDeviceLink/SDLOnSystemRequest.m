//  SDLOnSystemRequest.m
//

#import "SDLOnSystemRequest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnSystemRequest

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnSystemRequest]) {
    }
    return self;
}

- (void)setRequestType:(SDLRequestType)requestType {
    [parameters sdl_setObject:requestType forName:SDLRPCParameterNameRequestType];
}

- (SDLRequestType)requestType {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameRequestType error:&error];
}

- (void)setRequestSubType:(nullable NSString *)requestSubType {
    [parameters sdl_setObject:requestSubType forName:SDLRPCParameterNameRequestSubType];
}

- (nullable NSString *)requestSubType {
    return [parameters sdl_objectForName:SDLRPCParameterNameRequestSubType ofClass:NSString.class error:nil];
}

- (void)setUrl:(nullable NSString *)url {
    [parameters sdl_setObject:url forName:SDLRPCParameterNameURL];
}

- (nullable NSString *)url {
    return [parameters sdl_objectForName:SDLRPCParameterNameURL ofClass:NSString.class error:nil];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    [parameters sdl_setObject:timeout forName:SDLRPCParameterNameTimeout];
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [parameters sdl_objectForName:SDLRPCParameterNameTimeout ofClass:NSNumber.class error:nil];
}

- (void)setFileType:(nullable SDLFileType)fileType {
    [parameters sdl_setObject:fileType forName:SDLRPCParameterNameFileType];
}

- (nullable SDLFileType)fileType {
    return [parameters sdl_enumForName:SDLRPCParameterNameFileType error:nil];
}

- (void)setOffset:(nullable NSNumber<SDLInt> *)offset {
    [parameters sdl_setObject:offset forName:SDLRPCParameterNameOffset];
}

- (nullable NSNumber<SDLInt> *)offset {
    return [parameters sdl_objectForName:SDLRPCParameterNameOffset ofClass:NSNumber.class error:nil];
}

- (void)setLength:(nullable NSNumber<SDLInt> *)length {
    [parameters sdl_setObject:length forName:SDLRPCParameterNameLength];
}

- (nullable NSNumber<SDLInt> *)length {
    return [parameters sdl_objectForName:SDLRPCParameterNameLength ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
