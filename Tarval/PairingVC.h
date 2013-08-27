//
//  PairingVC.h
//  Tarval
//
//  Created by Steve Gattuso on 8/27/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@class WebsocketMC;

@interface PairingVC : UIViewController {
    MBProgressHUD *loadingHud;
    IBOutlet UILabel *codeLabel;
}

@property (strong, nonatomic) WebsocketMC *websocketMC;

- (void)setupListeners;
- (void)receivePinNotification: (NSNotification *)notification;

- (IBAction)pressDone: (id)sender;

@end
