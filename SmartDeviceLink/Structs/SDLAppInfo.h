//  SDLAppInfo.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAppInfo : SDLRPCStruct

+ (instancetype)currentAppInfo;

@property (strong, nonatomic) NSString *appDisplayName;
@property (strong, nonatomic) NSString *appBundleID;
@property (strong, nonatomic) NSString *appVersion;

@end

NS_ASSUME_NONNULL_END
