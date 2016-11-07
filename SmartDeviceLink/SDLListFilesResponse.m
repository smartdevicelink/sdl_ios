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
    [self setObject:filenames forName:SDLNameFilenames];
}

- (NSMutableArray<NSString *> *)filenames {
    return [parameters objectForKey:SDLNameFilenames];
}

- (void)setSpaceAvailable:(NSNumber<SDLInt> *)spaceAvailable {
    [self setObject:spaceAvailable forName:SDLNameSpaceAvailable];
}

- (NSNumber<SDLInt> *)spaceAvailable {
    return [parameters objectForKey:SDLNameSpaceAvailable];
}

@end
