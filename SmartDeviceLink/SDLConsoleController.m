//  SDLConsoleController.m
//

#import "SDLConsoleController.h"

#import "SDLJsonEncoder.h"
#import "SDLRPCResponse.h"


@implementation SDLConsoleController

@synthesize messageList;

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self viewDidLoad];
    }
    return self;
}


- (void)append:(id)toAppend {
    dispatch_async(dispatch_get_main_queue(), ^{
        //Insert the new data
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

        [dictionary setObject:toAppend forKey:@"object"];
        [dictionary setObject:[NSDate date] forKey:@"date"];

        [messageList addObject:dictionary];
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:(messageList.count - 1) inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndex] withRowAnimation:UITableViewRowAnimationNone];

        //If we were at the bottom, scroll to the new bottom.
        if (atBottom) {
            [self.tableView scrollToRowAtIndexPath:newIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }

        [self.tableView reloadData];
    });
}

- (BOOL)isLastRowVisible {
    if (messageList.count == 0) {
        return YES;
    } else {
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:(messageList.count - 1) inSection:0];

        NSArray *visibleRowIndexes = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *aPath in visibleRowIndexes) {
            if ([aPath compare:lastIndex] == NSOrderedSame) {
                return YES;
            }
        }
    }
    return NO;
}


#pragma mark -
#pragma mark SDLDebugTool Console Delegate

- (void)logInfo:(NSString *)info {
    [self append:info];
}

- (void)logException:(NSException *)ex withMessage:(NSString *)message {
    [self append:message];
    [self append:[ex description]];
}

- (void)logMessage:(SDLRPCMessage *)message {
    [self append:message];
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [SDLDebugTool addConsole:self];

    [super viewDidLoad];

    atBottom = YES;

    messageList = [[NSMutableArray alloc] initWithCapacity:100];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss.SSS";
}

#pragma mark -
#pragma mark Scroll View Delegate

- (void)updateWhetherScrolledToBottom {
    if ([self isLastRowVisible]) {
        atBottom = YES;
    } else {
        atBottom = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateWhetherScrolledToBottom];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)willDecelerate {
    [self updateWhetherScrolledToBottom];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return messageList.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    NSDictionary *currentDictionary = [messageList objectAtIndex:indexPath.row];
    id msg = [currentDictionary objectForKey:@"object"];

    NSString *tempdetail = [@"Time: " stringByAppendingString:[dateFormatter stringFromDate:[currentDictionary objectForKey:@"date"]]];

    if ([msg isKindOfClass:SDLRPCMessage.class]) {
        SDLRPCMessage *rpc = msg;
        NSString *title = [NSString stringWithFormat:@"%@ (%@)", rpc.name, rpc.messageType];

        cell.textLabel.text = title;

        if ([rpc.messageType isEqualToString:@"response"]) {
            SDLRPCResponse *response = (SDLRPCResponse *)rpc;

            NSString *detail = [NSString stringWithFormat:@"%@ - %@", tempdetail, [response resultCode]];
            cell.detailTextLabel.text = detail;
        } else {
            cell.detailTextLabel.text = tempdetail;
        }

    } else {
        cell.textLabel.text = msg;
        cell.detailTextLabel.text = tempdetail;
    }

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *currentDictionary = [messageList objectAtIndex:indexPath.row];
    id obj = [currentDictionary objectForKey:@"object"];

    NSString *alertText = nil;
    if (obj == nil || [obj isKindOfClass:SDLRPCMessage.class]) {
        SDLRPCMessage *rpc = obj;
        NSDictionary *dictionary = [rpc serializeAsDictionary:2];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];

        if (!jsonData) {
            alertText = @"Error parsing the JSON.";
        } else {
            alertText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }

    } else {
        alertText = [NSString stringWithFormat:@"%@", [obj description]];
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RPCMessage", nil) message:alertText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    alertView = nil;

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
