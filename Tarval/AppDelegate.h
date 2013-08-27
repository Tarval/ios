//
//  AppDelegate.h
//  Tarval
//
//  Created by Steve Gattuso on 8/3/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRWebsocketMC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TRWebsocketMC *websocketModelController;

@end
