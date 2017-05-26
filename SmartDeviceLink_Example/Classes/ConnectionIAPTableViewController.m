//
//  ConnectionIAPTableViewController.m
//  SmartDeviceLink-iOS

#import "ConnectionIAPTableViewController.h"

#import "ProxyManager.h"

@interface ConnectionIAPTableViewController ()

@end

@implementation ConnectionIAPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[ProxyManager sharedManager] addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:nil];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
	self.tableView.scrollEnabled = NO;

    self.connectButton.tintColor = [UIColor whiteColor];
}

- (void)dealloc {
    @try {
        [[ProxyManager sharedManager] removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
    } @catch (NSException __unused *exception) {}
}

#pragma mark - IBActions

- (IBAction)connectButtonWasPressed:(UIButton *)sender {
    ProxyState state = [ProxyManager sharedManager].state;
    switch (state) {
        case ProxyStateStopped: {
            [[ProxyManager sharedManager] startIAP];
        } break;
        case ProxyStateSearchingForConnection: {
            [[ProxyManager sharedManager] reset];
        } break;
        case ProxyStateConnected: {
            [[ProxyManager sharedManager] reset];
        } break;
        default: break;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(state))]) {
        ProxyState newState = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        [self proxyManagerDidChangeState:newState];
    }
}

#pragma mark - Private Methods

- (void)proxyManagerDidChangeState:(ProxyState)newState {
    UIColor* newColor = nil;
    NSString* newTitle = nil;

    switch (newState) {
        case ProxyStateStopped: {
            newColor = [UIColor redColor];
            newTitle = @"Connect";
        } break;
        case ProxyStateSearchingForConnection: {
            newColor = [UIColor blueColor];
            newTitle = @"Stop Searching";
        } break;
        case ProxyStateConnected: {
            newColor = [UIColor greenColor];
            newTitle = @"Disconnect";
        } break;
        default: break;
    }

    if (newColor || newTitle) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.connectTableViewCell setBackgroundColor:newColor];
            [self.connectButton setTitle:newTitle forState:UIControlStateNormal];
        });
    }
}

@end
