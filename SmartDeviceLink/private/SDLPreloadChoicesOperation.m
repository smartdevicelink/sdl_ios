//
//  SDLPreloadChoicesOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLPreloadChoicesOperation.h"

#import "SDLChoice.h"
#import "SDLChoiceCell.h"
#import "SDLConnectionManagerType.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLCreateInteractionChoiceSetResponse.h"
#import "SDLDisplayType.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLImage.h"
#import "SDLLogMacros.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLPreloadChoicesOperation()

@property (strong, nonatomic) NSUUID *operationId;
@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *cellsToUpload;
@property (strong, nonatomic) SDLWindowCapability *windowCapability;
@property (strong, nonatomic) NSString *displayName;
@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLPreloadChoicesOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)defaultMainWindowCapability isVROptional:(BOOL)isVROptional cellsToPreload:(NSSet<SDLChoiceCell *> *)cells {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _displayName = displayName;
    _windowCapability = defaultMainWindowCapability;
    _vrOptional = isVROptional;
    _cellsToUpload = [cells mutableCopy];
    _operationId = [NSUUID UUID];

    _currentState = SDLPreloadChoicesOperationStateWaitingToStart;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    [self sdl_preloadCellArtworksWithCompletionHandler:^(NSError * _Nullable error) {
        self.internalError = error;
        
        [self sdl_preloadCells];
    }];
}

- (BOOL)removeChoicesFromUpload:(NSSet<SDLChoiceCell *> *)choices {
    if (self.isExecuting) { return NO; }

    [self.cellsToUpload minusSet:choices];
    return YES;
}

#pragma mark - Sending Choice Data

- (void)sdl_preloadCellArtworksWithCompletionHandler:(void(^)(NSError *_Nullable))completionHandler {
    _currentState = SDLPreloadChoicesOperationStateUploadingArtworks;

    NSMutableArray<SDLArtwork *> *artworksToUpload = [NSMutableArray arrayWithCapacity:self.cellsToUpload.count];
    for (SDLChoiceCell *cell in self.cellsToUpload) {
        if ([self sdl_shouldSendChoicePrimaryImage] && [self sdl_artworkNeedsUpload:cell.artwork]) {
            [artworksToUpload addObject:cell.artwork];
        }
        if ([self sdl_shouldSendChoiceSecondaryImage] && [self sdl_artworkNeedsUpload:cell.secondaryArtwork]) {
            [artworksToUpload addObject:cell.secondaryArtwork];
        }
    }

    if (artworksToUpload.count == 0) {
        SDLLogD(@"No choice artworks to be uploaded");
        completionHandler(nil);
        return;
    }

    [self.fileManager uploadArtworks:[artworksToUpload copy] completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error uploading choice artworks: %@", error);
        } else {
            SDLLogD(@"Finished uploading choice artworks");
            SDLLogV(@"%@", artworkNames);
        }

        completionHandler(error);
    }];
}

- (BOOL)sdl_artworkNeedsUpload:(SDLArtwork *)artwork {
    return (artwork != nil && ![self.fileManager hasUploadedFile:artwork] && !artwork.isStaticIcon);
}

- (void)sdl_preloadCells {
    _currentState = SDLPreloadChoicesOperationStatePreloadingChoices;

    NSMutableArray<SDLCreateInteractionChoiceSet *> *choiceRPCs = [NSMutableArray arrayWithCapacity:self.cellsToUpload.count];
    for (SDLChoiceCell *cell in self.cellsToUpload) {
        SDLCreateInteractionChoiceSet *csCell =  [self sdl_choiceFromCell:cell];
        if(csCell != nil) {
            [choiceRPCs addObject:csCell];
        }
    }
    if (choiceRPCs.count == 0) {
        SDLLogE(@"All choice cells to send are nil, so the choice set will not be shown");
        self.internalError = [NSError sdl_choiceSetManager_failedToCreateMenuItems];
        [self finishOperation];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    [self.connectionManager sendRequests:[choiceRPCs copy] progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        }
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Error preloading choice cells: %@", errors);
            weakSelf.internalError = [NSError sdl_choiceSetManager_choiceUploadFailed:errors];
        }

        SDLLogD(@"Finished preloading choice cells");

        [weakSelf finishOperation];
    }];
}

#pragma mark - Assembling Choice Data

- (nullable SDLCreateInteractionChoiceSet *)sdl_choiceFromCell:(SDLChoiceCell *)cell {
    NSArray<NSString *> *vrCommands = nil;
    if (cell.voiceCommands == nil) {
        vrCommands = self.isVROptional ? nil : @[[NSString stringWithFormat:@"%hu", cell.choiceId]];
    } else {
        vrCommands = cell.voiceCommands;
    }

    NSString *menuName = nil;
    if ([self sdl_shouldSendChoiceText]) {
        menuName = cell.text;
    }

    if(!menuName) {
        SDLLogE(@"Could not convert SDLChoiceCell to SDLCreateInteractionChoiceSet. It will not be shown. Cell: %@", cell);
        return nil;
    }
    
    NSString *secondaryText = [self sdl_shouldSendChoiceSecondaryText] ? cell.secondaryText : nil;
    NSString *tertiaryText = [self sdl_shouldSendChoiceTertiaryText] ? cell.tertiaryText : nil;

    SDLImage *image = [self sdl_shouldSendChoicePrimaryImage] ? cell.artwork.imageRPC : nil;
    SDLImage *secondaryImage = [self sdl_shouldSendChoiceSecondaryImage] ? cell.secondaryArtwork.imageRPC : nil;

    SDLChoice *choice = [[SDLChoice alloc] initWithId:cell.choiceId menuName:(NSString *_Nonnull)menuName vrCommands:(NSArray<NSString *> * _Nonnull)vrCommands image:image secondaryText:secondaryText secondaryImage:secondaryImage tertiaryText:tertiaryText];

    return [[SDLCreateInteractionChoiceSet alloc] initWithId:(UInt32)choice.choiceID.unsignedIntValue choiceSet:@[choice]];
}

/// Determine if we should send primary text. If textFields is nil, we don't know the capabilities and we will send everything.
- (BOOL)sdl_shouldSendChoiceText {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([self.displayName isEqualToString:SDLDisplayTypeGen38Inch]) {
        return YES;
    }
#pragma clang diagnostic pop

    return [self.windowCapability hasTextFieldOfName:SDLTextFieldNameMenuName];
}

/// Determine if we should send secondary text. If textFields is nil, we don't know the capabilities and we will send everything.
- (BOOL)sdl_shouldSendChoiceSecondaryText {
    return [self.windowCapability hasTextFieldOfName:SDLTextFieldNameSecondaryText];
}

/// Determine if we should send teriary text. If textFields is nil, we don't know the capabilities and we will send everything.
- (BOOL)sdl_shouldSendChoiceTertiaryText {
    return [self.windowCapability hasTextFieldOfName:SDLTextFieldNameTertiaryText];
}

/// Determine if we should send the primary image. If imageFields is nil, we don't know the capabilities and we will send everything.
- (BOOL)sdl_shouldSendChoicePrimaryImage {
    return [self.windowCapability hasImageFieldOfName:SDLImageFieldNameChoiceImage];
}

/// Determine if we should send the secondary image. If imageFields is nil, we don't know the capabilities and we will send everything.
- (BOOL)sdl_shouldSendChoiceSecondaryImage {
    return [self.windowCapability hasImageFieldOfName:SDLImageFieldNameChoiceSecondaryImage];
}

#pragma mark - Property Overrides

- (void)finishOperation {
    _currentState = SDLPreloadChoicesOperationStateFinished;

    [super finishOperation];
}

- (nullable NSString *)name {
    return [NSString stringWithFormat:@"%@ - %@", self.class, self.operationId];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
