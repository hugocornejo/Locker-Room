//
//  LRPreferenceWindow.m
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LRPreferenceWindow.h"

@implementation LRPreferenceWindow

-(IBAction)chooseDirectory:(id)sender {
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setCanChooseFiles:NO];
	[op setCanCreateDirectories:YES];
	[op setCanChooseDirectories:YES];
	[op beginSheetModalForWindow:self completionHandler:^(NSInteger result) {
		if (result == NSOKButton) {
			[op orderOut:self];
			NSLog(@"User chose %@", [op filename]);
		}
	}];
	NSLog(@"choosing directory");
}

@end
