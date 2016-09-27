//  SDLTextField.m
//

#import "SDLTextField.h"

#import "SDLCharacterSet.h"
#import "SDLNames.h"
#import "SDLTextFieldName.h"


@implementation SDLTextField

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setName:(SDLTextFieldName *)name {
    if (name != nil) {
        [store setObject:name forKey:SDLNameName];
    } else {
        [store removeObjectForKey:SDLNameName];
    }
}

- (SDLTextFieldName *)name {
    NSObject *obj = [store objectForKey:SDLNameName];
    if (obj == nil || [obj isKindOfClass:SDLTextFieldName.class]) {
        return (SDLTextFieldName *)obj;
    } else {
        return [SDLTextFieldName valueOf:(NSString *)obj];
    }
}

- (void)setCharacterSet:(SDLCharacterSet *)characterSet {
    if (characterSet != nil) {
        [store setObject:characterSet forKey:SDLNameCharacterSet];
    } else {
        [store removeObjectForKey:SDLNameCharacterSet];
    }
}

- (SDLCharacterSet *)characterSet {
    NSObject *obj = [store objectForKey:SDLNameCharacterSet];
    if (obj == nil || [obj isKindOfClass:SDLCharacterSet.class]) {
        return (SDLCharacterSet *)obj;
    } else {
        return [SDLCharacterSet valueOf:(NSString *)obj];
    }
}

- (void)setWidth:(NSNumber *)width {
    if (width != nil) {
        [store setObject:width forKey:SDLNameWidth];
    } else {
        [store removeObjectForKey:SDLNameWidth];
    }
}

- (NSNumber *)width {
    return [store objectForKey:SDLNameWidth];
}

- (void)setRows:(NSNumber *)rows {
    if (rows != nil) {
        [store setObject:rows forKey:SDLNameRows];
    } else {
        [store removeObjectForKey:SDLNameRows];
    }
}

- (NSNumber *)rows {
    return [store objectForKey:SDLNameRows];
}

@end
