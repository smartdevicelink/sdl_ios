//
//  SDLCarWindowViewControllerProtocol.h
//  SmartDeviceLink
//
//  Created by Leonid Lokhmatov on 5/21/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLCarWindowViewControllerProtocol <NSObject>

@property (assign, nonatomic) CGRect viewportFrame;
- (void)resetViewportFrame;

@end

NS_ASSUME_NONNULL_END
