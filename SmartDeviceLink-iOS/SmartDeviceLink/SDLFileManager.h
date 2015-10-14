//
//  SDLFileManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLFileName;

@interface SDLFileManager : NSObject

@property (copy, nonatomic, readonly) NSArray<SDLFileName *> *availableFiles;
@property (assign, nonatomic, readonly) NSUInteger bytesAvailable;

@end

NS_ASSUME_NONNULL_END
