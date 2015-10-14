//
//  SDLFileManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLFileManager.h"

#import "SDLListFiles.h"
#import "SDLNotificationConstants.h"
#import "SDLRPCRequestFactory.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLFileManager ()

@property (copy, nonatomic, readwrite) NSArray<SDLFileName *> *availableFiles;

@end


@implementation SDLFileManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _availableFiles = @[];
    _bytesAvailable = 0;
    
    // TODO: Should somehow notify devs after we have gotten the list files and they can start to send, or we should queue up the stuff.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didConnect:) name:SDLDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didDisconnect:) name:SDLDidDisconnectNotification object:nil];
    
    return self;
}


#pragma mark - SDL Notifications

- (void)sdl_didConnect:(NSNotification *)notification {
    // TODO: List files
    SDLListFiles *listFiles = [SDLRPCRequestFactory buildListFilesWithCorrelationID:@0];
}

- (void)sdl_didDisconnect:(NSNotification *)notification {
    // TODO: Reset properties
}

@end

NS_ASSUME_NONNULL_END
