//  SDLListFilesResponse.m
//


#import "SDLListFilesResponse.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLListFilesResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameListFiles]) {
    }
    return self;
}

- (void)setFilenames:(nullable NSMutableArray<NSString *> *)filenames {
    if (filenames != nil) {
        [parameters setObject:filenames forKey:SDLNameFilenames];
    } else {
        [parameters removeObjectForKey:SDLNameFilenames];
    }
}

- (nullable NSMutableArray<NSString *> *)filenames {
    return [parameters objectForKey:SDLNameFilenames];
}

- (void)setSpaceAvailable:(NSNumber<SDLInt> *)spaceAvailable {
    if (spaceAvailable != nil) {
        [parameters setObject:spaceAvailable forKey:SDLNameSpaceAvailable];
    } else {
        [parameters removeObjectForKey:SDLNameSpaceAvailable];
    }
}

- (NSNumber<SDLInt> *)spaceAvailable {
    return [parameters objectForKey:SDLNameSpaceAvailable];
}

@end

NS_ASSUME_NONNULL_END
