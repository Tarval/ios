//
//  ViewController.h
//  Tarval
//
//  Created by Steve Gattuso on 8/3/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "PairingVC.h"
@class WebsocketMC;

@interface ControllerVC : UIViewController<PairingVCDelegate> {
    WebsocketMC *_websocket_mc;
    BOOL _got_pin;
    NSInteger prev_accel_val;
}

@property (strong, nonatomic) CMMotionManager *motion_manager;
@property (strong, nonatomic) IBOutlet UILabel *label_pin;

-(IBAction)pressControllerButton: (UIButton*)sender;
-(IBAction)releaseControllerButton: (UIButton*)sender;
-(void)receivePinNotification: (NSNotification*)notification;

@end
