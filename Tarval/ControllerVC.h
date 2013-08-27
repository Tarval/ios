//
//  ControllerVC.h
//  Tarval
//
//  Created by Steve Gattuso on 8/27/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class TRWebsocketMC;

@interface ControllerVC : UIViewController {
  NSInteger previousAccelerometerValue;
  CMMotionManager *motionManager;
  BOOL havePin;
}

@property (strong, nonatomic) TRWebsocketMC *websocketMC;

- (IBAction)pressControllerButton: (id)sender;
- (IBAction)releaseControllerButton: (id)sender;
- (void)receiveSetPinNotification: (NSNotification*)notification;

@end
