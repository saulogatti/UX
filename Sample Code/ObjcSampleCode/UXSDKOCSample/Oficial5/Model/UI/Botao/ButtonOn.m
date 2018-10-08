//
//  ButtonOn.m
//  DJI O-SDK
//
//  Created by Caio Cardozo on 29/08/18.
//  Copyright © 2018 DJI. All rights reserved.
//

#import "ButtonOn.h"
#import "ColorSuporte.h"

@implementation ButtonOn

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
    if (_inverterCorDePress) {
        [self carregarBotaoPress];
    } else {
        [self setBackgroundColor:[ColorSuporte ColorDefaultButtonOn]];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = self.frame.size.height/2;
        self.clipsToBounds = YES;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void) carregarBotaoPress {
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.borderColor = [ColorSuporte ColorDefaultButtonOn].CGColor;
    [self setTitleColor:[ColorSuporte ColorDefaultButtonOn] forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self carregarBotaoPress];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self carregarBotao];
}

-(void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event{
    [super pressesBegan:presses withEvent:event];
    [self carregarBotaoPress];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        [self carregarBotaoPress];
    } else {
        [self carregarBotao];
    }
}
- (void)setInverterCorDePress:(BOOL)inverterCorDePress {
    _inverterCorDePress = inverterCorDePress;
    [self carregarBotao];
    
}

@end
