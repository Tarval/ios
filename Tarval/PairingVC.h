//
//  PairingVCViewController.h
//  Tarval
//
//  Created by Steve Gattuso on 8/3/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "WebsocketMC.h"

@protocol PairingVCDelegate<NSObject>

-(void)receivePin: (NSNumber*)pin;

@end

@interface PairingVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *label_code;
@property (strong, nonatomic) MBProgressHUD *hud_loading;
@property (strong, nonatomic) id<PairingVCDelegate> delegate;
@property (strong, nonatomic) WebsocketMC *websocket_mc;

-(IBAction)pressDone: (id)sender;
-(void)setupListeners;
-(void)receivePinNotification: (NSNotification *)notification;

@end