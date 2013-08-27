//
//  ControllerVC.m
//  Tarval
//
//  Created by Steve Gattuso on 8/27/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import "ControllerVC.h"
#import "PairingVC.h"
#import "TRControllerButton.h"
#import "AppDelegate.h"
#import "TRWebsocketMC.h"

@implementation ControllerVC

@synthesize websocketMC;

- (void)viewDidLoad
{
  [super viewDidLoad];
  AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  self.websocketMC = appDelegate.websocketModelController;
  
  // Set up accelerometer listening
  motionManager = [[CMMotionManager alloc] init];
  motionManager.accelerometerUpdateInterval = .050;
  [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
      withHandler:^(CMAccelerometerData *data, NSError *error) {
    
    if(fabs(data.acceleration.y) < .4) {
      if(previousAccelerometerValue != 0) {
        [self.websocketMC sendEvent:@"stopTilt" data:nil];
      }
      
      previousAccelerometerValue = 0;
      return;
    }
    
    if(previousAccelerometerValue == 0) {
      [self.websocketMC sendEvent:@"tilt" data:@{
        @"v": [NSNumber numberWithFloat:data.acceleration.y]
      }];
      
      if(data.acceleration.y > 0) {
        previousAccelerometerValue = 1;
      } else {
        previousAccelerometerValue = -1;
      }
    }
  }];
  
  // Listen for setPin event
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self selector:@selector(receiveSetPinNotification:)
      name:@"ws:setPin" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
  // If no pin has been set, show PairingVC
  if(!havePin) {
    PairingVC *viewController = (PairingVC*)[self.storyboard
        instantiateViewControllerWithIdentifier:@"PairingVC"];
    
    viewController.websocketMC = self.websocketMC;
    [self presentViewController:viewController animated:YES completion:nil];
  }
}

#pragma mark NSNotificationCenter listeners
- (void)receiveSetPinNotification:(NSNotification *)notification
{
  havePin = YES;
}

#pragma mark IBActions
- (IBAction)pressControllerButton:(UIButton*)sender
{
  [self.websocketMC sendEvent:@"keyDown" data:@{
    @"v": [NSNumber numberWithInt: sender.tag]
  }];
}

- (IBAction)releaseControllerButton:(UIButton*)sender
{
  [self.websocketMC sendEvent:@"keyUp" data:@{
    @"v": [NSNumber numberWithInt: sender.tag]
  }];
}

@end
