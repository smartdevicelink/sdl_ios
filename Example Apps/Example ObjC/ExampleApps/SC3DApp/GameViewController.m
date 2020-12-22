//
//  GameViewController.m
//  TestMetal
//
//  Created by Leonid Lokhmatov on 5/24/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import "GameViewController.h"

@interface GameViewController ()
@property (strong, nonatomic) IBOutlet SCNView *scnView;
@end


@interface FunnyRenderView : UIView
@property (strong, nonatomic) IBOutlet SCNView *scnView;
@end

@interface FunnyRenderLayer : CALayer
@property (strong, nonatomic) IBOutlet SCNView *scnView;
@end

@implementation FunnyRenderLayer

- (void)renderInContext:(CGContextRef)ctx {
    [self.delegate drawLayer:self inContext:ctx];
}

@end


@implementation FunnyRenderView

+ (Class)layerClass {
    return [FunnyRenderLayer class];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (layer == self.layer) {
        if (self.scnView) {
            CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
            CGContextFillRect(ctx, self.bounds);
            UIImage *image = self.scnView.snapshot;
            const CGRect rect = self.scnView.frame;
            CGContextDrawImage(ctx, rect, image.CGImage);
        }
    }
}

//- (BOOL)drawViewHierarchyInRect:(CGRect)rect afterScreenUpdates:(BOOL)afterUpdates {
//    BOOL ok = [super drawViewHierarchyInRect:rect afterScreenUpdates:afterUpdates];
//    [self.layer drawInContext:UIGraphicsGetCurrentContext()];
//    return ok;
//}


@end


@implementation GameViewController

+ (GameViewController*)createViewController {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"ExampleApps" bundle:nil];
    GameViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"idGameViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self startSceneView:self.scnView];
    self.view.layer.geometryFlipped = YES;

    // add a tap gesture recognizer
    [self setupRecognizer];
}

- (void)startSceneView:(SCNView *)scnView {
    // create a new scene
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];

    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];

    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 15);

    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];

    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];

    // retrieve the ship node
    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];

    // animate the 3d object
    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];

    // set the scene to the view
    scnView.scene = scene;

    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;

    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;

    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
}

- (void)setupRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:self.scnView.gestureRecognizers];
    self.scnView.gestureRecognizers = gestureRecognizers;
}

- (void)handleTap:(UIGestureRecognizer*)gestureRecognize {
    // retrieve the SCNView
    SCNView *scnView = self.scnView;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            material.emission.contents = [UIColor blackColor];
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    } else {
//        return UIInterfaceOrientationMaskAll;
//    }
//}

#pragma mark - SDLStreamingMediaDelegate

- (void)videoStreamingSizeDidUpdate:(CGSize)displaySize {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, NSStringFromCGSize(displaySize));
}

- (void)videoStreamingSizeDoesNotMatch {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
