//
//  IUMovie.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUMovie.h"
#import <AVFoundation/AVFoundation.h>

#import "IUImageUtil.h"
#import "IUDocument.h"
#import "IUCompiler.h"


@implementation IUMovie

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUMovie class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUMovie class] properties]];
    
}

- (BOOL)shouldAddIU{
    return NO;
}
- (NSArray *)HTMLOneAttribute{
    NSMutableArray *array = [[super HTMLOneAttribute] mutableCopy];
    
    if(self.enableControl){
        [array addObject:@"controls"];
    }
    if(self.enableLoop){
        [array addObject:@"loop"];
    }
    if(self.enableMute){
        [array addObject:@"muted"];
    }
    if(self.enableAutoPlay){
        [array addObject:@"autoplay"];
    }
    
    return array;
}

- (NSDictionary *)HTMLAtributes{
    NSMutableDictionary *dict = [[super HTMLAtributes] mutableCopy];
    
    if(self.enableControl == NO){
        [dict setObject:@(1) forKey:@"movieNoControl"];
    }
    
    if(self.enablePoster){
        [dict setObject:self.posterPath forKey:@"poster"];
    }

    return dict;
}


@end