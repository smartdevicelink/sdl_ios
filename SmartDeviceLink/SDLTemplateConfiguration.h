//
//  SDLTemplateConfiguration.h
//  SmartDeviceLink
//
//  Created by cssoeutest1 on 16.07.19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLTemplateColorScheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTemplateConfiguration : SDLRPCStruct



/**
 *
 *
 */
- (instancetype)initWithTemplate:(NSString *)templateName NS_DESIGNATED_INITIALIZER;


/**
 *
 *
 */
- (instancetype)initWithTemplate:(NSString *)templateName dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme;

/**
 * Predefined or dynamically created window template.
 * Currently only predefined window template layouts are defined.
 */
@property (strong, nonatomic) NSString *templateName;

/**
 *
 *
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *dayColorScheme;
/**
 *
 *
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *nightColorScheme;

@end

NS_ASSUME_NONNULL_END
