//
//  SDLConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/13/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLFileManagerConfiguration;
@class SDLLifecycleConfiguration;
@class SDLLockScreenConfiguration;
@class SDLLogConfiguration;
@class SDLStreamingMediaConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface SDLConfiguration : NSObject <NSCopying>

/**
 *  The lifecycle configuration.
 */
@property (copy, nonatomic, readonly) SDLLifecycleConfiguration *lifecycleConfig;

/**
 *  The lock screen configuration.
 */
@property (copy, nonatomic, readonly) SDLLockScreenConfiguration *lockScreenConfig;

/**
 *  The log configuration.
 */
@property (copy, nonatomic, readonly) SDLLogConfiguration *loggingConfig;

/**
 *  The streaming media configuration.
 */
@property (copy, nonatomic, readonly) SDLStreamingMediaConfiguration *streamingMediaConfig;

/**
 *  The file manager configuration.
 */
@property (copy, nonatomic, readonly) SDLFileManagerConfiguration *fileManagerConfig;

/**
 *  Creates a new configuration to be passed to the SDLManager with custom lifecycle, lock screen and logging configurations.
 *
 *  @param lifecycleConfig      The lifecycle configuration to be used.
 *  @param lockScreenConfig     The lockscreen configuration to be used. If nil, the `enabledConfiguration` will be used.
 *  @param logConfig            The logging configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @return                     The configuration
 */
- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig __deprecated_msg("Use initWithLifecycle:lockScreen:logging:fileManager: instead");

/**
 *  Creates a new configuration to be passed to the SDLManager with custom lifecycle, lock screen, logging and file manager configurations.
 *
 *  @param lifecycleConfig      The lifecycle configuration to be used.
 *  @param lockScreenConfig     The lockscreen configuration to be used. If nil, the `enabledConfiguration` will be used.
 *  @param logConfig            The logging configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @param fileManagerConfig    The file manager configuration to be used or `defaultConfiguration` if nil.
 *  @return                     The configuration
 */
- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig;

/**
 *  Creates a new configuration to be passed to the SDLManager with custom lifecycle, lock screen and logging configurations.
 *
 *  @param lifecycleConfig      The lifecycle configuration to be used.
 *  @param lockScreenConfig     The lockscreen configuration to be used. If nil, the `enabledConfiguration` will be used.
 *  @param logConfig            The logging configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @return                     The configuration
 */
+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig __deprecated_msg("Use configurationWithLifecycle:lockScreen:logging:fileManager: instead") NS_SWIFT_UNAVAILABLE("Use an initializer instead");

/**
 *  Creates a new configuration to be passed to the SDLManager with custom lifecycle, lock screen, logging and file manager configurations.
 *
 *  @param lifecycleConfig      The lifecycle configuration to be used.
 *  @param lockScreenConfig     The lockscreen configuration to be used. If nil, the `enabledConfiguration` will be used.
 *  @param logConfig            The logging configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @param fileManagerConfig    The file manager configuration to be used or `defaultConfiguration` if nil.
 *  @return                     The configuration
 */
+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig NS_SWIFT_UNAVAILABLE("Use an initializer instead");

/**
 *  Creates a new configuration to be passed to the SDLManager with custom lifecycle, lock screen, logging and streaming media configurations.
 *
 *  @param lifecycleConfig      The lifecycle configuration to be used.
 *  @param lockScreenConfig     The lockscreen configuration to be used. If nil, the `enabledConfiguration` will be used.
 *  @param logConfig            The logging configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @param streamingMediaConfig The streaming media configuration to be used or nil if not used.
 *  @return                     The configuration
 */
- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig __deprecated_msg("Use initWithLifecycle:lockScreen:logging:streamingMedia:fileManager: instead");

/**
 *  Creates a new configuration to be passed to the SDLManager with custom lifecycle, lock screen, logging, streaming media and file manager configurations.
 *
 *  @param lifecycleConfig      The lifecycle configuration to be used.
 *  @param lockScreenConfig     The lockscreen configuration to be used. If nil, the `enabledConfiguration` will be used.
 *  @param logConfig            The logging configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @param streamingMediaConfig The streaming media configuration to be used or nil if not used.
 *  @param fileManagerConfig    The file manager configuration to be used or `defaultConfiguration` if nil.
 *  @return                     The configuration
 */
- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig;

/**
 *  Creates a new configuration to be passed to the SDLManager with custom lifecycle, lock screen, logging and streaming media configurations.
 *
 *  @param lifecycleConfig      The lifecycle configuration to be used.
 *  @param lockScreenConfig     The lockscreen configuration to be used. If nil, the `enabledConfiguration` will be used.
 *  @param logConfig            The logging configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @param streamingMediaConfig The streaming media configuration to be used or nil if not used.
 *  @return                     The configuration
 */
+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig __deprecated_msg("Use configurationWithLifecycle:lockScreen:logging:streamingMedia:fileManager: instead") NS_SWIFT_UNAVAILABLE("Use an initializer instead");

/**
 *  Creates a new configuration to be passed to the SDLManager with custom lifecycle, lock screen, logging, streaming media and file manager configurations.
 *
 *  @param lifecycleConfig      The lifecycle configuration to be used.
 *  @param lockScreenConfig     The lockscreen configuration to be used. If nil, the `enabledConfiguration` will be used.
 *  @param logConfig            The logging configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @param streamingMediaConfig The streaming media configuration to be used or nil if not used.
 *  @param fileManagerConfig    The file manager configuration to be used or `defaultConfiguration` if nil.
 *  @return                     The configuration
 */
+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig NS_SWIFT_UNAVAILABLE("Use an initializer instead");

@end

NS_ASSUME_NONNULL_END
