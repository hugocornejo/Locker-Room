//
//  LRPathPopUpButton.m
//  LockerRoom
//
//  Created by Joni Salonen on 6/10/11.
//  Copyright 2011 bilambee. All rights reserved.
//

#import "LRPathPopUpButton.h"


@implementation LRPathPopUpButton

@synthesize path;

-(void)setPath:(NSString *)fileName
{
	path = [fileName retain];
	
	NSWorkspace *ws = [NSWorkspace sharedWorkspace];  
	NSImage *icon = [ws iconForFile:fileName];
	NSSize iconSize = {18,18};
	[icon setSize:iconSize];
	
	
	NSMenu *m = [self menu];
	[m removeAllItems];
	
	NSMenuItem *item = [m addItemWithTitle:[path lastPathComponent]
									action:nil 
							 keyEquivalent:@""];
	[item setImage:icon];
	
	[m addItem:[NSMenuItem separatorItem]];
	[[m addItemWithTitle:@"Other..." 
				  action:@selector(chooseDirectory:) 
		   keyEquivalent:@""] 
	 setTarget:self];
}

-(void)chooseDirectory:(id)sender {
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setCanChooseFiles:NO];
	[op setCanCreateDirectories:YES];
	[op setCanChooseDirectories:YES];
	[op beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
		if (result == NSOKButton) {
			[op orderOut:self];
			self.path = [op filename];
		}
		[self selectItemAtIndex:0];
	}];
}


-(void)dealloc
{
	[path release];
	[super dealloc];
}

@end
