//
//  Suporte.h
//  UXSDKOCSample
//
//  Created by Saulo Gatti on 02/01/19.
//  Copyright © 2019 DJI. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface Suporte : NSObject

@property (nonatomic, strong) NSMutableDictionary * listTimer;
@property (nonatomic, assign) NSInteger valveExecute;
+ (UIViewController*) getTopMostViewController;
+ (Suporte*) getInstancia;

@end

NS_ASSUME_NONNULL_END
