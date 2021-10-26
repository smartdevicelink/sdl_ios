//
//  SDLNextFunctionObject.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

@class SDLNextFunctionInfo;

NS_ASSUME_NONNULL_BEGIN

@interface SDLNextFunctionObject : NSObject

@property (nullable, copy, nonatomic) SDLNextFunctionInfo *nextFunctionInfo;

@end

NS_ASSUME_NONNULL_END
