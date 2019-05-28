//  SDLAlertManeuverResponse.m
//

#import "SDLAlertManeuverResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlertManeuverResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAlertManeuver]) {
    }
    return self;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
