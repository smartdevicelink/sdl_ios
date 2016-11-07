//  SDLSingleTireStatus.m
//

#import "SDLSingleTireStatus.h"

#import "SDLNames.h"

@implementation SDLSingleTireStatus

- (void)setStatus:(SDLComponentVolumeStatus)status {
    [self setObject:status forName:SDLNameStatus];
}

- (SDLComponentVolumeStatus)status {
    return [self objectForName:SDLNameStatus];
}

@end
