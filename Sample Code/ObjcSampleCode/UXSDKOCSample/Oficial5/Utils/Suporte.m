//
//  Suporte.m
//  UXSDKOCSample
//
//  Created by Saulo Gatti on 02/01/19.
//  Copyright © 2019 DJI. All rights reserved.
//

#import "Suporte.h"
@import UIKit;
static Suporte * instancia;
@implementation Suporte
#pragma mark Inicializacao
- (instancetype)init
{
    if (instancia != nil)
    {
        NSException* myException = [NSException
                                    exceptionWithName:@"Não pode ser criado"
                                    reason:@"Usar o metodo getInstancia"
                                    userInfo:nil];
        @throw myException;
    }
    
    
    
    
    return [super init];
}

+ (Suporte*) getInstancia
{
    if (instancia == nil)
    {
        instancia = [Suporte new];
        instancia.listTimer = [NSMutableDictionary new];
    }
    
    return instancia;
}
+ (UIViewController *) topViewController: (UIViewController *) controller
{
    BOOL isPresenting = NO;
    do {
        // this path is called only on iOS 6+, so -presentedViewController is fine here.
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            controller = presented;
        }
        
    } while (isPresenting);
    
    return controller;
}
+ (UIViewController*) getTopMostViewController
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    for (UIView *subView in [window subviews])
    {
        UIResponder *responder = [subView nextResponder];
        
        //added this block of code for iOS 8 which puts a UITransitionView in between the UIWindow and the UILayoutContainerView
        if ([responder isEqual:window])
        {
            //this is a UITransitionView
            if ([[subView subviews] count])
            {
                UIView *subSubView = [subView subviews][0]; //this should be the UILayoutContainerView
                responder = [subSubView nextResponder];
            }
        }
        
        if([responder isKindOfClass:[UIViewController class]]) {
            return [self topViewController: (UIViewController *) responder];
        }
    }
    
    return nil;
}

@end
