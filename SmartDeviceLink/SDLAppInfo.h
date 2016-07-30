//  SDLAppInfo.h
//

#import "SDLRPCStruct.h"

@interface SDLAppInfo : SDLRPCStruct

@property (strong) NSString *appDisplayName;
@property (strong) NSString *appBundleID;
@property (strong) NSString *appVersion;

@end
