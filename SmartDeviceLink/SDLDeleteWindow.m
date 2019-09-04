//
//  SDLDeleteWindow.m
//  SmartDeviceLink

#import "SDLDeleteWindow.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

@implementation SDLDeleteWindow

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDeleteWindow]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithId:(NSUInteger)windowId {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.windowID = @(windowId);    
    return self;
}

- (void)setWindowID:(NSNumber<SDLUInt> *)windowID {
    [self.parameters sdl_setObject:windowID forName:SDLRPCParameterNameWindowId];
}

- (NSNumber<SDLUInt> *)windowID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWindowId ofClass:NSNumber.class error:&error];
}

@end
