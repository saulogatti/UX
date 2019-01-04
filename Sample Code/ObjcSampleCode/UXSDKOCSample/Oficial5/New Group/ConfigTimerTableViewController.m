//
//  ConfigTimerTableViewController.m
//  UXSDKOCSample
//
//  Created by Saulo Gatti on 03/01/19.
//  Copyright © 2019 DJI. All rights reserved.
//

#import "ConfigTimerTableViewController.h"
#import "TimerCommand.h"
#import "Suporte.h"

@interface ConfigTimerTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldOn1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOn2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOn3;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOn4;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOn5;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOff1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOff2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOff3;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOff4;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOff5;

@end

@implementation ConfigTimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
    {
        // BasicAlert(@"", @"This field accepts only numeric entries.");
        return NO;
    }
    else
    {
        NSString *text = textField.text;
        NSInteger length = text.length;
        BOOL shouldReplace = YES;
        
        if (![string isEqualToString:@""])
        {
            switch (length)
            {
                case 2:
                    textField.text = [text stringByAppendingString:@":"];
                    break;
                    
                default:
                    break;
            }
            if (length > 4)
                shouldReplace = NO;
        }
        
        return shouldReplace;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString * texto = textField.text;
    if (texto.length < 3 && ![texto containsString:@":"]) {
        texto = [texto stringByAppendingString:@":00"];
    }
    [textField setText:texto];
    
}
- (NSInteger)recuperarValor:(NSString*) valor {
    NSInteger ret = 0;
    NSArray * lista = [valor componentsSeparatedByString:@":"];
    NSInteger minutos = [[lista objectAtIndex:0] integerValue] * 60;
    ret = minutos + [[lista objectAtIndex:1] integerValue];
    
    
    return ret;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[Suporte getInstancia] setValveExecute:0];
    if ([_textFieldOff1.text length] > 0) {
        TimerCommand * timer = [self recuperarTimer:1];
        [timer setTimeOff:[self recuperarValor:_textFieldOff1.text]];
        [[[Suporte getInstancia] listTimer] setObject:timer forKey:[NSNumber numberWithInteger:[timer valve]]];
    }
    if ([_textFieldOn1.text length] > 0) {
        TimerCommand * timer = [self recuperarTimer:1];
        NSInteger tempo = [self recuperarValor:_textFieldOn1.text];
        [timer setTimeOn:tempo];
        [[[Suporte getInstancia] listTimer] setObject:timer forKey:[NSNumber numberWithInteger:[timer valve]]];
    }
    if ([_textFieldOff2.text length] > 0) {
        TimerCommand * timer = [self recuperarTimer:2];
        [timer setTimeOff:[self recuperarValor:_textFieldOff2.text]];
        [[[Suporte getInstancia] listTimer] setObject:timer forKey:[NSNumber numberWithInteger:[timer valve]]];
    }
    if ([_textFieldOn2.text length] > 0) {
        TimerCommand * timer = [self recuperarTimer:2];
        NSInteger tempo = [self recuperarValor:_textFieldOn2.text];
        [timer setTimeOn:tempo];
        [[[Suporte getInstancia] listTimer] setObject:timer forKey:[NSNumber numberWithInteger:[timer valve]]];
    }
    if ([_textFieldOff3.text length] > 0) {
        TimerCommand * timer = [self recuperarTimer:3];
        [timer setTimeOff:[self recuperarValor:_textFieldOff3.text]];
        [[[Suporte getInstancia] listTimer] setObject:timer forKey:[NSNumber numberWithInteger:[timer valve]]];
    }
    if ([_textFieldOn3.text length] > 0) {
        TimerCommand * timer = [self recuperarTimer:3];
        NSInteger tempo = [self recuperarValor:_textFieldOn3.text];
        [timer setTimeOn:tempo];
        [[[Suporte getInstancia] listTimer] setObject:timer forKey:[NSNumber numberWithInteger:[timer valve]]];
    }
    if ([_textFieldOff4.text length] > 0) {
        TimerCommand * timer = [self recuperarTimer:4];
        [timer setTimeOff:[self recuperarValor:_textFieldOff4.text]];
        [[[Suporte getInstancia] listTimer] setObject:timer forKey:[NSNumber numberWithInteger:[timer valve]]];
    }
    if ([_textFieldOn4.text length] > 0) {
        TimerCommand * timer = [self recuperarTimer:4];
        NSInteger tempo = [self recuperarValor:_textFieldOn4.text];
        [timer setTimeOn:tempo];
        [[[Suporte getInstancia] listTimer] setObject:timer forKey:[NSNumber numberWithInteger:[timer valve]]];
    }
    if ([_textFieldOff5.text length] > 0) {
        TimerCommand * timer = [self recuperarTimer:5];
        [timer setTimeOff:[self recuperarValor:_textFieldOff5.text]];
        [[[Suporte getInstancia] listTimer] setObject:timer forKey:[NSNumber numberWithInteger:[timer valve]]];
    }
    if ([_textFieldOn5.text length] > 0) {
        TimerCommand * timer = [self recuperarTimer:5];
        NSInteger tempo = [self recuperarValor:_textFieldOn5.text];
        [timer setTimeOn:tempo];
        [[[Suporte getInstancia] listTimer] setObject:timer forKey:[NSNumber numberWithInteger:[timer valve]]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateScreen" object:nil];
}
- (TimerCommand*) recuperarTimer:(NSInteger) valve {
    TimerCommand * timer = [[[Suporte getInstancia] listTimer] objectForKey:[NSNumber numberWithInteger:valve]];
    if (timer == nil) {
        timer = [TimerCommand new];
        [timer setValve:valve];
    }
    
    return timer;
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
