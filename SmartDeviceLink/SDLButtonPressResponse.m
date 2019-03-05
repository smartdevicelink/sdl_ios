//
//  SDLButtonPressResponse.m
//

#import "SDLButtonPressResponse.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLButtonPressResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameButtonPress]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
