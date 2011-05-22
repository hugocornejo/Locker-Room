//
//  DribbbleShot.h
//  LockerRoom
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DribbbleShot : NSObject {

}

+(DribbbleShot*)shot:(NSString*)shotId;
+(NSArray*)rebounds:(NSString*)shotId;
+(NSArray*)debuts;
+(NSArray*)everyone;
+(NSArray*)popular;

@end
