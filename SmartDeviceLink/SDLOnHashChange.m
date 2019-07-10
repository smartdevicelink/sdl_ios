//  SDLOnHashChange.m
//


#import "SDLOnHashChange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnHashChange

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnHashChange]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setHashID:(NSString *)hashID {
    [self.parameters sdl_setObject:hashID forName:SDLRPCParameterNameHashId];
}

- (NSString *)hashID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHashId ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
