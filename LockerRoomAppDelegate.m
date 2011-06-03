//
//  LockerRoomAppDelegate.m
//  LockerRoom
//
//  Created by Joni Salonen on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LockerRoomAppDelegate.h"
#import "DribbbleLikeDownloader.h"

@implementation LockerRoomAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	updateTimer = [[NSTimer
					scheduledTimerWithTimeInterval:120.0
					target:self
					selector:@selector(downloadLikes)
					userInfo:nil
					repeats:YES] retain];
	
	NSString *playerId = @"neora";
	downloader = [DribbbleLikeDownloader initWithPlayer:playerId];
	[updateTimer fire];
}

-(void)dealloc
{
	[updateTimer release];
	[super dealloc];
}

-(void)downloadLikes
{
	//[menulet setBusy:YES];
	NSLog(@"Downloading Dribbble likes...");
	
	//NSString *playerId = @"simplebits";
	//DribbbleLikeDownloader *downloader = [DribbbleLikeDownloader initWithPlayer:playerId];
	[downloader downloadLikes:self];
}

-(void)dribbbleLikeDownloaderFinished:(DribbbleLikeDownloader*)downloader
{
	NSLog(@"Downloader finished");
	[menulet setBusy:NO];
}

-(void)dribbbleLikeDownloaderStarted:(DribbbleLikeDownloader*)downloader
{
	NSLog(@"Downloader started");
	[menulet setBusy:YES];
}

@end
