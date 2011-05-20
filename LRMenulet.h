//
//  LockerRoomMenulet.h
//  LockerRoom
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRPreferenceWindow.h"

@interface LRMenulet : NSObject {
	
	NSStatusItem *statusItem;
	
	IBOutlet NSMenu *theMenu;
	IBOutlet LRPreferenceWindow *preferenceWindow;
	
	NSImage *idleIcon;
	NSImage *busyIcon;
	
	NSTimer *updateTimer;

}

-(void)downloadLikes;

@end
