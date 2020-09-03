//
//  SDLChoiceCell.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 Livio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLArtwork;

NS_ASSUME_NONNULL_BEGIN

/// A selectable item within an SDLChoiceSet
@interface SDLChoiceCell: NSObject

/**
 Maps to Choice.menuName. The primary text of the cell. Duplicates within an `SDLChoiceSet` are not permitted and will result in the `SDLChoiceSet` failing to initialize.
 */
@property (copy, nonatomic, readonly) NSString *text;

/**
 Maps to Choice.secondaryText. Optional secondary text of the cell, if available. Duplicates within an `SDLChoiceSet` are permitted.
 */
@property (copy, nonatomic, readonly, nullable) NSString *secondaryText;

/**
 Maps to Choice.tertiaryText. Optional tertitary text of the cell, if available. Duplicates within an `SDLChoiceSet` are permitted.
 */
@property (copy, nonatomic, readonly, nullable) NSString *tertiaryText;

/**
 Maps to Choice.vrCommands. Optional voice commands the user can speak to activate the cell. If not set and the head unit requires it, this will be set to the number in the list that this item appears. However, this would be a very poor experience for a user if the choice set is presented as a voice only interaction or both interaction mode. Therefore, consider not setting this only when you know the choice set will be presented as a touch only interaction.
 */
@property (copy, nonatomic, readonly, nullable) NSArray<NSString *> *voiceCommands;

/**
 Maps to Choice.image. Optional image for the cell. This will be uploaded before the cell is used when the cell is preloaded or presented for the first time.
 */
@property (strong, nonatomic, readonly, nullable) SDLArtwork *artwork;

/**
 Maps to Choice.secondaryImage. Optional secondary image for the cell. This will be uploaded before the cell is used when the cell is preloaded or presented for the first time.
 */
@property (strong, nonatomic, readonly, nullable) SDLArtwork *secondaryArtwork;

/**
 Initialize the cell with nothing. This is unavailable

 @return A crash, probably
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Initialize the cell with text and nothing else.

 @param text The primary text of the cell.
 @return The cell
 */
- (instancetype)initWithText:(NSString *)text;

/**
 Initialize the cell with text, optional artwork, and optional voice commands

 @param text The primary text of the cell
 @param artwork The primary artwork of the cell
 @param voiceCommands Strings that can be spoken by the user to activate this cell in a voice or both interaction mode
 @return The cell
 */
- (instancetype)initWithText:(NSString *)text artwork:(nullable SDLArtwork *)artwork voiceCommands:(nullable NSArray<NSString *> *)voiceCommands;

/**
 Initialize the cell with all optional items

 @param text The primary text
 @param secondaryText The secondary text
 @param tertiaryText The tertiary text
 @param voiceCommands Strings that can be spoken by the user to activate this cell in a voice or both interaction mode
 @param artwork The primary artwork
 @param secondaryArtwork The secondary artwork
 @return The cell
 */
- (instancetype)initWithText:(NSString *)text secondaryText:(nullable NSString *)secondaryText tertiaryText:(nullable NSString *)tertiaryText voiceCommands:(nullable NSArray<NSString *> *)voiceCommands artwork:(nullable SDLArtwork *)artwork secondaryArtwork:(nullable SDLArtwork *)secondaryArtwork;

@end

NS_ASSUME_NONNULL_END
