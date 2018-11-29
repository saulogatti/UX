//
//  CronometroViewController.m
//  UXSDKOCSample
//
//  Created by Saulo Gatti on 29/11/18.
//  Copyright © 2018 DJI. All rights reserved.
//

#import "CronometroViewController.h"
#import "AppDelegate.h"
#import "MOSProductCommunicationManager.h"
@interface CronometroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelContador;
@property (weak, nonatomic) IBOutlet UIButton *botaoInicia;
@property (nonatomic, assign) int tempoTimer;
@property (nonatomic, strong) NSTimer * timer;
@end

@implementation CronometroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self atualizarLabel];
}
- (IBAction)acaoReseta:(id)sender {
    _tempoTimer = 0;
    [self atualizarLabel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)acaoBotaoMias:(id)sender {
    _tempoTimer++;
    [self atualizarLabel];
}
- (IBAction)acaoBotaoMenos:(id)sender {
    _tempoTimer--;
    [self atualizarLabel];
}

- (void) atualizarLabel {
    _labelContador.text = [self timeFormatted:_tempoTimer];
    
}
- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
- (IBAction)acaoBotaInicia:(id)sender {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(executaTimer) userInfo:nil repeats:YES];
        [[self botaoInicia] setTitle:@"Parar" forState:UIControlStateNormal];
    } else {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void) executaTimer {
    _tempoTimer--;
    
    if (_tempoTimer <= 0) {
        [_timer invalidate];
        _timer = nil;
        [[self botaoInicia] setTitle:@"Inicia" forState:UIControlStateNormal];
        u_int16_t cmdIdUInt = 78;
        NSData *data = [NSData dataWithBytes:&cmdIdUInt length:sizeof(u_int16_t)];
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate]productCommunicationManager] sendData:data withCompletion:^(NSError * _Nullable error) {
            
        } andAckBlock:^(NSData * _Nonnull data, NSError * _Nullable error) {
            
        }];
    }
    
    [self atualizarLabel];
    
    
}


@end
