//  SDLSystemRequest.m
//


#import "SDLSystemRequest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSystemRequest

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSystemRequest]) {
    }
    return self;
}
#pragma clang diagnostic pop

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

- (void)setFileName:(nullable NSString *)fileName {
    [self.parameters sdl_setObject:fileName forName:SDLRPCParameterNameFileName];
}

- (nullable NSString *)fileName {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFileName ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
