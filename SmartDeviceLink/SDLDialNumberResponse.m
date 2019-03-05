//
//  SDLDialNumberResponse.m
//  SmartDeviceLink-iOS

#import "SDLDialNumberResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDialNumberResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDialNumber]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
