//
//  DefaultLayoutViewController.m
//  UXSDKOCSample
//
//  Created by DJI on 15/4/2017.
//  Copyright © 2017 DJI. All rights reserved.
//

#import "DefaultLayoutViewController.h"

@interface DefaultLayoutViewController()<DJISDKManagerDelegate>
- (IBAction)onBackButtonClicked:(id)sender;

@end

@implementation DefaultLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self registerWithProduct];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) connectToProduct
{
  
    NSLog(@"Connecting to product...");
    [DJISDKManager startConnectionToProduct];
    
}

- (void) registerWithProduct
{
    [DJISDKManager registerAppWithDelegate:self];
}
#pragma mark - DJISDKManager Delegate Methods
- (void)appRegisteredWithError:(NSError *)error
{
    if (error == nil) {
        NSLog(@"Registration Succeeded");
        [self connectToProduct];
   
    } else {
        NSLog(@"Error Registrating App: %@", error.description);
    }
}

- (void)productConnected:(DJIBaseProduct *)product
{
    if (product != nil) {
        NSLog(@"Connection to new product successed!");
     
    }
    
    //If this demo is used in China, it's required to login to your DJI account to activate the application. Also you need to use DJI Go app to bind the aircraft to your DJI account. For more details, please check this demo's tutorial.
}

- (void)productDisconnected{
    
    NSLog(@"Disconnected from product!");
  
    
}
@end
