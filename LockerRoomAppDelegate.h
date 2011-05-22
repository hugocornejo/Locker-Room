//
//  LockerRoomAppDelegate.h
//  LockerRoom
//
//  Created by Joni Salonen on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LRMenulet.h"
#import "LRPreferenceWindow.h"

@interface LockerRoomAppDelegate : NSObject <NSApplicationDelegate> {
	IBOutlet LRMenulet *menulet;
	IBOutlet LRPreferenceWindow *preferenceWindow;
	
	NSTimer *updateTimer;
}

-(void)downloadLikes;

@end
