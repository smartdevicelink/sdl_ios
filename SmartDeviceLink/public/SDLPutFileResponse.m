//  SDLPutFileResponse.m
//


#import "SDLPutFileResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPutFileResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNamePutFile]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithSpaceAvailable:(nullable NSNumber<SDLUInt> *)spaceAvailable {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.spaceAvailable = spaceAvailable;
    return self;
}

- (void)setSpaceAvailable:(nullable NSNumber<SDLInt> *)spaceAvailable {
    [self.parameters sdl_setObject:spaceAvailable forName:SDLRPCParameterNameSpaceAvailable];
}

- (nullable NSNumber<SDLInt> *)spaceAvailable {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSpaceAvailable ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
