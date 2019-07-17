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
- (instancetype)initWithId:(UInt32)windowId {
    self = [super initWithName:SDLRPCFunctionNameDeleteWindow];
    if (!self) {
        return nil;
    }
    self.windowID = @(windowId);    
    return self;
}
#pragma clang diagnostic pop

- (void)setWindowID:(NSNumber<SDLInt> *)windowID {
    [self.parameters sdl_setObject:windowID forName:SDLRPCParameterNameWindowId];
}

- (NSNumber<SDLInt> *)windowID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWindowId ofClass:NSNumber.class error:&error];
}

@end
