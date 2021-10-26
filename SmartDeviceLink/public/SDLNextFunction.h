//
//  SDLNextFunction.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SDLNextFunction) {
    SDLNextFunctionDefault = 0,
    SDLNextFunctionPerformChoiceSet,
    SDLNextFunctionAlert,
    SDLNextFunctionScreenUpdate,
    SDLNextFunctionSpeak,
    SDLNextFunctionAccessMicrophone,
    SDLNextFunctionScrollableMessage,
    SDLNextFunctionSlider,
    SDLNextFunctionSendLocation,
    SDLNextFunctionDialNumber,
    SDLNextFunctionOpenMenu
};
