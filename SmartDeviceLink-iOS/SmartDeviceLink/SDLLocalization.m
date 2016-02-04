// SDLLocalization.m
//


#import "SDLLocalization.h"

/** Private definition extending setter for the properties. */
@interface SDLLocalization ()

@property (readwrite) NSString *language;

@property (readwrite) NSString *region;

@property (readwrite) NSBundle *defaultBundle;

@property (readwrite) NSLocale *defaultLocale;

@property (readwrite) NSBundle *fallbackBundle;

@property (readwrite) NSLocale *fallbackLocale;

@end

@implementation SDLLocalization

- (NSBundle *)bundle {
    if ([self defaultBundle]) {
        return [self defaultBundle];
    } else if ([self fallbackBundle]) {
        return [self fallbackBundle];
    } else {
        return nil;
    }
}

- (NSLocale *)locale {
    if ([self defaultLocale]) {
        return [self defaultLocale];
    } else if ([self fallbackLocale]) {
        return [self fallbackLocale];
    } else {
        return nil;
    }
}

+ (instancetype)defaultLocalization {
    static SDLLocalization *object = nil;
    static dispatch_once_t token;

    dispatch_once(&token, ^{
        // get the locale identifier
        NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
        // extract language
        NSString *language = ([localeIdentifier length] >= 2 ? [[localeIdentifier substringWithRange:NSMakeRange(0, 2)] lowercaseString] : nil);
        // extract region
        NSString *region   = ([localeIdentifier length] >= 5 ? [[localeIdentifier substringWithRange:NSMakeRange(3, 2)] uppercaseString] : nil);
        
        NSBundle *defaultBundle = nil;
        NSLocale *defaultLocale = nil;
        NSBundle *fallbackBundle = nil;
        NSLocale *fallbackLocale = nil;
        
        // create default bundle and locale for language AND region only
        if (language != nil && region != nil) {
            // create a new locale identifier matching the bundle path for language AND region
            localeIdentifier = [NSString stringWithFormat:@"%@-%@", [language lowercaseString], [language uppercaseString]];
            // try to create a bundle for language AND region
            defaultBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:localeIdentifier ofType:@"lproj"]];
            // do we have a bundle for language AND region?
            if (defaultBundle != nil) {
                // we do. create a locale for language AND region
                defaultLocale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
            }
        }
        
        // create fallback bundle and locale for language ONLY
        if (language != nil) {
            // create a new locale identifier matching the bundle path for langauge ONLY
            localeIdentifier = [language lowercaseString];
            // try to create a bundle for language ONLY
            fallbackBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:localeIdentifier ofType:@"lproj"]];
            // do we have a bundle for language ONLY?
            if (fallbackBundle != nil) {
                // we do. create a locale for language ONLY
                fallbackLocale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
            }
        }
        
        // do we have any bundle object?
        if (defaultBundle == nil && fallbackBundle == nil) {
            // we don't. use system objects
            fallbackBundle = [NSBundle mainBundle];
            fallbackLocale = [NSLocale currentLocale];
        }
        
        object = [[SDLLocalization alloc] init];
        [object setLanguage:language];
        [object setRegion:region];
        [object setDefaultBundle:defaultBundle];
        [object setDefaultLocale:defaultLocale];
        [object setFallbackBundle:fallbackBundle];
        [object setFallbackLocale:fallbackLocale];
    });
    
    return object;
}

+ (instancetype)localizationForLanguage:(NSString *)language forRegion:(NSString *)region {
    SDLLocalization *object = nil;
    
    // get the locale identifier
    NSString *localeIdentifier = nil;
    
    NSBundle *defaultBundle = nil;
    NSLocale *defaultLocale = nil;
    NSBundle *fallbackBundle = nil;
    NSLocale *fallbackLocale = nil;
    
    // create default bundle and locale for language AND region only
    if (language != nil && region != nil) {
        // create a new locale identifier matching the bundle path for language AND region
        localeIdentifier = [NSString stringWithFormat:@"%@-%@", [language lowercaseString], [language uppercaseString]];
        // try to create a bundle for language AND region
        defaultBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:localeIdentifier ofType:@"lproj"]];
        // do we have a bundle for language AND region?
        if (defaultBundle != nil) {
            // we do. create a locale for language AND region
            defaultLocale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
        }
    }
    
    // create fallback bundle and locale for language ONLY
    if (language != nil) {
        // create a new locale identifier matching the bundle path for langauge ONLY
        localeIdentifier = [language lowercaseString];
        // try to create a bundle for language ONLY
        fallbackBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:localeIdentifier ofType:@"lproj"]];
        // do we have a bundle for language ONLY?
        if (fallbackBundle != nil) {
            // we do. create a locale for language ONLY
            fallbackLocale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
        }
    }
    
    // do we have any bundle object?
    if (defaultBundle == nil && fallbackBundle == nil) {
        // we don't. use default object
        return [self defaultLocalization];
    }
    
    object = [[SDLLocalization alloc] init];
    [object setLanguage:language];
    [object setRegion:region];
    [object setDefaultBundle:defaultBundle];
    [object setDefaultLocale:defaultLocale];
    [object setFallbackBundle:fallbackBundle];
    [object setFallbackLocale:fallbackLocale];

    return object;
}

- (NSString *)stringForKey:(NSString *)key, ... {
    va_list args;
    va_start(args, key);
    
    NSString *format = nil;
    NSString *string = nil;
    
    // do we have a default bundle?
    if ([self defaultBundle] != nil) {
        // we do. use it
        format = [[self defaultBundle] localizedStringForKey:key value:nil table:nil];
        // does the default bundle has a string for the key?
        if (format != nil) {
            // it does. get the string using the default locale.
            string = [[NSString alloc] initWithFormat:format locale:[self defaultLocale] arguments:args];
        }
    }
    
    // no default bundle keeps format to be nil. if format is nil then args is still valid. do we need to use the fallback?
    if ([self fallbackBundle] != nil && format == nil) {
        // we do. use it
        format = [[self fallbackBundle] localizedStringForKey:key value:nil table:nil];
        // does the fallback bundle has a string for the key?
        if (format != nil) {
            // it does. get the string using the fallback locale.
            string = [[NSString alloc] initWithFormat:format locale:[self fallbackLocale] arguments:args];
        }
    }
    
    
    va_end(args);
    
    return string;
}


@end
