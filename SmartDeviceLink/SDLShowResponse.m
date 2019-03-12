//  SDLShowResponse.m
//


#import "SDLShowResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLShowResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameShow]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
