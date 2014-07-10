//
//  IUSheet.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUSheet.h"
#import "IUProject.h"

@implementation IUSheet

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        _ghostOpacity = 0.5;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _ghostX = [aDecoder decodeFloatForKey:@"ghostX"];
        _ghostY = [aDecoder decodeFloatForKey:@"ghostY"];
        _ghostOpacity = [aDecoder decodeFloatForKey:@"ghostOpacity"];
        _ghostImageName = [aDecoder decodeObjectForKey:@"ghostImageName"];
        _group = [aDecoder decodeObjectForKey:@"group"];

    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFloat:_ghostX forKey:@"ghostX"];
    [aCoder encodeFloat:_ghostY forKey:@"ghostY"];
    [aCoder encodeFloat:_ghostOpacity forKey:@"ghostOpacity"];
    [aCoder encodeObject:_ghostImageName forKey:@"ghostImageName"];
    [aCoder encodeObject:_group forKey:@"group"];
}

- (id)copyWithZone:(NSZone *)zone{
    
    IUSheet *sheet = [super copyWithZone:zone];
    
    return sheet;
}

- (BOOL)canChangeXByUserInput{
    return NO;
}
- (BOOL)canChangeYByUserInput{
    return NO;
}
- (BOOL)canChangeWidthByUserInput{
    return NO;
}

- (BOOL)canChangeHeightByUserInput{
    return NO;
}




-(NSString*)editorSource{
    NSAssert(self.project.compiler, @"compiler");
    return [self.project.compiler editorSource:self mqSizeArray:self.project.mqSizes];
}

- (NSString*)outputSource{
    NSAssert(self.project.compiler, @"compiler");
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
    NSArray *sortedArray= [self.project.mqSizes sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    
    
    return [self.project.compiler outputSource:self mqSizeArray:sortedArray];;
}

- (NSString*)outputInitJSSource{
    return [self.project.compiler outputJSInitializeSource:self];
}

-(NSArray*)widthWithCSS{
    return @[];
}

-(IUBox *)selectableIUAtPoint:(CGPoint)point{
    return nil;
}

-(IUBox*)parent{
    return nil;
}

-(void)setParent:(IUBox *)parent{
#if DEBUG
//    NSAssert(0, @"");
#endif
}

@end
