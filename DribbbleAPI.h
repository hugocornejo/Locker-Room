//
//  DribbbleAPI.h
//  LockerRoom
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DribbbleAPI : NSObject {
	NSString *method;
	NSMutableData *currentData;
	id currentDelegate;
}

+(DribbbleAPI*)initWithMethod:(NSString*)m;

-(void)call:(id)delegate;
-(NSDictionary*)syncCall:(NSError**)error;

@end
