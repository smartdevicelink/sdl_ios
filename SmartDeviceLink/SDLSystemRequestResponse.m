//  SDLSystemRequestResponse.m
//


#import "SDLSystemRequestResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSystemRequestResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSystemRequest]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
