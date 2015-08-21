//  SDLTouchEvent.h
//


#import "SDLRPCMessage.h"

@interface SDLTouchEvent : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 A touch's unique identifier.  The application can track the current touch events by id.
 If a touch event has type begin, the id should be added to the set of touches.
 If a touch event has type end, the id should be removed from the set of touches.
 
 Mandatory, 0-9
 */
@property (strong) NSNumber *touchEventId;

/**
 The time that the touch was recorded.  This number can the time since the beginning of the session or something else as long as the units are in milliseconds.
 
 The timestamp is used to determined the rate of change of position of a touch.
 
 The application also uses the time to verify whether two touches, with different ids, are part of a single action by the user.
 
 If there is only a single timestamp in this array, it is the same for every coordinate in the coordinates array.
 
 Mandatory, array size 1-1000, contains <NSNumber> size 0-5000000000
 */
@property (strong) NSMutableArray *timeStamp;

/**
 *  Mandatory, array size 1-1000, contains SDLTouchCoord
 */
@property (strong) NSMutableArray *coord;

@end
