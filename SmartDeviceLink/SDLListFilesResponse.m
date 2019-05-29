//  SDLListFilesResponse.m
//


#import "SDLListFilesResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLListFilesResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameListFiles]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setFilenames:(nullable NSArray<NSString *> *)filenames {
    [self.parameters sdl_setObject:filenames forName:SDLRPCParameterNameFilenames];
}

- (nullable NSArray<NSString *> *)filenames {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameFilenames ofClass:NSString.class error:nil];
}

- (void)setSpaceAvailable:(nullable NSNumber<SDLInt> *)spaceAvailable {
    [self.parameters sdl_setObject:spaceAvailable forName:SDLRPCParameterNameSpaceAvailable];
}

- (nullable NSNumber<SDLInt> *)spaceAvailable {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSpaceAvailable ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
