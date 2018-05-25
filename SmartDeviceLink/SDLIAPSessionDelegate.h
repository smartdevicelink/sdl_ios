//
//  SDLIAPSessionDelegate.h
//

#import <Foundation/Foundation.h>
@class SDLIAPSession;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLIAPSessionDelegate

/**
 *  Session initialized
 *
 *  @param session A SDLIAPSession object
 */
- (void)onSessionInitializationCompleteForSession:(SDLIAPSession *)session;


/**
 *  Session ended
 *
 *  @param session A SDLIAPSession object
 */
- (void)onSessionStreamsEnded:(SDLIAPSession *)session;

@end

NS_ASSUME_NONNULL_END
