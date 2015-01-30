//
//  PlaySoundClass.h
//  Meimei
//
//  Created by namebryant on 14-7-26.
//  Copyright (c) 2014年 Meimei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PlaySoundClass : NSObject
{
    SystemSoundID soundID;
}


-(id)initForPlayingVibrate;


-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type;


-(id)initForPlayingSoundEffectWith:(NSString *)filename;


-(void)play;

@end

