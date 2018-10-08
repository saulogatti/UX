//
//  MOSAction.m
//  MOS
//
// 
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSAction.h"

@implementation MOSAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _key = @"N/A";
        _label = @"N/A";
        _information = @"";
        _cmdIDOn = @-1;
        _cmdIDOff= @-1;
        _acks = NO;
        
    }
    return self;
}

- (instancetype)initWithJsonDictionary:(NSDictionary *)jsonDictionary
{
    self = [self init];
    if (self) {
        
        NSString *jsonKey = [jsonDictionary objectForKey:@"key"];
        if (jsonKey) {
            self.key = jsonKey;
        }

        NSString *jsonCommandLabel = [jsonDictionary objectForKey:@"label"];
        if (jsonCommandLabel) {
            self.label = jsonCommandLabel;
        }
        
        NSString *jsonCommandInfo = [jsonDictionary objectForKey:@"info"];
        if (jsonCommandInfo) {
            self.information = jsonCommandInfo;
        }
        
        NSString *jsonCmdIDOn = [jsonDictionary objectForKey:@"cmd_idOn"];
        if (jsonCmdIDOn) {
            unsigned int result = 0;
            NSScanner *scanner = [NSScanner scannerWithString:jsonCmdIDOn];
            
            [scanner setScanLocation:2]; // bypass '0x' character
            [scanner scanHexInt:&result];
            
            self.cmdIDOn = [NSNumber numberWithUnsignedInt:result];
        }
        
        NSString *jsonCmdIDOff = [jsonDictionary objectForKey:@"cmd_idOff"];
        if (jsonCmdIDOff) {
            unsigned int result = 0;
            NSScanner *scanner = [NSScanner scannerWithString:jsonCmdIDOff];
            
            [scanner setScanLocation:2]; // bypass '0x' character
            [scanner scanHexInt:&result];
            
            self.cmdIDOff = [NSNumber numberWithUnsignedInt:result];
        }
        
        NSNumber *jsonAck = [jsonDictionary objectForKey:@"ack"];
        if (jsonAck) {
            self.acks = [jsonAck boolValue];
        }

        
    }
    return self;

}

@end
