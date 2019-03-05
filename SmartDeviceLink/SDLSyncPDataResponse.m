//  SDLSyncPDataResponse.m
//


#import "SDLSyncPDataResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSyncPDataResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSyncPData]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
