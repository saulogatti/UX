//
//  TimerCommand.h
//  UXSDKOCSample
//
//  Created by Saulo Gatti on 03/01/19.
//  Copyright © 2019 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerCommand : NSObject

@property (nonatomic, assign) NSInteger timeOn;
@property (nonatomic, assign) NSInteger timeOff;
@property (nonatomic, assign) NSInteger valve;
@property (nonatomic, assign) BOOL executeOn;
@property (nonatomic, assign) BOOL executado;
@property (nonatomic, assign) BOOL executandoOff;
@property (nonatomic, assign) u_int16_t comando;
@end

NS_ASSUME_NONNULL_END
