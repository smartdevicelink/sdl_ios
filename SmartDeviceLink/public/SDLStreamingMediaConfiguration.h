//
//  SDLStreamingMediaConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLStreamingMediaManagerConstants.h"

@protocol SDLSecurityType;
@protocol SDLStreamingMediaManagerDataSource;
@protocol SDLStreamingVideoDelegate;
@class SDLVideoStreamingRange;

NS_ASSUME_NONNULL_BEGIN

/**
 The type of rendering that CarWindow will perform. Depending on your app, you may need to try different ones for best performance
 */
typedef NS_ENUM(NSUInteger, SDLCarWindowRenderingType) {
    /// Instead of rendering your UIViewController's view, this will render the layer using renderInContext
    SDLCarWindowRenderingTypeLayer,

    /// Renders your UIViewController's view using drawViewHierarchyInRect:bounds afterScreenUpdates:YES
    SDLCarWindowRenderingTypeViewAfterScreenUpdates,

    /// Renders your UIViewController's view using drawViewHierarchyInRect:bounds afterScreenUpdates:NO
    SDLCarWindowRenderingTypeViewBeforeScreenUpdates
};

/// The streaming media configuration. Use this class to configure streaming media information.
@interface SDLStreamingMediaConfiguration : NSObject <NSCopying>

/**
 *  What encryption level video/audio streaming should be. The default is SDLStreamingEncryptionFlagAuthenticateAndEncrypt.
 */
@property (assign, nonatomic) SDLStreamingEncryptionFlag maximumDesiredEncryption;

/**
 *  Properties to use for applications that utilize the video encoder for streaming. See VTCompressionProperties.h for more details. For example, you can set kVTCompressionPropertyKey_ExpectedFrameRate to set your framerate. Setting the framerate this way will also set the framerate if you use CarWindow automatic streaming.
 *
 *  Other properties you may want to try adjusting include kVTCompressionPropertyKey_AverageBitRate and kVTCompressionPropertyKey_DataRateLimits.
 */
@property (copy, nonatomic, nullable) NSDictionary<NSString *, id> *customVideoEncoderSettings;

/**
 Usable to change run time video stream setup behavior. Only use this and modify the results if you *really* know what you're doing. The head unit defaults are generally good.
 */
@property (weak, nonatomic, nullable) id<SDLStreamingMediaManagerDataSource> dataSource;

/**
 Set the initial view controller your video streaming content is within.

 Activates the haptic view parser and CarWindow systems when set. This library will also use that information to attempt to return the touched view to you in `SDLTouchManagerDelegate`.

 @note If you wish to alter this `rootViewController` while streaming via CarWindow, you must set a new `rootViewController` on `SDLStreamingMediaManager` and this will update both the haptic view parser and CarWindow.

 @warning Apps using views outside of the `UIView` hierarchy (such as OpenGL) are currently unsupported. If you app uses partial views in the hierarchy, only those views will be discovered. Your OpenGL views will not be discoverable to a haptic interface head unit and you will have to manually make these views discoverable via the `SDLSendHapticData` RPC request.

 @warning If the `rootViewController` is app UI and is set from the `UIViewController` class, it should only be set after viewDidAppear:animated is called. Setting the `rootViewController` in `viewDidLoad` or `viewWillAppear:animated` can cause weird behavior when setting the new frame.

 @warning If setting the `rootViewController` when the app returns to the foreground, the app should register for the `UIApplicationDidBecomeActive` notification and not the `UIApplicationWillEnterForeground` notification. Setting the frame after a notification from the latter can also cause weird behavior when setting the new frame.

 @warning While `viewDidLoad` will fire, appearance methods will not.
 */
@property (strong, nonatomic, nullable) UIViewController *rootViewController;

/**
 Declares if CarWindow will use layer rendering or view rendering. Defaults to layer rendering.
 */
@property (assign, nonatomic) SDLCarWindowRenderingType carWindowRenderingType;

/**
 When YES, the StreamingMediaManager will run a CADisplayLink with the framerate set to the video encoder settings kVTCompressionPropertyKey_ExpectedFrameRate. This then forces TouchManager (and CarWindow, if used) to sync their callbacks to the framerate. If using CarWindow, this *must* be YES. If NO, `enableSyncedPanning` on SDLTouchManager will be set to NO. Defaults to YES.
 */
@property (assign, nonatomic) BOOL enableForcedFramerateSync;

/**
 When YES, the StreamingMediaManager will disable its internal checks that the `rootViewController` only has one `supportedOrientation`. Having multiple orientations can cause streaming issues. If you wish to disable this check, set it to YES. Defaults to NO.
 */
@property (assign, nonatomic) BOOL allowMultipleViewControllerOrientations;

/**
 Set a landscape image dimension range and/or aspect ratio range that your rootViewController supports. If the module's screen size for your app changes during streaming (i.e. to a collapsed view, split screen, preview mode or picture-in-picture), your rootViewController will be resized to the new screen size. If left unset or set to `nil`, the default is to support all landscape streaming ranges. If you wish to disable support for streaming in landscape mode, set a `disabled` video streaming range.
 If desired, you can subscribe to screen size updates via the SDLStreamingVideoDelegate.
 @warning If you disable both the supportedLandscapeStreamingRange and supportedPortraitStreamingRange, video will not stream
 */
@property (strong, nonatomic, nullable) SDLVideoStreamingRange *supportedLandscapeStreamingRange;

/**
 Set a portrait image dimension range and/or aspect ratio range that your rootViewController supports. If the module's screen size for your app changes during streaming (i.e. to a collapsed view, split screen, preview mode or picture-in-picture), your rootViewController will be resized to the new screen size. If left unset or set to `nil`, the default is to support all portrait streaming ranges. If you wish to disable support for streaming in portrait mode, set a `disabled` video streaming range.
 If desired, you can subscribe to screen size updates via the SDLStreamingVideoDelegate.
 @warning If you disable both the supportedLandscapeStreamingRange and supportedPortraitStreamingRange, video will not stream
 */
@property (strong, nonatomic, nullable) SDLVideoStreamingRange *supportedPortraitStreamingRange;

/**
 The configuration delegate, this is an object conforming to the SDLStreamingVideoDelegate protocol. If video streaming parameters change then this object will be called on.
 */
@property (weak, nonatomic, nullable) id<SDLStreamingVideoDelegate> delegate;

/**
 Create an insecure video streaming configuration. No security managers will be provided and the encryption flag will be set to None. If you'd like custom video encoder settings, you can set the property manually.

 @return The configuration
 */
- (instancetype)init;

/**
 Create a secure video streaming configuration. Security managers will be provided from SDLEncryptionConfiguration and the encryption flag will be set to SDLStreamingEncryptionFlagAuthenticateAndEncrypt. If you'd like custom video encoder settings, you can set the property manually.

 @return The configuration
 */
+ (instancetype)secureConfiguration;

/**
 Manually set all the properties to the streaming media configuration

 @param encryptionFlag The maximum encryption supported. If the connected head unit supports less than set here, it will still connect, but if it supports more than set here, it will not connect.
 @param videoSettings Custom video encoder settings to be used in video streaming.
 @param rootViewController The UIViewController with the content that is being streamed on, to use for haptics if needed and possible (only works for UIViews)
 @return The configuration
 */
- (instancetype)initWithEncryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(nullable NSDictionary<NSString *, id> *)videoSettings dataSource:(nullable id<SDLStreamingMediaManagerDataSource>)dataSource rootViewController:(nullable UIViewController *)rootViewController __deprecated_msg("Use initWithEncryptionFlag:videoSettings:supportedLandscapeRange:supportedPortraitRange:dataSource:delegate:rootViewController:");

/// Manually set all the properties to the streaming media configuration
/// @param encryptionFlag The maximum encryption supported. If the connected head unit supports less than set here, it will still connect, but if it supports more than set here, it will not connect
/// @param videoSettings Custom video encoder settings to be used in video streaming
/// @param landscapeRange Set a landscape image dimension range and/or aspect ratio range that your app supports
/// @param portraitRange Set a portrait image dimension range and/or aspect ratio range that your rootViewController supports
/// @param dataSource Allows you to respond with preferred resolutions and/or formats
/// @param delegate Provides a delegate with notifications about changes to the audio stream
/// @param rootViewController A view controller that should be automatically streamed
- (instancetype)initWithEncryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(nullable NSDictionary<NSString *, id> *)videoSettings supportedLandscapeRange:(nullable SDLVideoStreamingRange *)landscapeRange supportedPortraitRange:(nullable SDLVideoStreamingRange *)portraitRange dataSource:(nullable id<SDLStreamingMediaManagerDataSource>)dataSource delegate:(nullable id<SDLStreamingVideoDelegate>)delegate rootViewController:(nullable UIViewController *)rootViewController;

/**
 Create an insecure video streaming configuration. No security managers will be provided and the encryption flag will be set to None. If you'd like custom video encoder settings, you can set the property manually. This is equivalent to `init`.

 @return The configuration
 */
+ (instancetype)insecureConfiguration NS_SWIFT_UNAVAILABLE("Use the standard initializer instead");

/**
 Create a CarWindow insecure configuration with a view controller

 @param initialViewController The initial view controller that will be streamed
 @return The configuration
 */
+ (instancetype)autostreamingInsecureConfigurationWithInitialViewController:(UIViewController *)initialViewController;

/**
 Create a CarWindow secure configuration with a view controller.

 @param initialViewController The initial view controller that will be streamed, this can be a basic `UIViewController` if you need to set your actual streaming view controller at a later time on `SDLManager.streamingManager.rootViewController`.
 @return The configuration
 */
+ (instancetype)autostreamingSecureConfigurationWithInitialViewController:(UIViewController *)initialViewController;

@end

NS_ASSUME_NONNULL_END
