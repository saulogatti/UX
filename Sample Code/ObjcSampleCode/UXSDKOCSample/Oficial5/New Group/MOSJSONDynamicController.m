//
//  MOSJSONDynamicController.m
//  MOS
//
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSJSONDynamicController.h"
#import "MOSModel.h"
#import "MOSAction.h"
#import "MOSDynamicTableViewCell.h"
#import "MOSProductCommunicationManager.h"
#import "Enum.h"
#import "TimerCommand.h"
#import "Suporte.h"


@implementation MOSJSONDynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dicCell = [NSMutableDictionary new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScreen) name:@"UpdateScreen" object:nil];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resume) name:@"Resume" object:nil];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *allSections = [self.appDelegate.model jsonSections];
    NSUInteger index = 0;
    
    for (index = 0; index < allSections.count; index++)
    {
        MOSSection *section = allSections[index];
        MOSJSONDynamicController *newController = [[MOSJSONDynamicController alloc] initWithStyle:UITableViewStylePlain];
        newController.section = section;
        self.section = section;
        //
        //        if (selectedViewController == nil) {
        //            selectedViewController = newController;
        //        }
        
        newController.tabBarItem = [[UITabBarItem alloc] initWithTitle:section.name
                                                                 image:[UIImage imageNamed:@"first"]
                                                                   tag:index];
        newController.title = section.name;
        //        [viewControllers addObject:newController];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"MOSDynamicTableViewCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"action"];
    //    self.tableView.estimatedRowHeight = 40;
    //
    //    UIEdgeInsets currentEdgeInset = self.tableView.contentInset;
    //    self.tableView.contentInset = UIEdgeInsetsMake(20, currentEdgeInset.left, 50, currentEdgeInset.right);
    
    
}
- (void)updateScreen {
    NSInteger valor = [Suporte getInstancia].valveExecute;
    valor++;
    [[Suporte getInstancia] setValveExecute:valor];
    [[self tableView] reloadData];
}
- (void) resume {
    [[self tableView] reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.section.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOSDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"action" forIndexPath:indexPath];
    MOSAction *action = self.section.actions[indexPath.row];
    
    [cell populateWithActionModel:action];
//    TimerCommand * tim = nil;
//    if ([action.key isEqualToString:@"openValveOne"]) {
//        tim = [[[Suporte getInstancia] listTimer] objectForKey:[NSNumber numberWithInteger:1]];
//    } else  if ([action.key isEqualToString:@"openValveTwo"]) {
//        tim = [[[Suporte getInstancia] listTimer] objectForKey:[NSNumber numberWithInteger:2]];
//        
//    } else  if ([action.key isEqualToString:@"openValveThree"]) {
//        tim = [[[Suporte getInstancia] listTimer] objectForKey:[NSNumber numberWithInteger:3]];
//        
//    } else  if ([action.key isEqualToString:@"openValveFour"]) {
//        tim = [[[Suporte getInstancia] listTimer] objectForKey:[NSNumber numberWithInteger:4]];
//        
//    } else  if ([action.key isEqualToString:@"openValveFive"]) {
//        tim = [[[Suporte getInstancia] listTimer] objectForKey:[NSNumber numberWithInteger:5]];
//        
//    } else {
//        [cell setTimerCommandOff:-1];
//        [cell setTimerCommandOn:-1];
//    }
//    if (tim != nil) {
//        [cell setTimerCommandOn:tim.timeOn];
//        [cell setTimerCommandOff:tim.timeOff];
//    }
//    NSLog(@"Executar valve %ld", (long)[Suporte getInstancia].valveExecute);
//    if ([[Suporte getInstancia] valveExecute] == tim.valve) {
//        [cell executeTimer];
//    } else {
//        [cell pause];
//    }
    MOSDynamicTableViewCell *weakCell = cell;
    
    cell.goAction = ^(NSNumber *cmdId, NSArray *arguments) {
        
        // Arguments are not supported yet.
        u_int16_t cmdIdUInt = [cmdId unsignedIntValue];
        NSData *data = [NSData dataWithBytes:&cmdIdUInt length:sizeof(u_int16_t)];
        
        [self.appDelegate.model addLog:[NSString stringWithFormat:@"Sending CmdID %@ with %ld Arguments", cmdId, (unsigned long)arguments.count]];
        weakCell.commandResultLabel.text = @"Sending...";
        [self.appDelegate.productCommunicationManager sendData:data
                                                withCompletion:^(NSError * _Nullable error) {
                                                    [self.appDelegate.model addLog:[NSString stringWithFormat:@"Sent CmdID %@", cmdId]];
                                                    weakCell.commandResultLabel.text = @"Command Sent!";
                                                    
                                                }
                                                   andAckBlock:^(NSData * _Nonnull data, NSError * _Nullable error) {
                                                       
                                                       NSData *ackData = [data subdataWithRange:NSMakeRange(2, [data length] - 2)];
                                                       uint16_t ackValue;
                                                       [ackData getBytes:&ackValue length:sizeof(uint16_t)];
                                                       BOOL status = false;
                                                       NSString *resposta = @"" ;
                                                       switch (ackValue) {
                                                           case ValvulaUmAberta:
                                                               resposta = @"Válvula 1 aberta";
                                                               status = true;
                                                               break;
                                                           case ValvulaUmFechada:
                                                               resposta = @"Válvula 1 fechada";
                                                               status = false;
                                                               break;
                                                           case ValvulaDoisAberta:
                                                               resposta = @"Válvula 2 aberta";
                                                               status = true;
                                                               break;
                                                           case ValvulaDoisFechada:
                                                               resposta = @"Válvula 2 fechada";
                                                               status = false;
                                                               break;
                                                           case ValvulaTresAberta:
                                                               resposta = @"Válvula 3 aberta";
                                                               status = true;
                                                               break;
                                                           case ValvulaTresFechada:
                                                               resposta = @"Válvula 3 fechada";
                                                               status = false;
                                                               break;
                                                           case ValvulaQuatroAberta:
                                                               resposta = @"Válvula 4 aberta";
                                                               status = true;
                                                               break;
                                                           case ValvulaQuatroFechada:
                                                               resposta = @"Válvula 4 fechada";
                                                               status = false;
                                                               break;
                                                           case ValvulaCincoAberta:
                                                               resposta = @"Válvula 5 aberta";
                                                               status = true;
                                                               break;
                                                           case ValvulaCincoFechada:
                                                               resposta = @"Válvula 1 fechada";
                                                               status = false;
                                                               break;
                                                           default:
                                                               resposta = @"Resposta não identificada";
                                                               status = false;
                                                               break;
                                                       }
                                                       
                                                       //NSString *responseMessage = [NSString stringWithFormat:@"Ack: %u", ackValue];
                                                       NSString *responseMessage = [NSString stringWithFormat:@"Ack: %@", resposta];
                                                       [self.appDelegate.model addLog:[NSString stringWithFormat:@"Received ACK [%@] for CmdID %@", responseMessage, cmdId]];
                                                       
                                                       dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2.0);
                                                       dispatch_after(delay, dispatch_get_main_queue(), ^(void){
//                                                           UIAlertController * alera = [UIAlertController alertControllerWithTitle:@"DEBUG" message:[NSString stringWithFormat:@"Resposta %@", responseMessage] preferredStyle:UIAlertControllerStyleAlert];
//                                                           UIAlertAction * acso = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//
//                                                           }];
//                                                           [alera addAction:acso];
//                                                           [self showViewController:alera sender:nil];
                                                           weakCell.commandResultLabel.text = responseMessage;
                                                           
                                                           [weakCell changeStatus:status];
                                                          
                                                           
                                                       });
                                                   }];
    };
    
    return cell;
}

@end
