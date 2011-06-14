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
	NSString *username = [defaults stringForKey:@"DribbbleUserName"];
	if (username == nil) {
		username = @"";
	}
	[txtUsername setStringValue:username];
	
	NSString *directory = [defaults stringForKey:@"LockerRoomDirectory"];
	if (directory == nil) {
		directory = NSHomeDirectory();
	}
	[pathPopUp setPath:directory];
}

-(void)close
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[pathPopUp path]			forKey:@"LockerRoomDirectory"];
	[defaults setObject:[txtUsername stringValue]	forKey:@"DribbbleUserName"];
	[defaults synchronize];
	[super close];
}

@end
