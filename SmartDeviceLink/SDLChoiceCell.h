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

@interface SDLChoiceCell: NSObject

@property (copy, nonatomic, readonly) NSString *text;
@property (copy, nonatomic, readonly, nullable) NSString *secondaryText;
@property (copy, nonatomic, readonly, nullable) NSString *tertiaryText;
@property (copy, nonatomic, readonly, nullable) NSArray<NSString *> *voiceCommands;
@property (strong, nonatomic, readonly, nullable) SDLArtwork *artwork;
@property (strong, nonatomic, readonly, nullable) SDLArtwork *secondaryArtwork;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithText:(NSString *)text artwork:(nullable SDLArtwork *)artwork voiceCommands:(nullable NSArray<NSString *> *)voiceCommands;
- (instancetype)initWithText:(NSString *)text secondaryText:(nullable NSString *)secondaryText tertiaryText:(nullable NSString *)tertiaryText voiceCommands:(nullable NSArray<NSString *> *)voiceCommands artwork:(nullable SDLArtwork *)artwork secondaryArtwork:(nullable SDLArtwork *)secondaryArtwork;

@end

NS_ASSUME_NONNULL_END
