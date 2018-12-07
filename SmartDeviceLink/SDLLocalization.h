// SDLLocalization.h
//


#import <Foundation/Foundation.h>

/**
 Provides localization features fully compatible to the existing localization structure of iOS.
 
 In addition to stock localization features it supports the fallback to other localizations which enables
 the app to partly implement localizations for regions. This will improve maintenance for region based
 localizations.
 
 An app may contain a lproj for "en" and "en-GB" whereof "en-GB" is only a subset of "en" overwriting
 only specific keys which doesn't match the regular "en" localization. An object of this localization class
 will try out to to localize a key from "en-GB" first and if it fails it then tries "en".
 
 Furthermore a specific language and its localization can be loaded besides the phone language.
 
 The class is fully plural rule enabled using the existing strucutre of stringsdict files.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLLocalization : NSObject

/**
 Returns an array of bundles used by this localization object.
 */
@property (nonatomic, copy, readonly) NSArray<NSBundle *> *bundles;

/**
 Returns an array of locales used by this localization object.
 */
@property (nonatomic, copy, readonly) NSArray<NSLocale *> *locales;

/**
 Returns an array of language ID strings used by this localization object.
 */
@property (nonatomic, copy, readonly) NSArray<NSString *> *localizations;

/**
 Returns the shared default localization object using the preferred localizations of the apps main bundle.
 */
+ (instancetype)defaultLocalization;

/**
 Creates a localization object using the preferred language.
 @param language The preferred language.
 @return A localization object based on the preferred language.
 */
+ (instancetype)localizationForLanguage:(NSString *)language;

/**
 Creates a localization object using the preferred language and region.
 The localization object will be created by generating the following array
 - [0] {language}-{region}
 - [1] {language}
 @param language The preferred language.
 @param region The preferred region.
 @return A localization object based on the preferred language and region.
 */
+ (instancetype)localizationForLanguage:(NSString *)language region:(NSString * _Nullable)region;

/**
 Creates a localization object using the preferred language, region and script.
 The localization object will be created by generating the following array
 - [0] {language}-{script}-{region}
 - [1] {language}-{script}
 - [2] {language}-{region}
 - [3] {language}
 @param language The preferred language.
 @param region The preferred region.
 @param script The preferred script.
 @return A localization object based on the preferred language, region and script.
 */
+ (instancetype)localizationForLanguage:(NSString *)language region:(NSString * _Nullable)region script:(NSString * _Nullable)script;

/**
 Creates a localization object using the preferred localizations of the apps main bundle.
 */
- (instancetype)init;

/**
 Creates a localization object using the provided array of preferred localizations.
 In case no localization exist for any preferred localization the object will be created
 using the preferred localizations of the apps main bundle.
 */
- (instancetype)initWithPreferredLocalizations:(NSArray<NSString *> *)preferredLocalizations;

/**
 Returns the localized string from the default table for the specified key.
 This method supports plural rules (see stringsDict files).
 @return A localized string. If no localization was found for the key it returns the key.
 */
- (NSString *)stringForKey:(NSString *)key, ...;

/**
 Returns the localized string from the default table for the specified key.
 This method supports plural rules (see stringsDict files).
 @return A localized string. If no localization was found for the key it returns the key.
 */
- (NSString *)stringForKey:(NSString *)key arguments:(va_list)args;

/**
 Returns the localized string for the specified table and key.
 This method supports plural rules (see stringsDict files).
 @return A localized string. If no localization was found for the key it returns the key.
 */
- (NSString *)stringForKey:(NSString *)key table:(NSString * _Nullable)table, ...;

/**
 Returns the localized string for the specified table and key.
 This method supports plural rules (see stringsDict files).
 @return A localized string. If no localization was found for the key it returns the key.
 */
- (NSString *)stringForKey:(NSString *)key table:(NSString * _Nullable)table arguments:(va_list)args;

@end

NS_ASSUME_NONNULL_END
