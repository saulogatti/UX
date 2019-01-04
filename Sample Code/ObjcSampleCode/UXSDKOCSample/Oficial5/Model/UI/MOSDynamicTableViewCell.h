//
//  MOSDynamicTableViewCell.h
//  MOS
//
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MOSAction;

typedef void (^MOSGoActionBlock)(NSNumber *cmdId, NSArray *arguments);

@interface MOSDynamicTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commandLabel;
@property (weak, nonatomic) IBOutlet UILabel *commandInformation;
@property (weak, nonatomic) IBOutlet UILabel *cmdIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *commandResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *btOff;
@property (weak, nonatomic) IBOutlet UIButton *btOn;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (nonatomic, assign) NSInteger timerCommandOff;
@property (nonatomic, assign) NSInteger timerCommandOn;


@property (strong, nonatomic) MOSGoActionBlock goAction;


- (IBAction)go:(id)sender;


- (void)populateWithActionModel:(MOSAction *)actionModel;
-(void)changeStatus:(BOOL) value;
- (void) executeTimer;
- (void) pause;
@end
