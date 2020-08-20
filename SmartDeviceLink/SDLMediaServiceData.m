//
//  SDLMediaServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLMediaServiceData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLImage.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMediaServiceData

- (instancetype)initWithMediaType:(nullable SDLMediaType)mediaType mediaImage:(nullable SDLImage *)mediaImage mediaTitle:(nullable NSString *)mediaTitle mediaArtist:(nullable NSString *)mediaArtist mediaAlbum:(nullable NSString *)mediaAlbum playlistName:(nullable NSString *)playlistName isExplicit:(BOOL)isExplicit trackPlaybackProgress:(UInt32)trackPlaybackProgress trackPlaybackDuration:(UInt32)trackPlaybackDuration queuePlaybackProgress:(UInt32)queuePlaybackProgress queuePlaybackDuration:(UInt32)queuePlaybackDuration queueCurrentTrackNumber:(UInt32)queueCurrentTrackNumber queueTotalTrackCount:(UInt32)queueTotalTrackCount {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.mediaType = mediaType;
    self.mediaImage = mediaImage;
    self.mediaTitle = mediaTitle;
    self.mediaArtist = mediaArtist;
    self.mediaAlbum = mediaAlbum;
    self.playlistName = playlistName;
    self.isExplicit = @(isExplicit);
    self.trackPlaybackProgress = @(trackPlaybackProgress);
    self.trackPlaybackDuration = @(trackPlaybackDuration);
    self.queuePlaybackProgress = @(queuePlaybackProgress);
    self.queuePlaybackDuration = @(queuePlaybackDuration);
    self.queueCurrentTrackNumber = @(queueCurrentTrackNumber);
    self.queueTotalTrackCount = @(queueTotalTrackCount);

    return self;
}

- (void)setMediaImage:(nullable SDLImage *)mediaImage {
    [self.store sdl_setObject:mediaImage forName:SDLRPCParameterNameMediaImage];
}

- (nullable SDLImage *)mediaImage {
    return [self.store sdl_objectForName:SDLRPCParameterNameMediaImage ofClass:SDLImage.class error:nil];
}

- (void)setMediaType:(nullable SDLMediaType)mediaType {
    [self.store sdl_setObject:mediaType forName:SDLRPCParameterNameMediaType];
}

- (nullable SDLMediaType)mediaType {
    return [self.store sdl_enumForName:SDLRPCParameterNameMediaType error:nil];
}

- (void)setMediaTitle:(nullable NSString *)mediaTitle {
    [self.store sdl_setObject:mediaTitle forName:SDLRPCParameterNameMediaTitle];
}

- (nullable NSString *)mediaTitle {
    return [self.store sdl_objectForName:SDLRPCParameterNameMediaTitle ofClass:NSString.class error:nil];
}

- (void)setMediaArtist:(nullable NSString *)mediaArtist {
    [self.store sdl_setObject:mediaArtist forName:SDLRPCParameterNameMediaArtist];
}

- (nullable NSString *)mediaArtist {
    return [self.store sdl_objectForName:SDLRPCParameterNameMediaArtist ofClass:NSString.class error:nil];
}

- (void)setMediaAlbum:(nullable NSString *)mediaAlbum {
    [self.store sdl_setObject:mediaAlbum forName:SDLRPCParameterNameMediaAlbum];
}

- (nullable NSString *)mediaAlbum {
    return [self.store sdl_objectForName:SDLRPCParameterNameMediaAlbum ofClass:NSString.class error:nil];
}

- (void)setPlaylistName:(nullable NSString *)playlistName {
    [self.store sdl_setObject:playlistName forName:SDLRPCParameterNamePlaylistName];
}

- (nullable NSString *)playlistName {
    return [self.store sdl_objectForName:SDLRPCParameterNamePlaylistName ofClass:NSString.class error:nil];
}

- (void)setIsExplicit:(nullable NSNumber<SDLBool> *)isExplicit {
    [self.store sdl_setObject:isExplicit forName:SDLRPCParameterNameIsExplicit];
}

- (nullable NSNumber<SDLBool> *)isExplicit {
    return [self.store sdl_objectForName:SDLRPCParameterNameIsExplicit ofClass:NSNumber.class error:nil];
}

- (void)setTrackPlaybackProgress:(nullable NSNumber<SDLInt> *)trackPlaybackProgress {
    [self.store sdl_setObject:trackPlaybackProgress forName:SDLRPCParameterNameTrackPlaybackProgress];
}

- (nullable NSNumber<SDLInt> *)trackPlaybackProgress {
    return [self.store sdl_objectForName:SDLRPCParameterNameTrackPlaybackProgress ofClass:NSNumber.class error:nil];
}

- (void)setTrackPlaybackDuration:(nullable NSNumber<SDLInt> *)trackPlaybackDuration {
    [self.store sdl_setObject:trackPlaybackDuration forName:SDLRPCParameterNameTrackPlaybackDuration];
}

- (nullable NSNumber<SDLInt> *)trackPlaybackDuration {
    return [self.store sdl_objectForName:SDLRPCParameterNameTrackPlaybackDuration ofClass:NSNumber.class error:nil];
}

- (void)setQueuePlaybackProgress:(nullable NSNumber<SDLInt> *)queuePlaybackProgress {
    [self.store sdl_setObject:queuePlaybackProgress forName:SDLRPCParameterNameQueuePlaybackProgress];
}

- (nullable NSNumber<SDLInt> *)queuePlaybackProgress {
    return [self.store sdl_objectForName:SDLRPCParameterNameQueuePlaybackProgress ofClass:NSNumber.class error:nil];
}

- (void)setQueuePlaybackDuration:(nullable NSNumber<SDLInt> *)queuePlaybackDuration {
    [self.store sdl_setObject:queuePlaybackDuration forName:SDLRPCParameterNameQueuePlaybackDuration];
}

- (nullable NSNumber<SDLInt> *)queuePlaybackDuration {
    return [self.store sdl_objectForName:SDLRPCParameterNameQueuePlaybackDuration ofClass:NSNumber.class error:nil];
}

- (void)setQueueCurrentTrackNumber:(nullable NSNumber<SDLInt> *)queueCurrentTrackNumber {
    [self.store sdl_setObject:queueCurrentTrackNumber forName:SDLRPCParameterNameQueueCurrentTrackNumber];
}

- (nullable NSNumber<SDLInt> *)queueCurrentTrackNumber {
    return [self.store sdl_objectForName:SDLRPCParameterNameQueueCurrentTrackNumber ofClass:NSNumber.class error:nil];
}

- (void)setQueueTotalTrackCount:(nullable NSNumber<SDLInt> *)queueTotalTrackCount {
    [self.store sdl_setObject:queueTotalTrackCount forName:SDLRPCParameterNameQueueTotalTrackCount];
}

- (nullable NSNumber<SDLInt> *)queueTotalTrackCount {
    return [self.store sdl_objectForName:SDLRPCParameterNameQueueTotalTrackCount ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
