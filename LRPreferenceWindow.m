//
//  LRPreferenceWindow.m
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LRPreferenceWindow.h"

@implementation LRPreferenceWindow

-(void)awakeFromNib
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *lrdir = [defaults stringForKey:@"LockerRoomDirectory"];

	[txtUsername setStringValue:[defaults stringForKey:@"DribbbleUserName"]];

	[txtDirectory setStringValue:lrdir];
	
	[pathPopUp setPath:lrdir];

}

-(IBAction)handleAccept:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[txtDirectory stringValue]	forKey:@"LockerRoomDirectory"];
	[defaults setObject:[txtUsername stringValue]	forKey:@"DribbbleUserName"];
	[defaults synchronize];
	[super close];
}

-(IBAction)handleCancel:(id)sender
{
	[super close];
}

-(void)pathControl:(NSPathControl *)pathControl willDisplayOpenPanel:(NSOpenPanel *)openPanel
{
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanCreateDirectories:YES];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setPrompt:@"Choose the download location for your dribbble likes"];
}

@end
