//
//  LockerRoomMenulet.m
//  LockerRoom
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LRMenulet.h"


@implementation LRMenulet

-(void)setIdle
{
	[statusItem setTitle:@"idle"];
	[statusItem setImage:idleIcon];
}

-(void)setBusy
{
	[statusItem setTitle:@"working..."];
	[statusItem setImage:busyIcon];
}

-(void)dealloc
{
	[statusItem release];
	[busyIcon release];
	[idleIcon release];
	
	[updateTimer release];
	[super dealloc];
}

-(void)awakeFromNib
{
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSVariableStatusItemLength] 
				  retain];
	
	[statusItem setHighlightMode:YES];
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@"LockerRoom"];
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"IdleIcon" ofType:@"png"];
	idleIcon = [[NSImage alloc] initWithContentsOfFile:path];
	
	path = [bundle pathForResource:@"DownloadingIcon" ofType:@"png"];
	busyIcon = [[NSImage alloc] initWithContentsOfFile:path];
	
	[self setIdle];
	
	[statusItem setMenu:theMenu];

	updateTimer = [[NSTimer
					scheduledTimerWithTimeInterval:30.0
					target:self
					selector:@selector(downloadLikes)
					userInfo:nil
					repeats:YES] retain];
	
	[updateTimer fire];
	
}

-(void)downloadLikes
{
	[self setBusy];
	NSLog(@"Downloading Dribbble likes...");
	
	NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
	NSURLRequest *req = [NSURLRequest requestWithURL:url];
	NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:req delegate:self];
	if (download) {
		[download setDestination:@"/tmp/goog" allowOverwrite:YES];
	} else {
		// download failed
	}

//	[NSURLConnection connectionWithRequest:req delegate:<#(id)delegate#>];
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
	[self setIdle];
	
    // Release the connection.
    [download release];
	
    // Inform the user.
    NSLog(@"Download failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)downloadDidFinish:(NSURLDownload *)download
{
	[self setIdle];
	
    // Release the connection.
    [download release];
	
    // Do something with the data.
    NSLog(@"%@",@"downloadDidFinish");
}

@end
