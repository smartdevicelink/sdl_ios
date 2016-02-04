// SDLLocalization.h
//


#import <Foundation/Foundation.h>

/**
 Provides a simplified way to handle localization for a specific language that may not match the system language.
 */
@interface SDLLocalization : NSObject

/** The language code used by this instance. This code can differ from initialization regarding fallback. */
@property (readonly) NSString *language;

/** The region code used by this instance. This code can differ from initialization regarding fallback. */
@property (readonly) NSString *region;


/** 
 The bundle object using language and region. If region is not provided or localization for that region does not exist
 this property is set to nil.
 */
@property (readonly) NSBundle *defaultBundle;

/**
 The locale object using language and region. If region is not provided or localization for that region does not exist
 this property is set to nil.
 */
@property (readonly) NSLocale *defaultLocale;

/**
 The bundle object using language only as a fallback to the default bundle. 
 If the default bundle does not exist or it does not contain a specific localization
 then this fallback bundle is used.
 */
@property (readonly) NSBundle *fallbackBundle;

/**
 The locale object using language only as a fallback to the default locale.
 If the default bundle does not exist or it does not contain a specific localization
 then this fallback locale is used.
 */
@property (readonly) NSLocale *fallbackLocale;

/**
 Returns the default bundle. 
 Return the fallback bundle if the default bundle does not exist.
 Returns nil if both bundles do not exist.
*/
@property (readonly) NSBundle *bundle;

/**
 Returns the default locale.
 Return the fallback locale if the default locale does not exist.
 Returns nil if both locales do not exist.
 */
@property (readonly) NSLocale *locale;


/**
 Returns the default localization object representing the system language.
 */
+ (instancetype)defaultLocalization;

/**
 Creates an object of this class using the specified language and region.
 If there is no definition matching the language and region it creates an object using the language only.
 If there is no definition matching the language only it creates an object that falls back to the system language.
 */
+ (instancetype)localizationForLanguage:(NSString *)language forRegion:(NSString *)region;

/**
 Returns the localized string for the specified key.
 If no localization was found for the key it returns the key itself.
 This method supports plural rules. The keys for plural rules must be defined in a .stringsdict file.
 See:
 https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/LocalizingYourApp/LocalizingYourApp.html
 https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/StringsdictFileFormat/StringsdictFileFormat.html
 http://objectivetoast.com/2014/04/21/localizing-with-plurals-and-genders/
 http://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html */
- (NSString *)stringForKey:(NSString *)key, ...;

@end
