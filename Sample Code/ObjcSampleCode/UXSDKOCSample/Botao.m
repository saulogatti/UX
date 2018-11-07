//
//  Botao.m
//  UXSDKOCSample
//
//  Created by Saulo Gatti on 07/11/18.
//  Copyright © 2018 DJI. All rights reserved.
//

#import "Botao.h"

@implementation Botao

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
    [self setBackgroundColor:[UIColor clearColor]];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitle:[[[self titleLabel] text] uppercaseString] forState:UIControlStateNormal];
    [[self titleLabel] setTextColor:[UIColor whiteColor]];
    
}

@end
