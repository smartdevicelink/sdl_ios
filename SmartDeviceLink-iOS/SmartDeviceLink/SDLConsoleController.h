//  SDLConsoleController.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SDLDebugTool.h"


@interface SDLConsoleController : UITableViewController <SDLDebugToolConsole> {
    NSMutableArray *messageList;
    BOOL atBottom;
    NSDateFormatter *dateFormatter;
}

@property (strong, readonly) NSMutableArray *messageList;

- (instancetype)initWithTableView:(UITableView *)tableView;


@end
