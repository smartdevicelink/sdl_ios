//
//  Preferences.h
//  SmartDeviceLink-iOS

#import <Foundation/Foundation.h>

/**
 *  A fully thread safe way to set and access preferences stored on NSUserDefaults
 *  just read and write the property values, don't access them via iVar, you won't get
 *  very far...HA. I rhymed. Access them via the shared preferences object, or don't...
 *  the result will be the same. Like, exactly the same. Hopefully.
 */
@interface Preferences : NSObject

/***** Computed Properties *****/
// Connection
@property (strong, nonatomic) NSString *ipAddress;
@property (assign, nonatomic) UInt16 port;

+ (instancetype)sharedPreferences;

/**
 *  Reset the properties in the defaults object to their default values, defined in the m file.
 */
- (void)resetPreferences;

@end
