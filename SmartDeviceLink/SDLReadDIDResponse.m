//  SDLReadDIDResponse.m
//


#import "SDLReadDIDResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLDIDResult.h"
#import "SDLNames.h"

@implementation SDLReadDIDResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameReadDID]) {
    }
    return self;
}

- (void)setDidResult:(NSMutableArray<SDLDIDResult *> *)didResult {
    [parameters sdl_setObject:didResult forName:SDLNameDIDResult];
}

- (NSMutableArray<SDLDIDResult *> *)didResult {
    return [parameters sdl_objectsForName:SDLNameDIDResult ofClass:SDLDIDResult.class];
}

@end
