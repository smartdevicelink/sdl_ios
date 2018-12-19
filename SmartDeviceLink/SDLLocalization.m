// SDLLocalization.m
//


#import "SDLLocalization.h"
#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private declaration area

@interface SDLLocalization ()

@property (nonatomic, copy, readwrite) NSArray<NSBundle *> *bundles;
@property (nonatomic, copy, readwrite) NSArray<NSLocale *> *locales;
@property (nonatomic, copy, readwrite) NSArray<NSString *> *localizations;

@end

@implementation SDLLocalization

#pragma mark - Localization creation area

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

+ (instancetype)localizationForLanguage:(NSString *)language region:(nullable NSString *)region {
    return [self localizationForLanguage:language region:region script:nil];
}

+ (instancetype)localizationForLanguage:(NSString *)language region:(nullable NSString *)region script:(nullable NSString *)script {
    NSMutableArray<NSString *> *preferredLocalizations = [NSMutableArray arrayWithCapacity:4];
    // making sure the keys match format requirements
    language = language.lowercaseString;
    region = region.uppercaseString;
    script = script.capitalizedString;
    
    if (script != nil && region != nil) {
        NSString *s = [NSString stringWithFormat:@"%@-%@-%@", language, script, region];
        [preferredLocalizations addObject:s];
    }
    
    if (script != nil) {
        NSString *s = [NSString stringWithFormat:@"%@-%@", language, script];
        [preferredLocalizations addObject:s];
    }
    
    if (region != nil) {
        NSString *s = [NSString stringWithFormat:@"%@-%@", language, region];
        [preferredLocalizations addObject:s];
    }
    
    [preferredLocalizations addObject:language.lowercaseString];
    
    return [[self alloc] initWithPreferredLocalizations:preferredLocalizations];
}

#pragma mark - Init area

- (nullable NSString *)bundleLocalizationMatchingPreferredLocalization:(NSString *)preferredLocalization forceScriptMatch:(BOOL)forceScriptMatch {
    NSArray<NSString *> *bundleLocalizations = NSBundle.mainBundle.localizations;
    
    // if a bundle localization fully matches the preferred localization... return it
    if ([bundleLocalizations containsObject:preferredLocalization]) {
        return preferredLocalization;
    }
    
    NSDictionary<NSString *, NSString *> *preferredComponents = [NSLocale componentsFromLocaleIdentifier:preferredLocalization];
    NSString *preferredLanguage = preferredComponents[NSLocaleLanguageCode];
    NSString *preferredCountry = preferredComponents[NSLocaleCountryCode];
    NSString *preferredScript = preferredComponents[NSLocaleScriptCode];
    
    for (NSString *bundleLocalization in bundleLocalizations) {
        NSDictionary<NSString *, NSString *> *bundleComponents = [NSLocale componentsFromLocaleIdentifier:bundleLocalization];
        NSString *bundleLanguage = bundleComponents[NSLocaleLanguageCode];
        NSString *bundleCountry = bundleComponents[NSLocaleCountryCode];
        NSString *bundleScript = bundleComponents[NSLocaleScriptCode];
        
        BOOL matchLanguage = [preferredLanguage isEqualToString:bundleLanguage];
        BOOL matchCountry = [preferredCountry isEqualToString:bundleCountry] || (preferredCountry == nil && bundleCountry == nil);
        BOOL matchScript =  [preferredScript isEqualToString:bundleScript] || (preferredScript == nil && (bundleScript == nil || !forceScriptMatch));
        
        // does it match at least for language and or country?
        if (matchLanguage && (matchScript || matchCountry)) {
            return bundleLocalization;
        }
    }
    
    // there's no localization from the bundle localizations matching preferred localization
    return nil;
}

- (instancetype)init {
    return [self initWithPreferredLocalizations:NSBundle.mainBundle.preferredLocalizations];
}

- (instancetype)initWithPreferredLocalizations:(NSArray<NSString *> *)preferredLocalizations {
    NSUInteger capacity = preferredLocalizations.count;
    NSMutableArray<NSBundle *> *bundles = [NSMutableArray arrayWithCapacity:capacity];
    NSMutableArray<NSLocale *> *locales = [NSMutableArray arrayWithCapacity:capacity];
    NSMutableArray<NSString *> *localizations = [NSMutableArray arrayWithCapacity:capacity];
    
    // only execute when localization bundles exist
    if (NSBundle.mainBundle.localizations.count > 0) {
        for (NSString *preferredLocalization in preferredLocalizations) {
            // get the localization out of bundle localizations that matches best to preferred localization
            // force script match if we already found a localization bundle
            NSString *localization = [self bundleLocalizationMatchingPreferredLocalization:preferredLocalization forceScriptMatch:(bundles.count > 0)];
            if (localization == nil || [localizations containsObject:localization]) {
                continue;
            }
            
            // create the objects when localization was set to something valid
            NSString *path = [NSBundle.mainBundle pathForResource:localization ofType:@"lproj"];
            if (path == nil) {
                SDLLogW(@"SDLLocalization: Warning: the bundle for localization of '%@' was not found.", localization);
                continue;
            }
            
            [bundles addObject:[NSBundle bundleWithPath:path]];
            [locales addObject:[NSLocale localeWithLocaleIdentifier:localization]];
            [localizations addObject:localization];
        }
    }
    
    // repeat the init process but with main bundles preferred localizations if no match with app preferences were found
    if (bundles.count == 0 && ![preferredLocalizations isEqualToArray:NSBundle.mainBundle.preferredLocalizations]) {
        return [self initWithPreferredLocalizations:NSBundle.mainBundle.preferredLocalizations];
    }
    
    // in case we dont have bundle objects but at least tried with default preferred localizations
    if (bundles.count == 0) {
        NSString *localization = NSBundle.mainBundle.preferredLocalizations[0];
        [bundles addObject:NSBundle.mainBundle];
        [locales addObject:[NSLocale localeWithLocaleIdentifier:localization]];
        [localizations addObject:localization];
    }
        
    if (self = [super init]) {
        self.bundles = bundles;
        self.locales = locales;
        self.localizations = localizations;
    }
    
    return self;
}

#pragma mark - Localizing string for key area

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

- (NSString *)stringForKey:(NSString *)key table:(nullable NSString *)table, ... {
    va_list args;
    va_start(args, table);
    NSString *string = [self stringForKey:key table:table arguments:args];
    va_end(args);
    return string;
}

- (NSString *)stringForKey:(NSString *)key table:(nullable NSString *)table arguments:(va_list)args {
    NSString *string = nil;
    
    // loop through all bundles from top to bottom to find a localized string
    for (NSUInteger i = 0; i < self.bundles.count; i++) {
        NSBundle *bundle = self.bundles[i];
        NSLocale *locale = self.locales[i];
        
        NSString *format = [bundle localizedStringForKey:key value:key table:table];
        
        // If we received a format string from the bundle try to apply plural rules to it.
        // format may be nil in old versions of iOS or key is returned on newer iOS versions
        if (format != nil && ![format isEqualToString:key]) {
            string = [[NSString alloc] initWithFormat:format locale:locale arguments:args];
            break;
        }
    }
    
    // in case no bundle contains the key we set the string to the key.
    if (string == nil) {
        return key;
    }
    
    return string;
}

@end

NS_ASSUME_NONNULL_END
