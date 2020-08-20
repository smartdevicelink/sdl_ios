//  SDLDiagnosticMessageResponse.m
//

#import "SDLDiagnosticMessageResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDiagnosticMessageResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDiagnosticMessage]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setMessageDataResult:(nullable NSArray<NSNumber *> *)messageDataResult {
    [self.parameters sdl_setObject:messageDataResult forName:SDLRPCParameterNameMessageDataResult];
}

- (nullable NSArray<NSNumber *> *)messageDataResult {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameMessageDataResult ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
