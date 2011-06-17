//
//  LockerRoomMenulet.h
//  LockerRoom
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 bilambee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRPreferenceWindow.h"

@interface LRMenulet : NSObject {
	NSStatusItem *statusItem;
	IBOutlet NSMenu *theMenu;
	NSImage *idleIcon;
	NSImage *busyIcon;
}

-(void)setBusy:(BOOL)busy;

@end
