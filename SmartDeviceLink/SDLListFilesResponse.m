//  SDLListFilesResponse.m
//


#import "SDLListFilesResponse.h"

#import "SDLNames.h"

@implementation SDLListFilesResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameListFiles]) {
    }
    return self;
}

- (void)setFilenames:(NSMutableArray<NSString *> *)filenames {
    if (filenames != nil) {
        [parameters setObject:filenames forKey:SDLNameFilenames];
    } else {
        [parameters removeObjectForKey:SDLNameFilenames];
    }
}

- (NSMutableArray<NSString *> *)filenames {
    return [parameters objectForKey:SDLNameFilenames];
}

- (void)setSpaceAvailable:(NSNumber *)spaceAvailable {
    if (spaceAvailable != nil) {
        [parameters setObject:spaceAvailable forKey:SDLNameSpaceAvailable];
    } else {
        [parameters removeObjectForKey:SDLNameSpaceAvailable];
    }
}

- (NSNumber *)spaceAvailable {
    return [parameters objectForKey:SDLNameSpaceAvailable];
}

@end
