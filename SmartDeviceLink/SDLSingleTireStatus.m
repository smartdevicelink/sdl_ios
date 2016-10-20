//  SDLSingleTireStatus.m
//

#import "SDLSingleTireStatus.h"

#import "SDLNames.h"

@implementation SDLSingleTireStatus

- (void)setStatus:(SDLComponentVolumeStatus)status {
    if (status != nil) {
        [store setObject:status forKey:SDLNameStatus];
    } else {
        [store removeObjectForKey:SDLNameStatus];
    }
}

- (SDLComponentVolumeStatus)status {
    NSObject *obj = [store objectForKey:SDLNameStatus];
    return (SDLComponentVolumeStatus)obj;
}

@end
