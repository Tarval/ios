//
//  PairingVC.m
//  Tarval
//
//  Created by Steve Gattuso on 8/27/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import "PairingVC.h"
#import "TRWebsocketMC.h"

@implementation PairingVC

@synthesize websocketMC;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupListeners];
  
  if(self.websocketMC.pin == nil) {
    loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.websocketMC sendEvent:@"getPin" data:nil];
    codeLabel.text = @"";
  } else {
    codeLabel.text = [self formatPin:[[NSString alloc] initWithFormat:@"%@", self.websocketMC.pin]];
  }
}

- (void)setupListeners
{
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  
  [defaultCenter addObserver:self selector:@selector(receivePinNotification:)
    name:@"ws:setPin" object:nil];
}

- (NSString*)formatPin:(NSString *)pin
{
  if([pin length] < 4) {
    for(int i = [pin length]; i < 4; i++) {
      pin = [NSString stringWithFormat:@"0%@", pin];
    }
  }
  
  // Add spaces to make it look good
  NSMutableString *spacedPin = [[NSMutableString alloc] init];
  for(int i = 0; i < [pin length]; i++) {
    char current = [pin characterAtIndex:i];
    
    if(current == [pin length] - 1) {
      [spacedPin appendFormat:@"%c", current];
    } else {
      [spacedPin appendFormat:@"%c ", current];
    }
  }
  
  return spacedPin;
}

- (void)receivePinNotification:(NSNotification *)notification
{
  codeLabel.text = [self formatPin:notification.object[@"pin"]];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [loadingHud hide:YES];
  });
}

#pragma mark IBActions
- (IBAction)pressDone:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark iOS handlers
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskLandscapeLeft;
}

@end
