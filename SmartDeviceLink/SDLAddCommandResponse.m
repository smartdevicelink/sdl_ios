//  SDLAddCommandResponse.m

#import "SDLAddCommandResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAddCommandResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAddCommand]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
