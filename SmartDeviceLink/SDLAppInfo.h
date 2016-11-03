//  SDLAppInfo.h
//

#import "SDLRPCStruct.h"

@interface SDLAppInfo : SDLRPCStruct

+ (instancetype)currentAppInfo;

@property (strong) NSString *appDisplayName;
@property (strong) NSString *appBundleID;
@property (strong) NSString *appVersion;

@end
