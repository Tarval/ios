//
//  WebsocketMC.h
//  Tarval
//
//  Created by Steve Gattuso on 8/3/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

@interface WebsocketMC : NSObject<SRWebSocketDelegate> {
    NSNotificationCenter *_notification_center;
    NSMutableArray *_message_queue;
}

@property (strong, nonatomic) SRWebSocket *websocket;
@property (strong, nonatomic) NSNumber *pin;

-(void)connect;
-(void)disconnect;
-(void)restorePin;
-(void)sendEvent: (NSString*)event_name data: (NSDictionary*)data;

@end
