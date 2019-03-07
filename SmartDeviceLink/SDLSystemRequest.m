//  SDLSystemRequest.m
//


#import "SDLSystemRequest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSystemRequest

- (instancetype)init {
    if (self = [super initWithName:SDLNameSystemRequest]) {
    }
    return self;
}

- (instancetype)initWithType:(SDLRequestType)requestType fileName:(nullable NSString *)fileName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.requestType = requestType;
    self.fileName = fileName;

    return self;
}

- (instancetype)initWithProprietaryType:(NSString *)proprietaryType fileName:(nullable NSString *)fileName {
    self = [self init];
    if (!self) { return nil; }

    self.requestType = SDLRequestTypeOEMSpecific;
    self.requestSubType = proprietaryType;
    self.fileName = fileName;

    return self;
}

- (void)setRequestType:(SDLRequestType)requestType {
    [parameters sdl_setObject:requestType forName:SDLNameRequestType];
}

- (SDLRequestType)requestType {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameRequestType error:&error];
}

- (void)setRequestSubType:(nullable NSString *)requestSubType {
    [parameters sdl_setObject:requestSubType forName:SDLNameRequestSubType];
}

- (nullable NSString *)requestSubType {
    return [parameters sdl_objectForName:SDLNameRequestSubType ofClass:NSString.class];
}

- (void)setFileName:(nullable NSString *)fileName {
    [parameters sdl_setObject:fileName forName:SDLNameFilename];
}

- (nullable NSString *)fileName {
    return [parameters sdl_objectForName:SDLNameFilename ofClass:NSString.class];
}

@end

NS_ASSUME_NONNULL_END
