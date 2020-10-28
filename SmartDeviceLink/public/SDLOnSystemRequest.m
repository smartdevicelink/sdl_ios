//  SDLOnSystemRequest.m
//

#import "SDLOnSystemRequest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnSystemRequest

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnSystemRequest]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithRequestType:(SDLRequestType)requestType {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.requestType = requestType;
    return self;
}

- (instancetype)initWithRequestType:(SDLRequestType)requestType requestSubType:(nullable NSString *)requestSubType url:(nullable NSString *)url timeout:(nullable NSNumber<SDLUInt> *)timeout fileType:(nullable SDLFileType)fileType offset:(nullable NSNumber<SDLUInt> *)offset length:(nullable NSNumber<SDLUInt> *)length {
    self = [self initWithRequestType:requestType];
    if (!self) {
        return nil;
    }
    self.requestSubType = requestSubType;
    self.url = url;
    self.timeout = timeout;
    self.fileType = fileType;
    self.offset = offset;
    self.length = length;
    return self;
}

- (void)setRequestType:(SDLRequestType)requestType {
    [self.parameters sdl_setObject:requestType forName:SDLRPCParameterNameRequestType];
}

- (SDLRequestType)requestType {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameRequestType error:&error];
}

- (void)setRequestSubType:(nullable NSString *)requestSubType {
    [self.parameters sdl_setObject:requestSubType forName:SDLRPCParameterNameRequestSubType];
}

- (nullable NSString *)requestSubType {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameRequestSubType ofClass:NSString.class error:nil];
}

- (void)setUrl:(nullable NSString *)url {
    [self.parameters sdl_setObject:url forName:SDLRPCParameterNameURL];
}

- (nullable NSString *)url {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameURL ofClass:NSString.class error:nil];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    [self.parameters sdl_setObject:timeout forName:SDLRPCParameterNameTimeout];
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTimeout ofClass:NSNumber.class error:nil];
}

- (void)setFileType:(nullable SDLFileType)fileType {
    [self.parameters sdl_setObject:fileType forName:SDLRPCParameterNameFileType];
}

- (nullable SDLFileType)fileType {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameFileType error:nil];
}

- (void)setOffset:(nullable NSNumber<SDLInt> *)offset {
    [self.parameters sdl_setObject:offset forName:SDLRPCParameterNameOffset];
}

- (nullable NSNumber<SDLInt> *)offset {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameOffset ofClass:NSNumber.class error:nil];
}

- (void)setLength:(nullable NSNumber<SDLInt> *)length {
    [self.parameters sdl_setObject:length forName:SDLRPCParameterNameLength];
}

- (nullable NSNumber<SDLInt> *)length {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameLength ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
