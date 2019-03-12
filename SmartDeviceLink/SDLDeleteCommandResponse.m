//  SDLDeleteCommandResponse.m
//


#import "SDLDeleteCommandResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteCommandResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDeleteCommand]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
