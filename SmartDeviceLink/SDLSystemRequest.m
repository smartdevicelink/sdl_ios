//  SDLSystemRequest.m
//


#import "SDLSystemRequest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSystemRequest

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSystemRequest]) {
    }
    return self;
}

- (instancetype)initWithType:(SDLRequestType)requestType fileName:(nullable NSString *)fileName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.requestType = requestType;
    self.fileName = fileName;

    return self;
}

- (instancetype)initWithProprietaryType:(NSString *)proprietaryType fileName:(nullable NSString *)fileName {
    self = [self init];
    if (!self) { return nil; }

    self.requestType = SDLRequestTypeOEMSpecific;
    self.requestSubType = proprietaryType;
    self.fileName = fileName;

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

- (void)setFileName:(nullable NSString *)fileName {
    [parameters sdl_setObject:fileName forName:SDLRPCParameterNameFilename];
}

- (nullable NSString *)fileName {
    return [parameters sdl_objectForName:SDLRPCParameterNameFilename ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
