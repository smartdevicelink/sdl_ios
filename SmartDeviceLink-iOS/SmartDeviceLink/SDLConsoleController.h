//  SDLConsoleController.h
//

@import Foundation;
@import UIKit;

#import "SDLDebugTool.h"


@interface SDLConsoleController : UITableViewController <SDLDebugToolConsole> {
	NSMutableArray* messageList;
    BOOL atBottom;
    NSDateFormatter* dateFormatter;
}

@property (strong, readonly) NSMutableArray *messageList;

-(instancetype) initWithTableView:(UITableView*) tableView;


@end
