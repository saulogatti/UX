//
//  GerenciadorTimer.h
//  UXSDKOCSample
//
//  Created by Saulo Gatti on 28/01/19.
//  Copyright © 2019 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GerenciadorTimer : NSObject


+ (GerenciadorTimer *)getInstancia;

- (void) play;
- (void) pause;
- (void) restart;

@end

NS_ASSUME_NONNULL_END
