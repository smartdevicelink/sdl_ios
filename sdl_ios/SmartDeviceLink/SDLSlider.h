//  SDLSlider.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

/**
 * Creates a full screen or pop-up overlay (depending on platform) with a single
 * user controlled slider
 * <p>
 * Function Group: Base
 * <p>
 * <b>HMILevel needs to be FULL</b>
 * <p>
 *
 * Since AppLink 2.0
 *
 */
@interface SDLSlider : SDLRPCRequest {}

/**
 * @abstract Constructs a new SDLSlider object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLSlider object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract A number of selectable items on a horizontal axis
 * @discussion An Integer value representing a number of selectable items on
 *            a horizontal axis
 *            <p>
 *            <b>Notes: </b>Minvalue=2; Maxvalue=26
 */
@property(strong) NSNumber* numTicks;
/**
 * @abstract An Initial position of slider control
 * @discussion An Integer value representing an Initial position of slider
 *            control
 *            <p>
 *            <b>Notes: </b>Minvalue=1; Maxvalue=26
 */
@property(strong) NSNumber* position;
/**
 * @abstract A text header to display
 *
 * @param sliderHeader
 *            a String value
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property(strong) NSString* sliderHeader;
/**
 * @abstract A text footer to display
 * @discussion A Vector<String> value representing a text footer to display
 *            <p>
 *            <b>Notes: </b>Maxlength=500; Minvalue=1; Maxvalue=26
 */
@property(strong) NSMutableArray* sliderFooter;
/**
 * @abstract An App defined timeout
 * @discussion An Integer value representing an App defined timeout in milliseconds
 *            <p>
 *            <b>Notes: </b>Minvalue=0; Maxvalue=65535; Defvalue=10000
 */
@property(strong) NSNumber* timeout;

@end
