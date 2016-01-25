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

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setName:(SDLTextFieldName *)name {
    if (name != nil) {
        [store setObject:name forKey:NAMES_name];
    } else {
        [store removeObjectForKey:NAMES_name];
    }
}

- (SDLTextFieldName *)name {
    NSObject *obj = [store objectForKey:NAMES_name];
    if (obj == nil || [obj isKindOfClass:SDLTextFieldName.class]) {
        return (SDLTextFieldName *)obj;
    } else {
        return [SDLTextFieldName valueOf:(NSString *)obj];
    }
}

- (void)setCharacterSet:(SDLCharacterSet *)characterSet {
    if (characterSet != nil) {
        [store setObject:characterSet forKey:NAMES_characterSet];
    } else {
        [store removeObjectForKey:NAMES_characterSet];
    }
}

- (SDLCharacterSet *)characterSet {
    NSObject *obj = [store objectForKey:NAMES_characterSet];
    if (obj == nil || [obj isKindOfClass:SDLCharacterSet.class]) {
        return (SDLCharacterSet *)obj;
    } else {
        return [SDLCharacterSet valueOf:(NSString *)obj];
    }
}

- (void)setWidth:(NSNumber *)width {
    if (width != nil) {
        [store setObject:width forKey:NAMES_width];
    } else {
        [store removeObjectForKey:NAMES_width];
    }
}

- (NSNumber *)width {
    return [store objectForKey:NAMES_width];
}

- (void)setRows:(NSNumber *)rows {
    if (rows != nil) {
        [store setObject:rows forKey:NAMES_rows];
    } else {
        [store removeObjectForKey:NAMES_rows];
    }
}

- (NSNumber *)rows {
    return [store objectForKey:NAMES_rows];
}

@end
