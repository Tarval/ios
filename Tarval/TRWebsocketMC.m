//
//  TRWebsocketMC.m
//  Tarval
//
//  Created by Steve Gattuso on 8/27/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import "TRWebsocketMC.h"
#import "TRConstants.h"

@implementation TRWebsocketMC

@synthesize websocket;

- (id)init {
  self = [super init];
  if(!self) {
    return self;
  }
  
  self.websocket = [[SRWebSocket alloc] initWithURL:[TRConstants websocketEndpoint]
      protocols: [TRConstants websocketProtocol]];
  self.websocket.delegate = self;
  
  return self;
}

- (void)connect
{
  if(self.websocket.readyState == SR_OPEN) {
    return;
  } else if(self.websocket.readyState == SR_CLOSED) {
    // Reinit the websocket if it failed previously
    self.websocket = [[SRWebSocket alloc] initWithURL:[TRConstants websocketEndpoint]
        protocols: [TRConstants websocketProtocol]];
    self.websocket.delegate = self;
  }
  
  [self.websocket open];
  NSLog(@"Opening connection");
}

- (void)disconnect
{
  NSLog(@"Disconnecting");
  [self.websocket close];
}

- (void)sendEvent:(NSString *)eventName data:(NSDictionary *)data
{
  NSMutableDictionary *send;
  if(data) {
    send = [data mutableCopy];
  } else {
    send = [[NSMutableDictionary alloc] init];
  }
  send[@"e"] = eventName;
  
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:send options:0 error:NULL];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:
      NSUTF8StringEncoding];
  
  // Store calls in a queue if the connection isn't open yet
  if(self.websocket.readyState != SR_OPEN) {
    if(!messageQueue) {
      messageQueue = [[NSMutableArray alloc] init];
    }
    
    [messageQueue addObject:jsonString];
    return;
  }
  
  [self.websocket send:jsonString];
}

- (void)restorePin
{
  if(!self.pin) {
    [self sendEvent:@"getPin" data:nil];
    return;
  }
  
  [self sendEvent:@"restoerPin" data:@{
    @"pin": self.pin
  }];
}

#pragma mark SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
  for(NSInteger i = 0; i < [messageQueue count]; i++) {
    [self.websocket send:messageQueue[i]];
  }
  messageQueue = nil;
  
  NSLog(@"Connection opened");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
  NSError *error;
  NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:
      NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
  
  NSString *eventName = [[NSString alloc] initWithFormat:@"ws:%@", resp[@"e"]];
  
  // The pin is important, store it
  if([eventName isEqualToString:@"ws:setPin"]) {
    self.pin = resp[@"pin"];
  }
  
  [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:resp];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
  NSLog(@"Connection failed");
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
  NSLog(@"I'm out!");
}

@end
