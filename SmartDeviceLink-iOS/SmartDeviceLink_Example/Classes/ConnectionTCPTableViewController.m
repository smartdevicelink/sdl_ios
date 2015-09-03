//
//  ConnectionTCPTableViewController.m
//  SmartDeviceLink-iOS

@import AVFoundation;

#import "ConnectionTCPTableViewController.h"

#import "Preferences.h"
#import "ProxyManager.h"
#import "SDLStreamingMediaManager.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface ConnectionTCPTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@property (weak, nonatomic) IBOutlet UITableViewCell *connectTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;


@property (weak, nonatomic) IBOutlet UITableViewCell *videoTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

@end



@implementation ConnectionTCPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Observe Proxy Manager state
    [[ProxyManager sharedManager] addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:nil];
    
    // Tableview setup
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.ipAddressTextField.text = [Preferences sharedPreferences].ipAddress;
    self.portTextField.text = [Preferences sharedPreferences].port;
    
    // Connect Button setup
    self.connectButton.tintColor = [UIColor whiteColor];
    self.videoButton.tintColor = [UIColor whiteColor];
}

- (void)dealloc {
    @try {
        [[ProxyManager sharedManager] removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
    } @catch (NSException __unused *exception) {}
}


#pragma mark - IBActions

- (IBAction)connectButtonWasPressed:(UIButton *)sender {
    [Preferences sharedPreferences].ipAddress = self.ipAddressTextField.text;
    [Preferences sharedPreferences].port = self.portTextField.text;
    
    ProxyState state = [ProxyManager sharedManager].state;
    switch (state) {
        case ProxyStateStopped: {
            [[ProxyManager sharedManager] startProxyWithTransportType:ProxyTransportTypeTCP];
        } break;
        case ProxyStateSearchingForConnection: {
            [[ProxyManager sharedManager] stopProxy];
        } break;
        case ProxyStateConnected: {
            [[ProxyManager sharedManager] stopProxy];
        } break;
        default: break;
    }
}

- (IBAction)videoButtonPressed:(id)sender {
    ProxyState state = [ProxyManager sharedManager].state;
    switch (state) {
        case ProxyStateConnected: {
            [self showVideoPicker];
        } break;
        default: {
            NSLog(@"go away");
        }break;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [self.ipAddressTextField becomeFirstResponder];
        } break;
        case 1: {
            [self.portTextField becomeFirstResponder];
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


#pragma mark - UIImagePickerControllerDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"did finish picking media");
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        __block NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        
        [[ProxyManager sharedManager].mediaManager startVideoSessionWithStartBlock:^void (BOOL success, NSError *error) {
            if (success) {
                [self processImageBuffersFromURL:videoUrl withBlock:^(CVImageBufferRef bufferRef) {
                    if ([[ProxyManager sharedManager].mediaManager sendVideoData:bufferRef]) {
                        NSLog(@"successfully sent image buffer");
                    }
                    else {
                        NSLog(@"failed to process image buffer");
                    }
                }];
            } else {
                NSLog(@"Lol it didn't start");
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"Video selection canceled");
    // TODO: close the video session
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Private Methods

- (void)proxyManagerDidChangeState:(ProxyState)newState {
    switch (newState) {
        case ProxyStateStopped: {
            self.connectTableViewCell.backgroundColor = [UIColor redColor];
            self.connectButton.titleLabel.text = @"Connect";
            
            self.videoTableViewCell.backgroundColor = [UIColor redColor];
            self.videoButton.titleLabel.text = @"Select Video";
        } break;
        case ProxyStateSearchingForConnection: {
            self.connectTableViewCell.backgroundColor = [UIColor blueColor];
            self.connectButton.titleLabel.text = @"Stop Searching";
        } break;
        case ProxyStateConnected: {
            self.connectTableViewCell.backgroundColor = [UIColor greenColor];
            self.connectButton.titleLabel.text = @"Disconnect";
            
            self.videoTableViewCell.backgroundColor = [UIColor blueColor];
            self.videoButton.titleLabel.text = @"Select Video";
        } break;
        default: break;
    }
}

- (void)showVideoPicker {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)processImageBuffersFromURL:(NSURL *)url withBlock:(void (^)(CVImageBufferRef bufferRef))block {
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetTrack *track = [[asset
                            tracksWithMediaType:AVMediaTypeVideo]
                           objectAtIndex:0];
    
    AVAssetReaderTrackOutput
    *readerTrack = [AVAssetReaderTrackOutput
                    assetReaderTrackOutputWithTrack:track
                    outputSettings:@{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)}];
    AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:asset
                                                          error:nil];
    [reader addOutput:readerTrack];
    [reader startReading];
    
    CMSampleBufferRef sample = NULL;
    
    while ((sample = [readerTrack copyNextSampleBuffer])) {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sample);
        if (imageBuffer) {
            block(imageBuffer);
        }
    }
}
@end
