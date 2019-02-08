//
//  SDLMediaServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLMediaServiceData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMediaServiceData

- (void)setMediaType:(nullable SDLMediaType)mediaType {
    [store sdl_setObject:mediaType forName:SDLNameMediaType];
}

- (nullable SDLMediaType)mediaType {
    return [store sdl_objectForName:SDLNameMediaType];
}

- (void)setMediaTitle:(nullable NSString *)mediaTitle {
    [store sdl_setObject:mediaTitle forName:SDLNameMediaTitle];
}

- (nullable NSString *)mediaTitle {
    return [store sdl_objectForName:SDLNameMediaTitle];
}

- (void)setMediaArtist:(nullable NSString *)mediaArtist {
    [store sdl_setObject:mediaArtist forName:SDLNameMediaArtist];
}

- (nullable NSString *)mediaArtist {
    return [store sdl_objectForName:SDLNameMediaArtist];
}

- (void)setMediaAlbum:(nullable NSString *)mediaAlbum {
    [store sdl_setObject:mediaAlbum forName:SDLNameMediaAlbum];
}

- (nullable NSString *)mediaAlbum {
    return [store sdl_objectForName:SDLNameMediaAlbum];
}

- (void)setPlaylistName:(nullable NSString *)playlistName {
    [store sdl_setObject:playlistName forName:SDLNamePlaylistName];
}

- (nullable NSString *)playlistName {
    return [store sdl_objectForName:SDLNamePlaylistName];
}

- (void)setIsExplicit:(nullable NSNumber<SDLBool> *)isExplicit {
    [store sdl_setObject:isExplicit forName:SDLNameIsExplicit];
}

- (nullable NSNumber<SDLBool> *)isExplicit {
    return [store sdl_objectForName:SDLNameIsExplicit];
}

- (void)setTrackPlaybackProgress:(nullable NSNumber<SDLInt> *)trackPlaybackProgress {
    [store sdl_setObject:trackPlaybackProgress forName:SDLNameTrackPlaybackProgress];
}

- (nullable NSNumber<SDLInt> *)trackPlaybackProgress {
    return [store sdl_objectForName:SDLNameTrackPlaybackProgress];
}

- (void)setTrackPlaybackDuration:(nullable NSNumber<SDLInt> *)trackPlaybackDuration {
    [store sdl_setObject:trackPlaybackDuration forName:SDLNameTrackPlaybackDuration];
}

- (nullable NSNumber<SDLInt> *)trackPlaybackDuration {
    return [store sdl_objectForName:SDLNameTrackPlaybackDuration];
}

- (void)setQueuePlaybackProgess:(nullable NSNumber<SDLInt> *)queuePlaybackProgess {
    [store sdl_setObject:queuePlaybackProgess forName:SDLNameQueuePlaybackProgess];
}

- (nullable NSNumber<SDLInt> *)queuePlaybackProgess {
    return [store sdl_objectForName:SDLNameQueuePlaybackProgess];
}

- (void)setQueuePlaybackDuration:(nullable NSNumber<SDLInt> *)queuePlaybackDuration {
    [store sdl_setObject:queuePlaybackDuration forName:SDLNameQueuePlaybackDuration];
}

- (nullable NSNumber<SDLInt> *)queuePlaybackDuration {
    return [store sdl_objectForName:SDLNameQueuePlaybackDuration];
}

- (void)setQueueCurrentTrackNumber:(nullable NSNumber<SDLInt> *)queueCurrentTrackNumber {
    [store sdl_setObject:queueCurrentTrackNumber forName:SDLNameQueueCurrentTrackNumber];
}

- (nullable NSNumber<SDLInt> *)queueCurrentTrackNumber {
    return [store sdl_objectForName:SDLNameQueueCurrentTrackNumber];
}

- (void)setQueueTotalTrackCount:(nullable NSNumber<SDLInt> *)queueTotalTrackCount {
    [store sdl_setObject:queueTotalTrackCount forName:SDLNameQueueTotalTrackCount];
}

- (nullable NSNumber<SDLInt> *)queueTotalTrackCount {
    return [store sdl_objectForName:SDLNameQueueTotalTrackCount];
}

@end

NS_ASSUME_NONNULL_END
