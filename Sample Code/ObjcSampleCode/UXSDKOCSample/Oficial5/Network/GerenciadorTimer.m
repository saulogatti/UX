//
//  GerenciadorTimer.m
//  UXSDKOCSample
//
//  Created by Saulo Gatti on 28/01/19.
//  Copyright © 2019 DJI. All rights reserved.
//

#import "GerenciadorTimer.h"


static GerenciadorTimer * instancia;
@implementation GerenciadorTimer

+ (GerenciadorTimer *)getInstancia
{
    @synchronized (self)
    {
        if (instancia == nil)
        {
            instancia = [GerenciadorTimer new];
        }
    }
    
    return instancia;
}

@end
