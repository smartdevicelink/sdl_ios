//  SDLRPCNotification.m
//


#import "SDLRPCNotification.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCMessage ()

@property (strong, nonatomic, readwrite) NSString *messageType;
@property (strong, nonatomic) NSMutableDictionary<NSString *, id> *function;

@end

@implementation SDLRPCNotification

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (!self) {
        return nil;
    }

    self.messageType = SDLRPCParameterNameNotification;
    [self.store setObject:self.function forKey:self.messageType];

    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    self.messageType = SDLRPCParameterNameNotification;
    [self.store setObject:self.function forKey:self.messageType];

    return self;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
