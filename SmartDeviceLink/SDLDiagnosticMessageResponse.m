//  SDLDiagnosticMessageResponse.m
//

#import "SDLDiagnosticMessageResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDiagnosticMessageResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameDiagnosticMessage]) {
    }
    return self;
}

- (void)setMessageDataResult:(NSArray<NSNumber<SDLInt> *> *)messageDataResult {
    [parameters sdl_setObject:messageDataResult forName:SDLNameMessageDataResult];
}

- (NSArray<NSNumber<SDLInt> *> *)messageDataResult {
    return [parameters sdl_objectForName:SDLNameMessageDataResult];
}

@end

NS_ASSUME_NONNULL_END
