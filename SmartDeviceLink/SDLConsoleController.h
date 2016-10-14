//  SDLConsoleController.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SDLDebugTool.h"


@interface SDLConsoleController : UITableViewController <SDLDebugToolConsole> {
    NSMutableArray<NSDictionary<NSString *, id>*> *messageList;
    BOOL atBottom;
    NSDateFormatter *dateFormatter;
}

@property (strong, readonly) NSMutableArray<NSDictionary<NSString *, id>*> *messageList;

- (instancetype)initWithTableView:(UITableView *)tableView;


@end
