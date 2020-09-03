//  SDLDeleteFileResponse.m
//


#import "SDLDeleteFileResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteFileResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDeleteFile]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setSpaceAvailable:(nullable NSNumber<SDLInt> *)spaceAvailable {
    [self.parameters sdl_setObject:spaceAvailable forName:SDLRPCParameterNameSpaceAvailable];
}

- (nullable NSNumber<SDLInt> *)spaceAvailable {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSpaceAvailable ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
