//  SDLAppInfo.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAppInfo : SDLRPCStruct

+ (instancetype)currentAppInfo;

@property (strong) NSString *appDisplayName;
@property (strong) NSString *appBundleID;
@property (strong) NSString *appVersion;

@end

NS_ASSUME_NONNULL_END
