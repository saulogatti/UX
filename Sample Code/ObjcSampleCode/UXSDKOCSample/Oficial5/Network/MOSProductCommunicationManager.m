//
//  MOSProductCommunicationManager.m
//  MOS
//
// 
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSProductCommunicationManager.h"
#import "AppDelegate.h"
#import "MOSModel.h"

#define USE_BRIDGE_APP 0

@implementation MOSProductCommunicationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sentCmds = [NSMutableDictionary new];
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [self registerWithProduct];
    }
    return self;
}

- (void)registerWithProduct {
    NSString *registrationAppKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:SDK_APP_KEY_INFO_PLIST_KEY];
    [self.appDelegate.model addLog:[NSString stringWithFormat:@"Registering Product with ID: %@", registrationAppKey]];
    [DJISDKManager registerAppWithDelegate:self];
}

/*********************************************************************************/
#pragma mark - OnBoardSDK Communication
/*********************************************************************************/

- (NSString *)commandIDStringKeyFromData:(NSData *)data {
    uint16_t cmdId;
    [data getBytes:&cmdId length:sizeof(uint16_t)];
    NSString *key = [NSString stringWithFormat:@"%d", cmdId];
    
    return key;
}

- (void)sendData:(NSData *)data withCompletion:(void (^)(NSError * _Nullable error))completion andAckBlock:(MOSAckBlock)ackBlock
{
    if (self.connectedProduct == nil ||
        ![self.connectedProduct isKindOfClass:[DJIAircraft class]]) {
        completion([NSError errorWithDomain:@"MOSProductCommunicatorManager"
                                       code:1001
                                   userInfo:@{@"details": @"No aircraft connected"}]);
        return;
    }
    
    DJIAircraft *aircraft = (DJIAircraft *)DJISDKManager.product;
    DJIFlightController *fc = aircraft.flightController;
    
    fc.delegate = self;
    
    if (fc == nil) {
        completion([NSError errorWithDomain:@"MOSProductCommunicatorManager"
                                       code:1001
                                   userInfo:@{@"details": @"No Flight Controller connected"}]);
        return;
    }
    
//    [fc sendDataToOnboardSDKDevice:data withCompletion:^(NSError * _Nullable error) {
//        if (error) {
//            // Handle error locally
//        } else {
//            NSString *key = [self commandIDStringKeyFromData:data];
//
//            [self.sentCmds setObject:ackBlock forKey:key];
//        }
//        completion(error);
//    }];
    if (_timerRetry != nil && [_timerRetry isValid]) {
        [_timerRetry invalidate];
    }

    [[fc onboardSDKDevice] sendDataFromMobileToOnboard:data
                                        withCompletion:^(NSError * _Nullable error) {
                                            if (error) {
                                                // Handle error locally
                                            } else {
                                                self->_timerRetry = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(retry) userInfo:nil repeats:NO];
                                                self->_dataRetry = data;
                                                if (ackBlock != NULL) {
                                                    NSString *key = [self commandIDStringKeyFromData:data];
                                                    
                                                    [self.sentCmds setObject:ackBlock forKey:key];
                                                }
                                            }
                                            if (completion != NULL) {
                                                completion(error);
                                            }
                                        }];
}
- (void) retry {
    DJIAircraft *aircraft = (DJIAircraft *)DJISDKManager.product;
    DJIFlightController *fc = aircraft.flightController;
    [[fc onboardSDKDevice] sendDataFromMobileToOnboard:_dataRetry withCompletion:nil];
}
/*********************************************************************************/
#pragma mark - DJIFlightControllerDelegate
/*********************************************************************************/

- (void)flightController:(DJIFlightController *_Nonnull)fc didReceiveDataFromOnboardSDKDevice:(NSData * _Nonnull)data
{
    [_timerRetry invalidate];
    NSString *key = [self commandIDStringKeyFromData:data];
    MOSAckBlock ackBlock = [self.sentCmds objectForKey:key];
    
    [self.appDelegate.model addLog:[NSString stringWithFormat:@"Received data from FC [%@]", data]];

    // Error handling is not supported yet.
    if (ackBlock) {
        ackBlock(data, nil);
    } else {
        [self.appDelegate.model addLog:[NSString stringWithFormat:@"Received Non-ACK data [%@]", data]];
    }
    [self.sentCmds removeObjectForKey:key];
}


/*********************************************************************************/
#pragma mark - DJISDKManagerDelegate
/*********************************************************************************/
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
- (void)appRegisteredWithError:(NSError *)error {
    //        NSString *debugID = @"10.128.129.110";
    //
    //        [self.appDelegate.model addLog:[NSString stringWithFormat:@"Connecting to Product using DebugID: %@", debugID]];
    //        [DJISDKManager enterDebugModeWithDebugId:debugID];
    
    if (error) {
        [self.appDelegate.model addLog:[NSString stringWithFormat:@"Error registering App: %@", error]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController * alerta = [UIAlertController alertControllerWithTitle:@"ERRO" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * acao = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alerta addAction:acao];
            [[MOSProductCommunicationManager getTopMostViewController] showViewController:alerta sender:nil];
        });
     
        
    } else {
        [self.appDelegate.model addLog:@"Registration Succeeded"];

        [self.appDelegate.model addLog:@"Connecting to Product"];

#if USE_BRIDGE_APP
        [DJISDKManager enableBridgeModeWithBridgeAppIP:@"10.128.129.34"];
#else
        BOOL startedResult = [DJISDKManager startConnectionToProduct];
        
        if (startedResult) {
            [self.appDelegate.model addLog:@"Connecting to Product started successfully"];
        } else {
            [self.appDelegate.model addLog:@"Connecting to Product failed to start"];
        }
#endif
    }
}

- (void)productConnected:(DJIBaseProduct *)product {
    [self.appDelegate.model addLog:@"Connection to new product succeeded"];
    self.connectedProduct = product;
}

- (void)productDisconnected {
    [self.appDelegate.model addLog:@"Disconnected from product"];
}



@end
