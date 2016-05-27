//
//  Preferences.m
//  SmartDeviceLink-iOS

#import "Preferences.h"


NSString *const IPAddressPreferencesKey = @"SDLExampleAppIPAddress";
NSString *const PortPreferencesKey = @"SDLExampleAppPort";

NSString *const DefaultIPAddressValue = @"192.168.1.1";
NSString *const DefaultPortValue = @"12345";



@interface Preferences ()

@end



@implementation Preferences


#pragma mark - Singleton / Initializers

+ (instancetype)sharedPreferences {
    static Preferences *sharedPreferences = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPreferences = [[Preferences alloc] init];
    });
    
    return sharedPreferences;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (self.ipAddress == nil || self.port == nil) {
        [self resetPreferences];
    }
    
    return self;
}


#pragma mark - Public API

- (void)resetPreferences {
    self.ipAddress = DefaultIPAddressValue;
    self.port = DefaultPortValue;
}


#pragma mark - Setters / Getters

- (NSString *)ipAddress {
    return [self stringForKey:IPAddressPreferencesKey];
}

- (void)setIpAddress:(NSString *)ipAddress {
    [self setString:ipAddress forKey:IPAddressPreferencesKey];
}

- (NSString *)port {
    return [self stringForKey:PortPreferencesKey];
}

- (void)setPort:(NSString *)port {
    [self setString:port forKey:PortPreferencesKey];
}


#pragma mark - Private User Defaults Helpers

- (void)setString:(NSString *)aString forKey:(NSString *)aKey {
    NSParameterAssert(aKey != nil);
    
    dispatch_async(self.class.preferencesQueue, ^{
        [[NSUserDefaults standardUserDefaults] setObject:aString forKey:aKey];
    });
}

- (NSString *)stringForKey:(NSString *)aKey {
    NSParameterAssert(aKey != nil);
    
    __block NSString *retVal = nil;
    dispatch_sync(self.class.preferencesQueue, ^{
        retVal = [[NSUserDefaults standardUserDefaults] stringForKey:aKey];
    });
    
    return retVal;
}


#pragma mark - Class Queue

+ (dispatch_queue_t)preferencesQueue {
    static dispatch_queue_t preferencesQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preferencesQueue = dispatch_queue_create("com.sdl-example.preferences", DISPATCH_QUEUE_SERIAL);
    });
    
    return preferencesQueue;
}

@end
