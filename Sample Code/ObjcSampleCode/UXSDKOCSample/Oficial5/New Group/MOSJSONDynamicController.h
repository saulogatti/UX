//
//  MOSJSONDynamicController.h
//  MOS
//
// 
//  Copyright © 2016 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MOSSection.h"
#import "StatusProtocol.h"

@interface MOSJSONDynamicController : UITableViewController<IStatusProtocolDelegate>{
   __weak NSObject<IStatusProtocolDelegate> * _delegateUsuario;
}

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) MOSSection *section;


@end
