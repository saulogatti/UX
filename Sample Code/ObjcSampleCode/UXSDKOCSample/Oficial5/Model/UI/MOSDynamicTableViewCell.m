//
//  MOSDynamicTableViewCell.m
//  MOS
//
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSDynamicTableViewCell.h"
#import "MOSAction.h"
#import "ColorSuporte.h"

@interface MOSDynamicTableViewCell()

@property (strong, nonatomic) MOSAction *actionModel;
@property (weak, nonatomic) IBOutlet UILabel *textFieldTempo;
@property (nonatomic, strong) NSTimer * timer;
@property (weak, nonatomic) IBOutlet UILabel *labelTimerOn;
@end

@implementation MOSDynamicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    dispatch_async(dispatch_get_main_queue(), ^{
        [self carregarBotao];
        [self carregarOFF];
        [self carregarBotaoOff];

    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:@"Pause" object:nil];
}

-(void)carregarBotaoOff{
    [self.btOff setBackgroundColor:[ColorSuporte ColorDefaultButtonOff]];
    self.btOff.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btOff.layer.borderWidth = 1.0;
    self.btOff.layer.cornerRadius = 20;
    self.btOff.clipsToBounds = YES;
    [self.btOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)invertColorBotaoOff{
    [self.btOff setBackgroundColor:[UIColor whiteColor]];
    self.btOff.layer.borderColor = [ColorSuporte ColorDefaultButtonOff].CGColor;
    self.btOff.layer.borderWidth = 1.0;
    self.btOff.layer.cornerRadius = 20;
    self.btOff.clipsToBounds = YES;
    [self.btOff setTitleColor:[ColorSuporte ColorDefaultButtonOff] forState:UIControlStateNormal];
}

-(void)carregarBotao{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.btOn setBackgroundColor:[ColorSuporte ColorDefaultButtonOn]];
        self.btOn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.btOn.layer.borderWidth = 1.0;
        self.btOn.layer.cornerRadius = 20;
        self.btOn.clipsToBounds = YES;
        [self.btOn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    });
}

- (void) invertColors {
    [self.btOn setBackgroundColor:[UIColor whiteColor]];
    self.btOn.layer.borderColor = [ColorSuporte ColorDefaultButtonOn].CGColor;
    self.btOn.layer.borderWidth = 1.0;
    self.btOn.layer.cornerRadius = 20;
    self.btOn.clipsToBounds = YES;
    [self.btOn setTitleColor:[ColorSuporte ColorDefaultButtonOn] forState:UIControlStateNormal];
}

-(void)carregarOFF {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.lbStatus setBackgroundColor:[ColorSuporte ColorDefaultButtonOff]];
        [self.lbStatus setTextColor:[UIColor whiteColor]];
        
        [self.lbStatus setText:@"OFF"];
    });
}

-(void)carregarON {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.lbStatus setBackgroundColor:[ColorSuporte ColorDefaultButtonOn]];
        [self.lbStatus setTextColor:[UIColor whiteColor]];
        [self.lbStatus setText:@"ON"];
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (IBAction)off:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self invertColorBotaoOff];
    });
    if (self.goAction) {
        NSNumber *cmdId =  self.actionModel.cmdIDOff;
        NSArray *arguments = @[];
        
        self.goAction(cmdId, arguments);
    }
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(carregarBotaoOff)
                                   userInfo:nil
                                    repeats:NO];
}

- (IBAction)go:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self invertColors];
    });
    if (self.goAction) {
        NSNumber *cmdId =  self.actionModel.cmdIDOn;
        NSArray *arguments = @[];
        
        self.goAction(cmdId, arguments);
    }
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(carregarBotao)
                                   userInfo:nil
                                    repeats:NO];
    
   
    
    
}

- (void)populateWithActionModel:(MOSAction *)actionModel {
    self.actionModel = actionModel;
    
    self.cmdIdLabel.text = [NSString stringWithFormat:@"%@", actionModel.cmdIDOn];
    self.commandLabel.text = actionModel.label;
    self.commandInformation.text = actionModel.information;
    self.commandResultLabel.text = @"";
    
}

-(void)changeStatus:(BOOL) value {
    if(value){
        [self carregarON];
    }else{
        [self carregarOFF];
    }
}

- (void) updateTimer {
    if (_timerCommandOn > 0) {
        _timerCommandOn--;
        if (_timerCommandOn == 0) {
            [self go:nil];
     
        }
        [self atualizarLabelOn];
    } else if (_timerCommandOff > 0) {
        _timerCommandOff--;
        if (_timerCommandOff == 0) {
            [self off:nil];
         
        }
    }
    
    if (_timerCommandOn == 0 && _timerCommandOff == 0) {
        [_timer invalidate];
        _timer = nil;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateScreen" object:nil];
    }
    
    [self atualizarLabelOff];
  
}
- (void) atualizarLabelOff {
    _textFieldTempo.text = [self timeFormatted:_timerCommandOff];
    
}
- (void) atualizarLabelOn {
     _labelTimerOn.text = [self timeFormatted:_timerCommandOn];
}
- (void)setTimerCommandOff:(NSInteger)timerCommandOff {
    _timerCommandOff = timerCommandOff;
     [[self textFieldTempo] setHidden:NO];
    if (_timerCommandOff < 0) {
        [[self textFieldTempo] setHidden:YES];
    }
    [self atualizarLabelOff];
}
- (void)setTimerCommandOn:(NSInteger)timerCommandOn {
    _timerCommandOn = timerCommandOn;
    [[self labelTimerOn] setHidden:NO];
    if (_timerCommandOn < 0) {
        [[self labelTimerOn] setHidden:YES];
    }
    [self atualizarLabelOn];
}
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
- (void)executeTimer {
    if (_timerCommandOn > 0 && _timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    
}
- (void) pause {
    [_timer invalidate];
    _timer = nil;
}
@end
