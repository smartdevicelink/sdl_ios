//  SDLRequestType.h
//


#import "SDLEnum.h"

@interface SDLRequestType : SDLEnum {
}

+ (SDLRequestType *)valueOf:(NSString *)value;
+ (NSArray *)values;

+ (SDLRequestType *)HTTP;
+ (SDLRequestType *)FILE_RESUME;
+ (SDLRequestType *)AUTH_REQUEST;
+ (SDLRequestType *)AUTH_CHALLENGE;
+ (SDLRequestType *)AUTH_ACK;
+ (SDLRequestType *)PROPRIETARY;
+ (SDLRequestType *)QUERY_APPS;
+ (SDLRequestType *)LAUNCH_APP;
+ (SDLRequestType *)LOCK_SCREEN_ICON_URL;
+ (SDLRequestType *)TRAFFIC_MESSAGE_CHANNEL;
+ (SDLRequestType *)DRIVER_PROFILE;
+ (SDLRequestType *)VOICE_SEARCH;
+ (SDLRequestType *)NAVIGATION;
+ (SDLRequestType *)PHONE;
+ (SDLRequestType *)CLIMATE;
+ (SDLRequestType *)SETTINGS;
+ (SDLRequestType *)VEHICLE_DIAGNOSTICS;
+ (SDLRequestType *)EMERGENCY;
+ (SDLRequestType *)MEDIA;
+ (SDLRequestType *)FOTA;

@end
