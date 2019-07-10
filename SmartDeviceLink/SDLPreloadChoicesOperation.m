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
#import "SDLDisplayCapabilities.h"
#import "SDLDisplayCapabilities+ShowManagerExtensions.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLImage.h"
#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLPreloadChoicesOperation()

@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *cellsToUpload;
@property (strong, nonatomic) SDLDisplayCapabilities *displayCapabilities;
@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLPreloadChoicesOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager displayCapabilities:(SDLDisplayCapabilities *)displayCapabilities isVROptional:(BOOL)isVROptional cellsToPreload:(NSSet<SDLChoiceCell *> *)cells {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _displayCapabilities = displayCapabilities;
    _vrOptional = isVROptional;
    _cellsToUpload = [cells mutableCopy];

    _currentState = SDLPreloadChoicesOperationStateWaitingToStart;

    return self;
}

- (void)start {
    [super start];

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
        if ([self.displayCapabilities hasImageFieldOfName:SDLImageFieldNameChoiceImage]
            && [self sdl_artworkNeedsUpload:cell.artwork]) {
            [artworksToUpload addObject:cell.artwork];
        }
        if ([self.displayCapabilities hasImageFieldOfName:SDLImageFieldNameChoiceSecondaryImage]
            && [self sdl_artworkNeedsUpload:cell.secondaryArtwork]) {
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([self.displayCapabilities.displayType isEqualToEnum:SDLDisplayTypeGen38Inch] || [self.displayCapabilities hasTextFieldOfName:SDLTextFieldNameMenuName]) {
        menuName = cell.text;
    }
#pragma clang diagnostic pop

    if(!menuName) {
        SDLLogE(@"Could not convert SDLChoiceCell to SDLCreateInteractionChoiceSet. It will not be shown. Cell: %@", cell);
        return nil;
    }
    
    NSString *secondaryText = [self.displayCapabilities hasTextFieldOfName:SDLTextFieldNameSecondaryText] ? cell.secondaryText : nil;
    NSString *tertiaryText = [self.displayCapabilities hasTextFieldOfName:SDLTextFieldNameTertiaryText] ? cell.tertiaryText : nil;

    SDLImage *image = ([self.displayCapabilities hasImageFieldOfName:SDLImageFieldNameChoiceImage] && cell.artwork != nil) ? cell.artwork.imageRPC : nil;
    SDLImage *secondaryImage = ([self.displayCapabilities hasImageFieldOfName:SDLImageFieldNameChoiceSecondaryImage] && cell.secondaryArtwork != nil) ? cell.secondaryArtwork.imageRPC : nil;

    SDLChoice *choice = [[SDLChoice alloc] initWithId:cell.choiceId menuName:(NSString *_Nonnull)menuName vrCommands:(NSArray<NSString *> * _Nonnull)vrCommands image:image secondaryText:secondaryText secondaryImage:secondaryImage tertiaryText:tertiaryText];

    return [[SDLCreateInteractionChoiceSet alloc] initWithId:(UInt32)choice.choiceID.unsignedIntValue choiceSet:@[choice]];
}

#pragma mark - Property Overrides

- (void)finishOperation {
    _currentState = SDLPreloadChoicesOperationStateFinished;

    [super finishOperation];
}

- (nullable NSString *)name {
    return @"com.sdl.choicesetmanager.preloadChoices";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
