// SDLLocalization.m
//


#import "SDLLocalization.h"

#pragma mark- Private declaration area

/** Private definition extending setter for the properties. */
@interface SDLLocalization ()

@property (nonatomic, copy, readwrite) NSArray *bundles;

@property (nonatomic, copy, readwrite) NSArray *locales;

@property (nonatomic, copy, readwrite) NSArray *localizations;

@end

@implementation SDLLocalization

#pragma mark- Localization creation area

+ (instancetype)defaultLocalization {
    static SDLLocalization *object = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        object = [[self alloc] init];
    });
    
    return object;
}

+ (instancetype)localizationForLanguage:(NSString *)language {
    return [self localizationForLanguage:language region:nil script:nil];
}

+ (instancetype)localizationForLanguage:(NSString *)language region:(NSString *)region {
    return [self localizationForLanguage:language region:region script:nil];
}

+ (instancetype)localizationForLanguage:(NSString *)language region:(NSString * _Nullable)region script:(NSString * _Nullable)script {
    NSMutableArray *preferredLocalizations = [NSMutableArray array];
    
    if (language != nil && script != nil && region != nil) {
        NSString *s = [NSString stringWithFormat:@"%@-%@-%@",
                       [language lowercaseString], [script capitalizedString], [region uppercaseString]];
        [preferredLocalizations addObject:s];
    }
    
    if (language != nil && script != nil) {
        NSString *s = [NSString stringWithFormat:@"%@-%@",
                       [language lowercaseString], [script capitalizedString]];
        [preferredLocalizations addObject:s];
    }
    
    if (language != nil && region != nil) {
        NSString *s = [NSString stringWithFormat:@"%@-%@",
                       [language lowercaseString], [region uppercaseString]];
        [preferredLocalizations addObject:s];
    }
    
    if (language != nil) {
        [preferredLocalizations addObject:[language lowercaseString]];
    }
    
    SDLLocalization *object = [[self alloc] initWithPreferredLocalizations:preferredLocalizations];
    
    return object;
}

#pragma mark- Init area

- (instancetype)init {
    // call the init method using the preferred localizations.
    return [self initWithPreferredLocalizations:[[NSBundle mainBundle] preferredLocalizations]];
}

- (instancetype)initWithPreferredLocalizations:(NSArray *)preferredLocalizations {
    // create arrays that will be used by this localization object
    NSMutableArray *bundles = [NSMutableArray arrayWithCapacity:[preferredLocalizations count]];
    NSMutableArray *locales = [NSMutableArray arrayWithCapacity:[preferredLocalizations count]];
    NSMutableArray *localizations = [NSMutableArray arrayWithCapacity:[preferredLocalizations count]];
    
    // get all available localizations from the app
    NSArray *bundleLocalizations = [[NSBundle mainBundle] localizations];
    
    // only execute when localization bundles exist
    if ([bundleLocalizations count] > 0) {
        for (NSString *preferredLocalization in preferredLocalizations) {
            NSString *localization = nil;
            // does the bundle contain the exact localization?
            if ([bundleLocalizations containsObject:preferredLocalization]) {
                // yes it does so we going to use it
                localization = preferredLocalization;
            } else {
                // no it doesn't. Now try if the localizations match language (and country) only
                
                // split the preferred localization up to its components
                NSDictionary *preferredComponents = [NSLocale componentsFromLocaleIdentifier:preferredLocalization];
                NSString *preferredLanguage = [preferredComponents objectForKey:NSLocaleLanguageCode];
                NSString *preferredCountry = [preferredComponents objectForKey:NSLocaleCountryCode];
                NSString *preferredScript = [preferredComponents objectForKey:NSLocaleScriptCode];
                
                // loop through all bundle localization strings
                for (NSString *bundleLocalization in bundleLocalizations) {
                    // split the bundle localization up to its components
                    NSDictionary *bundleComponents = [NSLocale componentsFromLocaleIdentifier:bundleLocalization];
                    NSString *bundleLanguage = [bundleComponents objectForKey:NSLocaleLanguageCode];
                    NSString *bundleCountry = [bundleComponents objectForKey:NSLocaleCountryCode];
                    NSString *bundleScript = [bundleComponents objectForKey:NSLocaleScriptCode];
                    
                    // both language match? (nil is not allowed for languages)
                    BOOL matchLanguage = [preferredLanguage isEqualToString:bundleLanguage];
                    
                    // Either both country strings are nil or they match
                    BOOL matchCountry = (preferredCountry == nil && bundleCountry == nil) ||
                    [preferredCountry isEqualToString:bundleCountry];
                    
                    // Either both scripts are nil or they match
                    BOOL matchScript = (preferredScript == nil && bundleScript == nil) ||
                    [preferredScript isEqualToString:bundleScript];
                    
                    // if no localization was found and preferred localization covers no script
                    if (bundles.count == 0 && preferredScript == nil) {
                        // statically set that script matches
                        matchScript = YES;
                    }
                    
                    // does it match at least for language and or country?
                    if (matchLanguage && matchScript && matchCountry) {
                        // yes it does so we going to use it
                        localization = bundleLocalization;
                        
                        // stop to loop through the bundle localizations
                        break;
                    }
                }
            }
            
            // create the objects when localization was set to someting valid
            if (localization != nil) {
                NSString *path = [[NSBundle mainBundle] pathForResource:localization ofType:@"lproj"];
                
                if (path != nil) {
                    [bundles addObject:[NSBundle bundleWithPath:path]];
                    [locales addObject:[NSLocale localeWithLocaleIdentifier:localization]];
                    [localizations addObject:localization];
                } else {
                    NSLog(@"SDLLocalization: Warning: the bundle for localization of '%@' was not found.", localization);
                }
            }
        }
    }
    
    if (bundles.count > 0 || [preferredLocalizations isEqualToArray:[[NSBundle mainBundle] preferredLocalizations]]) {
        // in case we dont have bundle objects but at least tried with default preferred localizations
        if (bundles.count == 0) {
            // get the most preferred localization string
            NSString *localization = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
            // get the main bundle to cover the very basic localization (or nothing)
            [bundles addObject:[NSBundle mainBundle]];
            // create a new locale object for this purpose
            [locales addObject:[NSLocale localeWithLocaleIdentifier:localization]];
            // save that we are going to use this one language.
            [localizations addObject:localization];
        }
        
        // we found localizations so finish up here
        if (self = [super init]) {
            self.bundles = bundles;
            self.locales = locales;
            self.localizations = localizations;
        }
    } else {
        // no localizations but we were not using the default preferred localizations
        return [self initWithPreferredLocalizations:[[NSBundle mainBundle] preferredLocalizations]];
    }
    
    return self;
}

#pragma mark- Localizing area

- (NSString *)stringForKey:(NSString *)key, ... {
    va_list args;
    va_start(args, key);
    NSString *string = [self stringForKey:key table:nil arguments:args];
    va_end(args);
    return string;
}

- (NSString *)stringForKey:(NSString *)key arguments:(va_list)args {
    return [self stringForKey:key table:nil arguments:args];
}

- (NSString *)stringForKey:(NSString *)key table:(NSString *)table, ... {
    va_list args;
    va_start(args, table);
    NSString *string = [self stringForKey:key table:table arguments:args];
    va_end(args);
    return string;
}

- (NSString *)stringForKey:(NSString *)key table:(NSString * _Nullable)table arguments:(va_list)args {
    NSString *string = nil;
    
    // we will now loop through all bundles from top to bottom to find a localized string
    for (NSUInteger i = 0; i < [[self bundles] count]; i++) {
        // get the bundle and the locale of the current position
        NSBundle *bundle = [[self bundles] objectAtIndex:i];
        NSLocale *locale = [[self locales] objectAtIndex:i];
        
        // get a format string from the bundle
        NSString *format = [bundle localizedStringForKey:key value:key table:table];
        
        // was this successful? (format may be nil in old versions of iOS or key is returned on newer iOS versions)
        if (format != nil && [format isEqualToString:key] == NO) {
            // We received a string from the bundle. Try to apply plural rules to it.
            string = [[NSString alloc] initWithFormat:format locale:locale arguments:args];
            
            // now we can stop here and return the key with potentially plural rule applied
            break;
        }
    }
    
    // in case no bundle contains the key we set the string to the key.
    if (string == nil) {
        string = key;
    }
    
    //return the localized string (or the key if it failed).
    return string;
}

@end
