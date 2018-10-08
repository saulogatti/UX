//
//  StatusProtocol.h
//  DJI O-SDK
//
//  Created by Caio Cardozo on 30/08/18.
//  Copyright © 2018 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol IStatusProtocolDelegate <NSObject>


@optional
- (void) changeStatus:(BOOL*) status;

@end
