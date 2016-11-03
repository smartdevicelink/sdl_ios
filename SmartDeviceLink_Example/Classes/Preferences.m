//
//  Preferences.m
//  SmartDeviceLink-iOS

#import "Preferences.h"


NSString *const IPAddressPreferencesKey = @"SDLExampleAppIPAddress";
NSString *const PortPreferencesKey = @"SDLExampleAppPort";

NSString *const DefaultIPAddressValue = @"192.168.1.1";
UInt16 const DefaultPortValue = 12345;



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
    
    if (self.ipAddress == nil || self.port == 0) {
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

- (UInt16)port {
    return (UInt16)[self integerForKey:PortPreferencesKey];
}

- (void)setPort:(UInt16)port {
    [self setInteger:port forKey:PortPreferencesKey];
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

- (void)setInteger:(NSInteger)aInt forKey:(NSString *)aKey {
    NSParameterAssert(aKey != nil);
    
    dispatch_async(self.class.preferencesQueue, ^{
        [[NSUserDefaults standardUserDefaults] setInteger:aInt forKey:aKey];
    });
}

- (NSInteger)integerForKey:(NSString *)aKey {
    NSParameterAssert(aKey != nil);
    
    __block NSInteger retVal = 0;
    dispatch_sync(self.class.preferencesQueue, ^{
        retVal = [[NSUserDefaults standardUserDefaults] integerForKey:aKey];
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
