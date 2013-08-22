//
//  TRControllerButton.m
//  Tarval
//
//  Created by Steve Gattuso on 8/3/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import "TRControllerButton.h"

@implementation TRControllerButton

@synthesize direction;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    NSString *inactive_name = [NSString stringWithFormat:@"%@_arrow_inactive.png", self.direction];
    NSString *active_name = [NSString stringWithFormat:@"%@_arrow_active.png", self.direction];
    
    [self setImage:[UIImage imageNamed:inactive_name] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:active_name] forState:UIControlStateHighlighted];
}

@end
