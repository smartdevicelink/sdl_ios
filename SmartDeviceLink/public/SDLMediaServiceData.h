/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "SDLRPCRequest.h"
#import "SDLMediaType.h"

@class SDLImage;

NS_ASSUME_NONNULL_BEGIN


/**
 *  This data is related to what a media service should provide.
 */
@interface SDLMediaServiceData : SDLRPCStruct

/**
 * @param mediaType - mediaType
 * @param mediaTitle - mediaTitle
 * @param mediaArtist - mediaArtist
 * @param mediaAlbum - mediaAlbum
 * @param playlistName - playlistName
 * @param isExplicit - isExplicit
 * @param trackPlaybackProgress - trackPlaybackProgress
 * @param trackPlaybackDuration - trackPlaybackDuration
 * @param queuePlaybackProgress - queuePlaybackProgress
 * @param queuePlaybackDuration - queuePlaybackDuration
 * @param queueCurrentTrackNumber - queueCurrentTrackNumber
 * @param queueTotalTrackCount - queueTotalTrackCount
 * @param mediaImage - mediaImage
 * @return A SDLMediaServiceData object
 */
- (instancetype)initWithMediaType:(nullable SDLMediaType)mediaType mediaTitle:(nullable NSString *)mediaTitle mediaArtist:(nullable NSString *)mediaArtist mediaAlbum:(nullable NSString *)mediaAlbum playlistName:(nullable NSString *)playlistName isExplicit:(nullable NSNumber<SDLBool> *)isExplicit trackPlaybackProgress:(nullable NSNumber<SDLInt> *)trackPlaybackProgress trackPlaybackDuration:(nullable NSNumber<SDLInt> *)trackPlaybackDuration queuePlaybackProgress:(nullable NSNumber<SDLInt> *)queuePlaybackProgress queuePlaybackDuration:(nullable NSNumber<SDLInt> *)queuePlaybackDuration queueCurrentTrackNumber:(nullable NSNumber<SDLInt> *)queueCurrentTrackNumber queueTotalTrackCount:(nullable NSNumber<SDLInt> *)queueTotalTrackCount mediaImage:(nullable SDLImage *)mediaImage;

/**
 *  Convenience init
 *
 *  @param mediaType                The type of the currently playing or paused track
 *  @param mediaImage               The current artwork for the playing media.
 *  @param mediaTitle               The name of the current playing media
 *  @param mediaArtist              The name of the current media artist
 *  @param mediaAlbum               The name of the current media album
 *  @param playlistName             The name of the playlist
 *  @param isExplicit               Whether or not the content currently playing contains explicit content
 *  @param trackPlaybackProgress    The current progress of the track
 *  @param trackPlaybackDuration    The total duration of the track
 *  @param queuePlaybackProgress     The current progress of the playback queue in seconds
 *  @param queuePlaybackDuration    The total duration of the playback queue in seconds
 *  @param queueCurrentTrackNumber  The current number (1 based) of the track in the playback queue
 *  @param queueTotalTrackCount     The total number of tracks in the playback queue
 *  @return                         A SDLMediaServiceData object
 */
- (instancetype)initWithMediaType:(nullable SDLMediaType)mediaType mediaImage:(nullable SDLImage *)mediaImage mediaTitle:(nullable NSString *)mediaTitle mediaArtist:(nullable NSString *)mediaArtist mediaAlbum:(nullable NSString *)mediaAlbum playlistName:(nullable NSString *)playlistName isExplicit:(BOOL)isExplicit trackPlaybackProgress:(UInt32)trackPlaybackProgress trackPlaybackDuration:(UInt32)trackPlaybackDuration queuePlaybackProgress:(UInt32)queuePlaybackProgress queuePlaybackDuration:(UInt32)queuePlaybackDuration queueCurrentTrackNumber:(UInt32)queueCurrentTrackNumber queueTotalTrackCount:(UInt32)queueTotalTrackCount __deprecated_msg("Use another initializer instead");

/**
 * Sets the media image associated with the currently playing media
 * Music: The album art of the current track
 * Podcast: The podcast or chapter artwork of the current podcast episode
 * Audiobook: The book or chapter artwork of the current audiobook
 *
 * SDLImage,  Optional
 */
@property (nullable, strong, nonatomic) SDLImage *mediaImage;

/**
 *  The type of the currently playing or paused track.
 *
 *  SDLMediaType, Optional
 */
@property (nullable, strong, nonatomic) SDLMediaType mediaType;

/**
 *  Music: The name of the current track
 *  Podcast: The name of the current episode
 *  Audiobook: The name of the current chapter
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *mediaTitle;

/**
 *  Music: The name of the current album artist
 *  Podcast: The provider of the podcast (hosts, network, company)
 *  Audiobook: The book author's name
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *mediaArtist;

/**
 *  Music: The name of the current album
 *  Podcast: The name of the current podcast show
 *  Audiobook: The name of the current book
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *mediaAlbum;

/**
 *  Music: The name of the playlist or radio station, if the user is playing from a playlist, otherwise, Null
 *  Podcast: The name of the playlist, if the user is playing from a playlist, otherwise, Null
 *  Audiobook: Likely not applicable, possibly a collection or "playlist" of books
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *playlistName;

/**
 *  Whether or not the content currently playing (e.g. the track, episode, or book) contains explicit content.
 *
 *  Boolean, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *isExplicit;

/**
 *  Music: The current progress of the track in seconds
 *  Podcast: The current progress of the episode in seconds
 *  Audiobook: The current progress of the current segment (e.g. the chapter) in seconds
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *trackPlaybackProgress;

/**
 *  Music: The total duration of the track in seconds
 *  Podcast: The total duration of the episode in seconds
 *  Audiobook: The total duration of the current segment (e.g. the chapter) in seconds
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *trackPlaybackDuration;

/**
 *  Music: The current progress of the playback queue in seconds
 *  Podcast: The current progress of the playback queue in seconds
 *  Audiobook: The current progress of the playback queue (e.g. the book) in seconds
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *queuePlaybackProgress;

/**
 *  Music: The total duration of the playback queue in seconds
 *  Podcast: The total duration of the playback queue in seconds
 *  Audiobook: The total duration of the playback queue (e.g. the book) in seconds
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *queuePlaybackDuration;

/**
 *  Music: The current number (1 based) of the track in the playback queue
 *  Podcast: The current number (1 based) of the episode in the playback queue
 *  Audiobook: The current number (1 based) of the episode in the playback queue (e.g. the chapter number in the book)
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *queueCurrentTrackNumber;

/**
 *  Music: The total number of tracks in the playback queue
 *  Podcast: The total number of episodes in the playback queue
 *  Audiobook: The total number of sections in the playback queue (e.g. the number of chapters in the book)
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *queueTotalTrackCount;

@end

NS_ASSUME_NONNULL_END
