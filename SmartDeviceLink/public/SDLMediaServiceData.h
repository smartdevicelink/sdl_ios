//
//  SDLMediaServiceData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"
#import "SDLMediaType.h"

@class SDLImage;

NS_ASSUME_NONNULL_BEGIN


/**
 *  This data is related to what a media service should provide.
 */
@interface SDLMediaServiceData : SDLRPCStruct

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
- (instancetype)initWithMediaType:(nullable SDLMediaType)mediaType mediaImage:(nullable SDLImage *)mediaImage mediaTitle:(nullable NSString *)mediaTitle mediaArtist:(nullable NSString *)mediaArtist mediaAlbum:(nullable NSString *)mediaAlbum playlistName:(nullable NSString *)playlistName isExplicit:(BOOL)isExplicit trackPlaybackProgress:(UInt32)trackPlaybackProgress trackPlaybackDuration:(UInt32)trackPlaybackDuration queuePlaybackProgress:(UInt32)queuePlaybackProgress queuePlaybackDuration:(UInt32)queuePlaybackDuration queueCurrentTrackNumber:(UInt32)queueCurrentTrackNumber queueTotalTrackCount:(UInt32)queueTotalTrackCount;

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
