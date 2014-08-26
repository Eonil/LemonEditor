//
//  IUCSS.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCSS.h"
#import "JDUIUtil.h"

@interface IUCSS ()
@property NSMutableDictionary *cssFrameDict;
@property (readwrite) NSMutableDictionary *assembledTagDictionaryForEditWidth;
@end

@implementation IUCSS{
}


-(NSArray*)allViewports{
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
    return [[self.cssFrameDict allKeys] sortedArrayUsingDescriptors:@[sortOrder]];
}

-(id)init{
    self = [super init];
    _cssFrameDict = [[NSMutableDictionary alloc] init];
    _assembledTagDictionaryForEditWidth = [NSMutableDictionary dictionary];

    self.editWidth = IUCSSDefaultViewPort;
    
    [self updateAssembledTagDictionary];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_cssFrameDict forKey:@"cssFrameDict"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    _cssFrameDict = [aDecoder decodeObjectForKey:@"cssFrameDict"];
    self.editWidth = IUCSSDefaultViewPort;
    _assembledTagDictionaryForEditWidth = [NSMutableDictionary dictionary];

    [self updateAssembledTagDictionary];
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IUCSS *css = [[[self class] allocWithZone:zone] init];
    css.cssFrameDict = [self.cssFrameDict deepCopy];
    css.editWidth = self.editWidth;
    css.maxWidth = self.maxWidth;
    css.assembledTagDictionaryForEditWidth = [self.assembledTagDictionaryForEditWidth deepCopy];
    return css;
}



- (BOOL)isPercentTag:(IUCSSTag)tag{
    if([tag isEqualToString:IUCSSTagPercentX]){
        return YES;
    }
    else if([tag isEqualToString:IUCSSTagPercentY]){
        return YES;
    }
    else if([tag isEqualToString:IUCSSTagPercentWidth]){
        return YES;
    }
    else if([tag isEqualToString:IUCSSTagPercentHeight]){
        return YES;
    }
    return NO;
}

- (BOOL)isUndoTag:(IUCSSTag)tag{
    
    //각각 property에서 undo 설정이 들어간 tag 들은 css에서 관리하지 않음.
    if([tag isEqualToString:IUCSSTagImage]){
        return NO;
    }
    else if([tag isFrameTag]){
        return NO;
    }
    
    return YES;
}

//insert tag
//use css frame dict, and update affecting tag dictionary
-(void)setValue:(id)value forTag:(IUCSSTag)tag forViewport:(NSInteger)width{

    [self setValueWithoutUpdateCSS:value forTag:tag forViewport:width];
    [self.delegate updateCSS];
    
}

-(void)setValueWithoutUpdateCSS:(id)value forTag:(IUCSSTag)tag forViewport:(NSInteger)width{
    if ([_delegate CSSShouldChangeValue:value forTag:tag forWidth:width]){
        NSMutableDictionary *cssDict = _cssFrameDict[@(width)];
        
        id currentValue = [cssDict objectForKey:tag];
        if(currentValue == nil ||  [currentValue isNotEqualTo:value]){
            
            if([self isUndoTag:tag]){
                [[[self.delegate undoManager] prepareWithInvocationTarget:self] setValue:currentValue forTag:tag forViewport:width];
            }
            
            if (cssDict == nil) {
                cssDict = [NSMutableDictionary dictionary];
                [_cssFrameDict setObject:cssDict forKey:@(width)];
            }
            if (value == nil) {
                [cssDict removeObjectForKey:tag];
                [_assembledTagDictionaryForEditWidth removeObjectForKey:tag];
            }
            else {
                cssDict[tag] = value;
                [_assembledTagDictionaryForEditWidth setObject:value forKey:tag];
            }
            
        }
        
    }
}

-(id)valueByStepForTag:(IUCSSTag)tag forViewport:(NSInteger)width{
    if( _cssFrameDict[@(width)]){
        id value = [_cssFrameDict[@(width)] objectForKey:tag];
        if(value){
            return value;
        }
    }
    
    id value = [_cssFrameDict[@(IUCSSDefaultViewPort)] objectForKey:tag];
    return value;
}


- (void)copyMaxSizeToSize:(NSInteger)width{
    if(_cssFrameDict[@(width)] == nil){
        NSMutableDictionary *cssDict = [_cssFrameDict[@(IUCSSDefaultViewPort)] mutableCopy];
        [_cssFrameDict setObject:cssDict forKey:@(width)];
    }
}


-(void)eradicateTag:(IUCSSTag)tag{
    for (id key in _cssFrameDict) {
        NSMutableDictionary *cssDict = _cssFrameDict[key];
        [cssDict removeObjectForKey:tag];
    }
    
    if ([tag isFrameTag] == NO) {
        [self updateAssembledTagDictionary];
        [self.delegate updateCSS];
    }
}


-(NSDictionary*)tagDictionaryForViewport:(NSInteger)width{
    return _cssFrameDict[@(width)];
}

-(void)updateAssembledTagDictionary{
    
    //REVIEW: style sheet는 default만 적용됨
    if(_cssFrameDict[@(IUCSSDefaultViewPort)]){
        [_assembledTagDictionaryForEditWidth setDictionary:_cssFrameDict[@(IUCSSDefaultViewPort)]];
    }
    else{
        [_assembledTagDictionaryForEditWidth removeAllObjects];
    }
    
    if(_editWidth != IUCSSDefaultViewPort && _cssFrameDict[@(_editWidth)]){
        [_assembledTagDictionaryForEditWidth addEntriesFromDictionary:_cssFrameDict[@(_editWidth)]];
        
    }
}

-(void)setEditWidth:(NSInteger)editWidth{
    _editWidth = editWidth;
    [self updateAssembledTagDictionary];
}

-(void)removeTagDictionaryForViewport:(NSInteger)width{
    if([_cssFrameDict objectForKey:@(width)]){
        [_cssFrameDict removeObjectForKey:@(width)];
    }
}

-(NSMutableDictionary*)assembledTagDictionary{
    return _assembledTagDictionaryForEditWidth;
}

-(void)setValue:(id)value forTag:(IUCSSTag)tag{
    [self setValue:value forTag:tag forViewport:_editWidth];
}
-(void)setValueWithoutUpdateCSS:(id)value forTag:(NSString *)tag{
    [self setValueWithoutUpdateCSS:value forTag:tag forViewport:_editWidth];

}

-(void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    if ([keyPath containsString:@"assembledTagDictionary."]) {
        NSString *tag = [keyPath substringFromIndex:23];
        [self setValue:value forTag:tag forViewport:_editWidth];
        return;
    }
    else if ([keyPath containsString:@"assembledTagDictionaryWOUpdateCSS."]) {
        NSString *tag = [keyPath substringFromIndex:@"assembledTagDictionaryWOUpdateCSS.".length];
        [self setValueWithoutUpdateCSS:value forTag:tag forViewport:_editWidth];
        return;
    }
    else {
        [super setValue:value forKey:keyPath];
        return;
    }
}

- (BOOL)isSameBorder{
    int borderTop = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderTopWidth] intValue];
    int borderBottom = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderBottomWidth] intValue];
    int borderLeft = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderLeftWidth] intValue];
    int borderRight = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderRightWidth] intValue];
    
    if(borderTop == borderBottom &&
       borderTop == borderLeft &&
       borderTop == borderRight){
        return YES;
    }
    return NO;
}
- (BOOL)isSameRadius{
    int borderTLRadius = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderRadiusTopLeft] intValue];
    int borderTRRadius = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderRadiusTopRight] intValue];
    int borderBLRadius = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderRadiusBottomLeft] intValue];
    int borderBRRadius = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderRadiusBottomRight] intValue];
    
    if(borderTLRadius == borderTRRadius &&
       borderTLRadius == borderBLRadius &&
       borderTLRadius == borderBRRadius){
        return YES;
    }
    return NO;
}

-(id)valueForKeyPath:(NSString *)keyPath{
    if ([keyPath containsString:@"assembledTagDictionary."]) {
        NSString *tag = [keyPath substringFromIndex:23];
        if ([tag isSameTag:IUCSSTagBorderWidth]) {
            NSNumber* value = [self.assembledTagDictionary objectForKey:IUCSSTagBorderWidth];
            if(value == nil){
                return @(0);
            }
            if([self isSameBorder]){
                return value;
            }
            else{
                return NSMultipleValuesMarker;
            }
        }
        //radius multiple
        if ([tag isSameTag:IUCSSTagBorderRadius]) {
            NSNumber* value = [self.assembledTagDictionary objectForKey:IUCSSTagBorderRadius];
            if(value == nil){
                return @(0);
            }
            if([self isSameRadius]){
                return value;
            }
            else{
                return NSMultipleValuesMarker;
            }
        }
        return [_assembledTagDictionaryForEditWidth objectForKey:tag];
    }
    else {
        return [super valueForKey:keyPath];
    }
}


@end