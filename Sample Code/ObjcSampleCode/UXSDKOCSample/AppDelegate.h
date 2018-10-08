//
//  AppDelegate.h
//  UXSDKOCSample
//
//  Created by DJI on 14/4/2017.
//  Copyright © 2017 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MOSModel;
@class MOSProductCommunicationManager;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MOSModel *model;
@property (strong, nonatomic) MOSProductCommunicationManager *productCommunicationManager;
@end

