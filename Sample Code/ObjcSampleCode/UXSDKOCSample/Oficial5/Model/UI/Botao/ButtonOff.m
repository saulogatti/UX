//
//  ButtonOff.m
//  DJI O-SDK
//
//  Created by Caio Cardozo on 29/08/18.
//  Copyright © 2018 DJI. All rights reserved.
//

#import "ButtonOff.h"
#import "ColorSuporte.h"

@implementation ButtonOff

- (instancetype)initWithFrame:(CGRect)frame
{
    [self carregarBotao];
    
    return [super initWithFrame:frame];
}
- (instancetype)init
{
    [self carregarBotao];
    
    return [super init];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self carregarBotao];
    return self;
}

- (void) carregarBotao
{
    [self setBackgroundColor:[ColorSuporte ColorDefaultButtonOff]];
    self.layer.borderColor = [ColorSuporte ColorDefaultButtonOff].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    
}

@end
