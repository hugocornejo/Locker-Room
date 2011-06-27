//
//  LockerRoomAppDelegate.m
//  LockerRoom
//
//  Created by Joni Salonen on 5/13/11.
//  Copyright 2011 bilambee. All rights reserved.
//

#import "LockerRoomAppDelegate.h"
#import "DribbbleLikeDownloader.h"

@implementation LockerRoomAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	downloader = nil;
	updateTimer = [[NSTimer
					scheduledTimerWithTimeInterval:120.0
					target:self
					selector:@selector(downloadLikes)
					userInfo:nil
					repeats:YES] retain];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults stringForKey:@"DribbbleUserName"] == nil) {
		[welcomeWindow makeKeyAndOrderFront:self];
	}
}

-(void)dealloc
{
	[updateTimer release];
	[downloader release];
	[super dealloc];
}

-(void)downloadLikes
{
	static NSInteger fullScanCountdown = 0;
	// what if user name or directory is changed while the downloader is working?
	if (downloader == nil) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSString *username = [defaults stringForKey:@"DribbbleUserName"];
		NSString *directory = [defaults stringForKey:@"LockerRoomDirectory"];
		if (username != nil && directory != nil) {
			downloader = [[DribbbleLikeDownloader alloc] initWithPlayer:username directory:directory];
			if (fullScanCountdown == 0) {
				NSLog(@"Too long since last full check, checking all pages");
				downloader.checkAllPages = YES;
				fullScanCountdown = 60;
			}
		} else {
			downloader = nil;
			// no username, no directory; bail out
			return;
		}
	}
	[downloader downloadLikes:self];
	fullScanCountdown -= 1;
}

-(void)dribbbleLikeDownloaderFinished:(DribbbleLikeDownloader*)dld
{
	NSLog(@"Downloader finished");
	[menulet setBusy:NO];
	[downloader release];
	downloader = nil;
}

-(void)dribbbleLikeDownloaderStarted:(DribbbleLikeDownloader*)dld
{
	// Set to busy when an actual image download starts, not yet
	// [menulet setBusy:YES];
}

-(void)dribbbleLikeDownloader:(DribbbleLikeDownloader *)dld downloadDidBegin:(NSURLDownload*)download
{
	[menulet setBusy:YES];
}

-(IBAction)openDirectory:(id)sender
{
	NSString *dirName = [[NSUserDefaults standardUserDefaults] stringForKey:@"LockerRoomDirectory"];
	[[NSWorkspace sharedWorkspace] openFile:dirName];
}

-(IBAction)goToWeb:(id)sender
{
	NSURL *url = [NSURL URLWithString:@"http://www.dribbble.com"];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

-(IBAction)showPreferences:(id)sender
{
	[NSApp activateIgnoringOtherApps:YES];
	[preferenceWindow makeKeyAndOrderFront:self];
}

-(void)windowWillClose:(NSNotification*)notification;
{
	NSLog(@"Requesting sync because preference window was closed");
	[self downloadLikes];
}

-(void)windowDidBecomeMain:(NSNotification*)notification;
{
	LRPreferenceWindow *win = [notification object];
	[win readDefaults:self];
}

@end
