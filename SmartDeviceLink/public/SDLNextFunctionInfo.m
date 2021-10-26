//
//  SDLNextFunctionInfo.m
//  SmartDeviceLink
//

#import "SDLFunctionID.h"
#import "SDLNextFunctionInfo.h"
#import "SDLRPCFunctionNames.h"

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

/**
 convert next function enum to RPC function name string value
 */
- (SDLRPCFunctionName)nextFunctionName {
    switch (self.nextFunction) {
        case SDLNextFunctionPerformChoiceSet:
            return SDLRPCFunctionNamePerformChoiceSet;
            break;

        case SDLNextFunctionAlert:
            return SDLRPCFunctionNameAlert;
            break;

        case SDLNextFunctionScreenUpdate:
            return SDLRPCFunctionNameScreenUpdate;
            break;

        case SDLNextFunctionSpeak:
            return SDLRPCFunctionNameSpeak;
            break;

        case SDLNextFunctionAccessMicrophone:
            return SDLRPCFunctionNameAccessMicrophone;
            break;

        case SDLNextFunctionScrollableMessage:
            return SDLRPCFunctionNameScrollableMessage;
            break;

        case SDLNextFunctionSlider:
            return SDLRPCFunctionNameSlider;
            break;

        case SDLNextFunctionSendLocation:
            return SDLRPCFunctionNameSendLocation;
            break;

        case SDLNextFunctionDialNumber:
            return SDLRPCFunctionNameDialNumber;
            break;

        case SDLNextFunctionOpenMenu:
            return SDLRPCFunctionNameOpenMenu;
            break;

        case SDLNextFunctionDefault:
        default:
            break;
    }

    return SDLRPCFunctionNameDefault;
}

- (UInt32)nextFunctionID {
    return (UInt32)[[[SDLFunctionID sharedInstance] functionIdForName:self.nextFunctionName] unsignedIntValue];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) copy = [[[self class] allocWithZone:zone] initWithNextFunction:self.nextFunction loadingText:self.loadingText];
    return copy;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p>{nextFunction:%d; nextFunctionName: %@; loadingText: %@}",
            NSStringFromClass([self class]), self, (int)self.nextFunction, self.nextFunctionName, self.loadingText];
}

@end
