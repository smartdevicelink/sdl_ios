//  SDLAppInfo.h
//

#import "SDLRPCStruct.h"

@interface SDLAppInfo : SDLRPCStruct

+ (instancetype)currentAppInfo;

@property (strong, nonatomic) NSString *appDisplayName;
@property (strong, nonatomic) NSString *appBundleID;
@property (strong, nonatomic) NSString *appVersion;

@end
