//
//  TRWebsocketMC.h
//  Tarval
//
//  Created by Steve Gattuso on 8/27/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

@interface TRWebsocketMC : NSObject<SRWebSocketDelegate> {
  NSMutableArray *messageQueue;
}

@property (strong, nonatomic) SRWebSocket *websocket;
@property (strong, nonatomic) NSNumber *pin;

- (void)connect;
- (void)disconnect;
- (void)restorePin;
- (void)sendEvent: (NSString*)eventName data: (NSDictionary*)data;

@end
