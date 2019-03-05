//  SDLSpeakResponse.m
//


#import "SDLSpeakResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSpeakResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSpeak]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
