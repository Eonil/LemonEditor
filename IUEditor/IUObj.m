//
//  IUObj.m
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUObj.h"
#import "NSObject+JDExtension.h"
#import "NSCoder+JDExtension.h"

@implementation IUObj{
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[[IUObj class] properties]];
        _css = [aDecoder decodeObjectForKey:@"css"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if ([self.htmlID length] == 0) {
        assert(0);
    }
    [aCoder encodeFromObject:self withProperties:[[IUObj class] properties]];
    [aCoder encodeObject:self.css forKey:@"css"];
}

-(id)initWithProject:(IUProject*)project setting:(NSDictionary*)setting{
    self = [super init];{
        _project = project;
        _css = [[IUCSS alloc] init];
        [_css putTag:IUCSSTagWidth value:@(50)];
        [_css putTag:IUCSSTagHeight value:@(35)];
        [_css putTag:IUCSSTagBGColor value:[NSColor randomColor]];
    }
    return self;
}



-(id)init{
    assert(0);
    return nil;
}

-(NSMutableArray*)allChildren{
    if (self.children) {
        NSMutableArray *array = [NSMutableArray array];
        for (IUObj *iu in self.children) {
            [array addObject:iu];
            [array addObjectsFromArray:iu.allChildren];
        }
        return array;
    }
    return nil;
}

-(NSDictionary*)HTMLAtributes{
    NSArray *classPedigree = [[self class] classPedigreeTo:[IUObj class]];
    NSMutableString *className = [NSMutableString stringWithString:@"'"];
    for (NSString *str in classPedigree) {
        [className appendString:str];
        [className appendString:@" "];
    }
    [className trim];
    [className appendString:@"'"];
    return @{@"class":className, @"id":self.htmlID};
}


-(NSDictionary*)CSSAttributesForWidth:(NSInteger)width{
    return [_css tagDictionaryForWidth:(int)width];
}


@end
