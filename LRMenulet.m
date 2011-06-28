//
//  LockerRoomMenulet.m
//  LockerRoom
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 bilambee. All rights reserved.
//

#import "LRMenulet.h"

@implementation LRMenulet

-(void)setBusy:(BOOL)busy
{
	if (busy) {
		[statusItem setImage:busyIcon];
		[statusItem setAlternateImage:busyIconAlt];
	} else {
		[statusItem setImage:idleIcon];		
		[statusItem setAlternateImage:idleIconAlt];
	}
}

-(void)dealloc
{
	[statusItem release];
	[busyIcon release];
	[idleIcon release];
	
	[super dealloc];
}

-(void)createStatusItem
{
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSSquareStatusItemLength ] 
				  retain];
	
	[statusItem setHighlightMode:YES];
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@"LockerRoom"];
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path;
	path = [bundle pathForResource:@"IdleIcon" ofType:@"png"];
	idleIcon = [[NSImage alloc] initWithContentsOfFile:path];
	
	path = [bundle pathForResource:@"IdleIconActive" ofType:@"png"];
	idleIconAlt = [[NSImage alloc] initWithContentsOfFile:path];
	
	path = [bundle pathForResource:@"DownloadingIcon" ofType:@"png"];
	busyIcon = [[NSImage alloc] initWithContentsOfFile:path];
	
	path = [bundle pathForResource:@"DownloadingIconActive" ofType:@"png"];
	busyIconAlt = [[NSImage alloc] initWithContentsOfFile:path];
	
	[self setBusy:NO];
	
	[statusItem setMenu:theMenu];
}


@end
