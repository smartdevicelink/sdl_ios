//
//  SDLDeleteChoicesOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLDeleteChoicesOperation.h"

#import "SDLChoiceCell.h"
#import "SDLConnectionManagerType.h"
#import "SDLDeleteInteractionChoiceSet.h"
#import "SDLError.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLDeleteChoicesOperation()

@property (strong, nonatomic) NSUUID *operationId;
@property (strong, nonatomic) NSSet<SDLChoiceCell *> *cellsToDelete;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic, nullable) NSError *internalError;
@property (copy, nonatomic) SDLDeleteChoicesCompletionHandler deleteCompletionHandler;

@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *mutableLoadedCells;

@end

@implementation SDLDeleteChoicesOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager cellsToDelete:(NSSet<SDLChoiceCell *> *)cellsToDelete loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells completionHandler:(SDLDeleteChoicesCompletionHandler)completionHandler {
    self = [super init];
    if (!self) {
        completionHandler(loadedCells, [NSError sdl_failedToCreateObjectOfClass:[SDLDeleteChoicesOperation class]]);
        return nil;
    }

    _connectionManager = connectionManager;
    _cellsToDelete = cellsToDelete;
    _mutableLoadedCells = [loadedCells mutableCopy];
    _operationId = [NSUUID UUID];
    _deleteCompletionHandler = completionHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    [self sdl_updateCellsToDelete];
    if (self.cellsToDelete.count == 0) { [self finishOperation]; }

    [self sdl_sendDeletions];
}

- (void)sdl_sendDeletions {
    NSMutableArray<SDLDeleteInteractionChoiceSet *> *deleteChoices = [NSMutableArray arrayWithCapacity:self.cellsToDelete.count];
    for (SDLChoiceCell *cell in self.cellsToDelete) {
        [deleteChoices addObject:[[SDLDeleteInteractionChoiceSet alloc] initWithId:cell.choiceId]];
    }

    __weak typeof(self) weakSelf = self;
    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    [self.connectionManager sendRequests:deleteChoices progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        SDLDeleteInteractionChoiceSet *sentRequest = (SDLDeleteInteractionChoiceSet *)request;
        if (error != nil) {
            errors[request] = error;
        } else {
            [self.mutableLoadedCells removeObject:[self sdl_loadedCellFromChoiceId:(UInt16)sentRequest.interactionChoiceSetID.unsignedIntValue]];
        }
    } completionHandler:^(BOOL success) {
        if (!success) {
            weakSelf.internalError = [NSError sdl_choiceSetManager_choiceDeletionFailed:errors];
        }

        [weakSelf finishOperation];
    }];
}

#pragma mark - Getters / Setters

- (void)setLoadedCells:(NSSet<SDLChoiceCell *> *)loadedCells {
    _mutableLoadedCells = [loadedCells mutableCopy];
}

- (NSSet<SDLChoiceCell *> *)loadedCells {
    return [_mutableLoadedCells copy];
}

#pragma mark - Helpers

- (void)sdl_updateCellsToDelete {
    // Remove cells that aren't loaded
    NSMutableSet<SDLChoiceCell *> *updatedCellsToDelete = [self.cellsToDelete mutableCopy];
    [updatedCellsToDelete intersectSet:self.loadedCells];

    // Update the choice ids on the cells to be deleted
    for (SDLChoiceCell *cell in updatedCellsToDelete) {
        SDLChoiceCell *uploadCell = [self.loadedCells member:cell];
        if (uploadCell == nil) { continue; }
        cell.choiceId = uploadCell.choiceId;
    }

    // Update our cells to delete
    self.cellsToDelete = [updatedCellsToDelete copy];
}

- (nullable SDLChoiceCell *)sdl_loadedCellFromChoiceId:(UInt16)choiceId {
    for (SDLChoiceCell *cell in self.loadedCells) {
        if (cell.choiceId == choiceId) { return cell; }
    }

    return nil;
}

#pragma mark - Property Overrides

- (void)finishOperation {
    self.deleteCompletionHandler(self.loadedCells, self.internalError);
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
