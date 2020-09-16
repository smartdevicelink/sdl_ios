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

@end

@implementation SDLDeleteChoicesOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager cellsToDelete:(NSSet<SDLChoiceCell *> *)cells {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _cellsToDelete = cells;
    _operationId = [NSUUID UUID];

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

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
        if (error != nil) {
            errors[request] = error;
        }
    } completionHandler:^(BOOL success) {
        if (!success) {
            weakSelf.internalError = [NSError sdl_choiceSetManager_choiceDeletionFailed:errors];
        }

        [weakSelf finishOperation];
    }];
}

#pragma mark - Property Overrides

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
