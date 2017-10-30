//  SDLSingleTireStatus.m
//

#import "SDLSingleTireStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

@implementation SDLSingleTireStatus

- (void)setStatus:(SDLComponentVolumeStatus)status {
    [store sdl_setObject:status forName:SDLNameStatus];
}

- (SDLComponentVolumeStatus)status {
    return [store sdl_objectForName:SDLNameStatus];
}

@end
