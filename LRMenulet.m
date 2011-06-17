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
	} else {
		[statusItem setImage:idleIcon];		
		
	}
}

-(void)dealloc
{
	[statusItem release];
	[busyIcon release];
	[idleIcon release];
	
	[super dealloc];
}

-(void)awakeFromNib
{
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSSquareStatusItemLength ] 
				  retain];
	
	[statusItem setHighlightMode:YES];
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@"LockerRoom"];
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"IdleIcon" ofType:@"png"];
	idleIcon = [[NSImage alloc] initWithContentsOfFile:path];
	
	path = [bundle pathForResource:@"DownloadingIcon" ofType:@"png"];
	busyIcon = [[NSImage alloc] initWithContentsOfFile:path];
	
	[self setBusy:NO];
	
	[statusItem setMenu:theMenu];
}


@end
