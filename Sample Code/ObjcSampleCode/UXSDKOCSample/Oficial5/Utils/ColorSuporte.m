//
//  ColorSuporte.m
//  DJI O-SDK
//
//  Created by Caio Cardozo on 29/08/18.
//  Copyright © 2018 DJI. All rights reserved.
//

#import "ColorSuporte.h"

@implementation ColorSuporte

+ (UIColor*) ColorDefaultButtonOff
{
    
    return [UIColor   colorWithRed: 178/255.0f
                             green:     34/255.0f
                              blue:     34/255.0f
                             alpha:       1];
}

+ (UIColor*) ColorDefaultButtonOn{
    return [UIColor   colorWithRed: 60/255.0f
                             green:     179/255.0f
                              blue:     113/255.0f
                             alpha:       1];
}

@end
