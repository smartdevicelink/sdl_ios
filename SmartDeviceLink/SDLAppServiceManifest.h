//
//  SDLAppServiceManifest.h
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"
#import "SDLFileType.h"
#import "SDLFunctionID.h"
#import "SDLSyncMsgVersion.h"

NS_ASSUME_NONNULL_BEGIN

/*
 *  This manfifest contains all the information necessary for the service to be published, activated, and consumers able to interact with it.
 */
@interface SDLAppServiceManifest : SDLRPCStruct

/**
 *  Unique name of this service
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *serviceName;

// TODO: Add serviceType when AppServiceType struct has been added

/**
 *  The file name of the icon to be associated with this service. Most likely the same as the appIcon.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *serviceIcon;

/**
 *  If true, app service consumers beyond the IVI system will be able to access this service. If false, only the IVI system will be able consume the service. If not provided, it is assumed to be false.
 *
 *  Boolean, Optional, default = NO
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *allowAppConsumers;

/**
 *  The URI prefix for this service. If provided, all PerformAppServiceInteraction requests must start with it.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *uriPrefix;


// TODO: uriScheme need to figure out what JSONObject is

/**
 *  This is the max RPC Spec version the app service understands. This is important during the RPC passthrough functionality. If not included, it is assumed the max version of the module is acceptable.
 *
 *  SyncMsgVersion, Optional
 */
@property (nullable, strong, nonatomic) SDLSyncMsgVersion *rpcSpecVersion;

/**
 *  This field contains the Function IDs for the RPCs that this service intends to handle correctly. This means the service will provide meaningful responses.
 *
 *  Array of SDLFunctionIDs, Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLFunctionID *> *handledRPCs;

// TODO: add service manifests
// mediaServiceManifest
// weatherServiceManifest
// navigationServiceManifest
// voiceAssistantServiceManifest

@end

NS_ASSUME_NONNULL_END
