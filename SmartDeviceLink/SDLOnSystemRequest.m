//  SDLOnSystemRequest.m
//

#import "SDLOnSystemRequest.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnSystemRequest

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnSystemRequest]) {
    }
    return self;
}

- (void)setRequestType:(SDLRequestType)requestType {
    if (requestType != nil) {
        [parameters setObject:requestType forKey:SDLNameRequestType];
    } else {
        [parameters removeObjectForKey:SDLNameRequestType];
    }
}

- (SDLRequestType)requestType {
    NSObject *obj = [parameters objectForKey:SDLNameRequestType];
    return (SDLRequestType)obj;
}

- (void)setUrl:(nullable NSString *)url {
    if (url != nil) {
        [parameters setObject:url forKey:SDLNameURL];
    } else {
        [parameters removeObjectForKey:SDLNameURL];
    }
}

- (nullable NSString *)url {
    return [parameters objectForKey:SDLNameURL];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:SDLNameTimeout];
    } else {
        [parameters removeObjectForKey:SDLNameTimeout];
    }
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

- (void)setFileType:(nullable SDLFileType)fileType {
    if (fileType != nil) {
        [parameters setObject:fileType forKey:SDLNameFileType];
    } else {
        [parameters removeObjectForKey:SDLNameFileType];
    }
}

- (nullable SDLFileType)fileType {
    NSObject *obj = [parameters objectForKey:SDLNameFileType];
    return (SDLFileType)obj;
}

- (void)setOffset:(nullable NSNumber<SDLInt> *)offset {
    if (offset != nil) {
        [parameters setObject:offset forKey:SDLNameOffset];
    } else {
        [parameters removeObjectForKey:SDLNameOffset];
    }
}

- (nullable NSNumber<SDLInt> *)offset {
    return [parameters objectForKey:SDLNameOffset];
}

- (void)setLength:(nullable NSNumber<SDLInt> *)length {
    if (length != nil) {
        [parameters setObject:length forKey:SDLNameLength];
    } else {
        [parameters removeObjectForKey:SDLNameLength];
    }
}

- (nullable NSNumber<SDLInt> *)length {
    return [parameters objectForKey:SDLNameLength];
}

@end

NS_ASSUME_NONNULL_END
