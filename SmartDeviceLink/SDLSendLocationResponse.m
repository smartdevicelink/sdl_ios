//
//  SDLSendLocationResponse.m
//  SmartDeviceLink-iOS

#import "SDLSendLocationResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSendLocationResponse

- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionNameSendLocation];
    if (!self) {
        return nil;
    }

    return self;
}

@end

NS_ASSUME_NONNULL_END
