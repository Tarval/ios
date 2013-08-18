//
//  WebsocketMC.m
//  Tarval
//
//  Created by Steve Gattuso on 8/3/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import "WebsocketMC.h"
#import "TRConstants.h"

@implementation WebsocketMC

@synthesize websocket;

-(id)init {
    self = [super init];
    if(!self) {
        return self;
    }
    
    self.websocket = [[SRWebSocket alloc] initWithURL:[TRConstants websocketEndpoint] protocols: [TRConstants websocketProtocol]];
    self.websocket.delegate = self;
    
    return self;
}

-(void)connect
{
    if(self.websocket.readyState == SR_OPEN) {
        return;
    }
    [self.websocket open];
    NSLog(@"Opening connection");
}

-(void)disconnect
{
    NSLog(@"Disconnecting");
    [self.websocket close];
}

-(void)sendEvent: (NSString*)event_name data: (NSDictionary*)data
{
    NSMutableDictionary *send;
    
    if(data) {
        send = [data mutableCopy];
    } else {
        send = [[NSMutableDictionary alloc] init];
    }
    
    send[@"e"] = event_name;
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:send options:0 error:NULL];
    NSString *json_string = [[NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding];
    
    // Store calls made before a connection was completed
    if(self.websocket.readyState != SR_OPEN) {
        if(!_message_queue) {
            _message_queue = [[NSMutableArray alloc] init];
        }
        [_message_queue addObject: json_string];
        return;
    }
    
    [self.websocket send: json_string];
}

-(void)restorePin
{
    NSMutableDictionary *send = [[NSMutableDictionary alloc] init];
    send[@"pin"] = self.pin;
    [self sendEvent:@"restorePin" data:send];
}

#pragma mark Websocket stuff
-(void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    // Run through all the previous calls
    for(int i = 0; i < [_message_queue count]; i++) {
        [self.websocket send: [_message_queue objectAtIndex:i]];
    }
    _message_queue = nil;
    
    NSLog(@"Connection opened");
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString*)message
{
    NSError *error;
    NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    NSString *event_name = [[NSString alloc] initWithFormat:@"ws:%@", resp[@"e"]];
    
    // The pin is important, store it
    if([event_name isEqualToString:@"ws:setPin"]) {
        self.pin = resp[@"pin"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:event_name object:resp];
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Fuck this shit");
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"I'm out!");
}

@end
