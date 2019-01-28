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
#import "Suporte.h"
#import "TimerCommand.h"

@interface CronometroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelContador;
@property (weak, nonatomic) IBOutlet UIButton *botaoInicia;
@property (nonatomic, assign) NSInteger tempoTimer;
@property (nonatomic, assign) NSInteger tempoTimerOff;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSInteger valve;
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

- (IBAction)acaoBotaoMenos:(id)sender {
    
}

- (void) atualizarLabel {
    _labelContador.text = [self timeFormatted:_tempoTimer];
    
}
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
- (IBAction)acaoBotaInicia:(id)sender {
    _valve = 1;
    NSMutableDictionary * dic = [[Suporte getInstancia] listTimer];
    TimerCommand * tim = [dic objectForKey:[NSNumber numberWithInteger:_valve]];
    if (tim != nil) {
        _tempoTimer = tim.timeOn;
        tim.executeOn = YES;
    }
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(executaTimer) userInfo:nil repeats:YES];
        
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
        
        u_int16_t cmdIdUInt = 78;
        NSData *data = [NSData dataWithBytes:&cmdIdUInt length:sizeof(u_int16_t)];
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate]productCommunicationManager] sendData:data withCompletion:^(NSError * _Nullable error) {
            
        } andAckBlock:^(NSData * _Nonnull data, NSError * _Nullable error) {
            
        }];
    }
    
    [self atualizarLabel];
    
    
}
- (IBAction)acaoAbrirTimer:(id)sender {
    UIStoryboard * sto = [UIStoryboard storyboardWithName:@"ConfigTimer" bundle:nil];
    UIViewController * vc = sto.instantiateInitialViewController;
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.popoverPresentationController.sourceView = [Suporte getTopMostViewController].view;
    
    vc.popoverPresentationController.permittedArrowDirections = 0;
    vc.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX([Suporte getTopMostViewController].view.bounds), CGRectGetMidY([Suporte getTopMostViewController].view.bounds),0,0);
    [[Suporte getTopMostViewController] presentViewController:vc animated:YES completion:nil];
}

- (IBAction)acaoRestart:(id)sender {
}
- (IBAction)acaoPause:(id)sender {
}
- (IBAction)acaoPlay:(id)sender {
}

@end
