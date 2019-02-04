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

@property (weak, nonatomic) IBOutlet UIButton *botaoInicia;
@property (nonatomic, assign) NSInteger tempoTimer;
@property (nonatomic, assign) NSInteger tempoTimerOff;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSInteger valve;
@property (weak, nonatomic) IBOutlet UILabel *labelTempo;
@property (nonatomic, strong) TimerCommand * timerExecutando;
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
    _labelTempo.text = [self timeFormatted:_tempoTimer];
    
}
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
    
    return [_timerExecutando.description stringByAppendingFormat:@" %02d:%02d", minutes, seconds];
}
- (IBAction)acaoBotaInicia:(id)sender {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(executaTimer) userInfo:nil repeats:YES];
        
    }
}

- (void) executaTimer {
    _tempoTimer--;
    
    if (_tempoTimer <= 0) {
        [_timer invalidate];
        _timer = nil;
        
        u_int16_t cmdIdUInt = _timerExecutando.comando;
        NSData *data = [NSData dataWithBytes:&cmdIdUInt length:sizeof(u_int16_t)];
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate]productCommunicationManager] sendData:data withCompletion:^(NSError * _Nullable error) {
            
        } andAckBlock:^(NSData * _Nonnull data, NSError * _Nullable error) {
            
        }];
        if (_timerExecutando != nil && _timerExecutando.executeOn && _timerExecutando.timeOff > 0) {
            _tempoTimer = _timerExecutando.timeOff;
            _timerExecutando.executeOn = NO;
            [self acaoBotaInicia:nil];
        } else {
            _timerExecutando.executado = YES;
            
            [self acaoPlay:nil];
        }
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
    for (int i = 1; i < 6; i++) {
        TimerCommand * timer = [[[Suporte getInstancia] listTimer] objectForKey:[NSNumber numberWithInt:i]];
        [timer setExecutado:NO];
        [timer setExecuteOn:NO];
        [timer setExecutandoOff:NO];
    }
    _labelTempo.text = @"Reset OK";
}
- (IBAction)acaoPause:(id)sender {
    [_timer invalidate];
}
- (IBAction)acaoPlay:(id)sender {
    if ([[[Suporte getInstancia] listTimer] count] > 0) {
        for (int i = 1; i < 6; i++) {
            
            TimerCommand * timer = [[[Suporte getInstancia] listTimer] objectForKey:[NSNumber numberWithInt:i]];
            if (timer != nil && (timer.timeOn > 0 || timer.timeOff > 0) && !timer.executado) {
                if (timer.timeOn > 0) {
                    if (!timer.executeOn){
                        _timerExecutando = timer;
                        timer.executeOn = YES;
                        _tempoTimer = timer.timeOn;
                    }
                    [self acaoBotaInicia:nil];
                    break;
                } else if (timer.timeOff > 0) {
                    if (![timer executandoOff]) {
                        [timer setExecutandoOff:YES];
                        _timerExecutando = timer;
                        timer.executeOn = NO;
                        _tempoTimer = timer.timeOff;
                    }
                    }
                    [self acaoBotaInicia:nil];
                    break;
                }
                [self atualizarLabel];
            }
        }
    

}

@end
