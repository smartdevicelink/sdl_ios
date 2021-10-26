//
//  SDLNextFunctionInfo.m
//  SmartDeviceLink
//

#import "NSMutableDictionary+Store.h"
#import "SDLFunctionID.h"
#import "SDLNextFunctionInfo.h"
#import "SDLRPCParameterNames.h"

@implementation SDLNextFunctionInfo

- (instancetype)initWithNextFunction:(SDLNextFunction)nextFunction loadingText:(NSString *)loadingText {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.nextFunction = nextFunction;
    self.loadingText = loadingText;

    return self;
}

- (void)setNextFunction:(SDLNextFunction)nextFunction {
    SDLRPCFunctionName funcName = [self.class functionNameFromNextFunction:nextFunction];
    [self.store sdl_setObject:funcName forName:SDLRPCParameterNameNextFunctionID];
}

- (SDLNextFunction)nextFunction {
    NSString *name = [self.store sdl_objectForName:SDLRPCParameterNameNextFunctionID ofClass:NSString.class error:nil];
    NSNumber *nexFuncNum = [self.class nextFunctionFromFunctionName:name];
    return [nexFuncNum integerValue];
}

- (void)setLoadingText:(NSString *)loadingText {
    [self.store sdl_setObject:loadingText forName:SDLRPCParameterNameLoadingText];
}

- (NSString *)loadingText {
    return [self.store sdl_objectForName:SDLRPCParameterNameLoadingText ofClass:NSString.class error:nil];
}

- (nullable SDLRPCFunctionName)nextFunctionName {
    return [self.store sdl_objectForName:SDLRPCParameterNameNextFunctionID ofClass:NSString.class error:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p>{nextFunction:%d; nextFunctionName: %@; loadingText: %@}",
            NSStringFromClass([self class]), self, (int)self.nextFunction, self.nextFunctionName, self.loadingText];
}

static NSDictionary<NSNumber *, NSString *> *functionMap = nil;

+ (void)initialize
{
    if (self == [SDLNextFunctionInfo class]) {
        functionMap = @{
            @(SDLNextFunctionDefault) : SDLRPCFunctionNameDefault,
            @(SDLNextFunctionPerformChoiceSet) : SDLRPCFunctionNamePerformChoiceSet,
            @(SDLNextFunctionAlert) : SDLRPCFunctionNameAlert,
            @(SDLNextFunctionScreenUpdate) : SDLRPCFunctionNameScreenUpdate,
            @(SDLNextFunctionSpeak) : SDLRPCFunctionNameSpeak,
            @(SDLNextFunctionAccessMicrophone) : SDLRPCFunctionNameAccessMicrophone,
            @(SDLNextFunctionScrollableMessage) : SDLRPCFunctionNameScrollableMessage,
            @(SDLNextFunctionSlider) : SDLRPCFunctionNameSlider,
            @(SDLNextFunctionSendLocation) : SDLRPCFunctionNameSendLocation,
            @(SDLNextFunctionDialNumber) : SDLRPCFunctionNameDialNumber,
            @(SDLNextFunctionOpenMenu) : SDLRPCFunctionNameOpenMenu,
        };
    }
}

/**
 * convert RPC function name to SDLNextFunction as NSNumber or nil
 */
+ (nullable NSNumber<SDLUInt> *)nextFunctionFromFunctionName:(SDLRPCFunctionName)functionName {
    return [[functionMap allKeysForObject:functionName] firstObject];
}

/**
 * convert next function enum to RPC function name string value
 */
+ (nullable SDLRPCFunctionName)functionNameFromNextFunction:(SDLNextFunction)nextFunction {
    return [functionMap objectForKey:@(nextFunction)];
}

@end
