//  SDLAlertManeuverResponse.m
//

#import "SDLAlertManeuverResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlertManeuverResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAlertManeuver]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
