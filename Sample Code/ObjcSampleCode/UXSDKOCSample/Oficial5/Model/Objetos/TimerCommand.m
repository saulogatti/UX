//
//  TimerCommand.m
//  UXSDKOCSample
//
//  Created by Saulo Gatti on 03/01/19.
//  Copyright © 2019 DJI. All rights reserved.
//

#import "TimerCommand.h"

@implementation TimerCommand
- (NSString *)description
{
    return [NSString stringWithFormat:@"Valve %ld %@ in", (long)_valve, _executeOn?@"ON":@"OFF"];
}
- (u_int16_t)comando {
    u_int16_t ret = 0;
    switch (_valve) {
        case 1:{
            if (_executeOn) {
                return 0x4d;
            } else {
                return 0x43;
            }
        }
            break;
        case 2: {
            if (_executeOn) {
                return 0x4F;
            } else {
                return 0x50;
            }
        }
            break;
        case 3: {
            if (_executeOn) {
                return 0x51;
            } else {
                return 0x52;
            }
        }
            break;
        case 4: {
            if (_executeOn) {
                return 0x53;
            } else {
                return 0x54;
            }
        }
            break;
        case 5: {
            if (_executeOn) {
                return 0x55;
            } else {
                return 0x56;
            }
        }
            break;
            
        default:
            break;
    }
    
    return ret;
}
/*
 
 {
 "key" : "openValveOne",
 "cmd_idOn" : "0x4D",
 "cmd_idOff" : "0x4E",
 "label" : "Valve 1 - OPEN",
 "ack" : true,
 "ack_size" : 1,
 },
 
 {
 "key" : "openValveTwo",
 "cmd_idOn" : "0x4F",
 "cmd_idOff" : "0x50",
 "label" : "Valve 2 - OPEN",
 "ack" : true,
 "ack_size" : 1,
 },
 
 {
 "key" : "openValveThree",
 "cmd_idOn" : "0x51",
 "cmd_idOff" : "0x52",
 "label" : "Valve 3 - OPEN",
 "ack" : true,
 "ack_size" : 1,
 },
 
 {
 "key" : "openValveFour",
 "cmd_idOn" : "0x53",
 "cmd_idOff" : "0x54",
 "label" : "Valve 4 - OPEN",
 "ack" : true,
 "ack_size" : 1,
 },
 
 {
 "key" : "openValveFive",
 "cmd_idOn" : "0x55",
 "cmd_idOff" : "0x56",
 "label" : "Valve 5 - OPEN",
 "ack" : true,
 "ack_size" : 1,*/
@end
