//
//  PGTextView.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "PGTextView.h"

@implementation PGTextView

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    [[self undoManager] disableUndoRegistration];

    if(self){

        _placeholder = @"placeholder";
        _inputValue = @"Sample Text";
        
        [self.css setValue:@(130) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(50) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@"1.3" forTag:IUCSSTagLineHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(IUAlignLeft) forTag:IUCSSTagTextAlign forWidth:IUCSSMaxViewPortWidth];
        
    }
    [[self undoManager] enableUndoRegistration];

    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    [[self undoManager] disableUndoRegistration];

    if(self){
        
        [aDecoder decodeToObject:self withProperties:[[PGTextView class] properties]];
    }
    [[self undoManager] enableUndoRegistration];

    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[PGTextView class] properties]];
    
}

- (id)copyWithZone:(NSZone *)zone{
    PGTextView *iu = [super copyWithZone:zone];
    [[self undoManager] disableUndoRegistration];

    iu.placeholder = [_placeholder copy];
    iu.inputValue = [_inputValue copy];
    
    [[self undoManager] enableUndoRegistration];

    return iu;
}

- (BOOL)shouldAddIUByUserInput{
    return NO;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    if(self.delegate){
        [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.htmlID];
    }
    
    [self updateHTML];
    [self updateJS];
}

- (void)setInputValue:(NSString *)inputValue{
    _inputValue = inputValue;
    if(self.delegate){
        [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.htmlID];
    }
    
    [self updateHTML];
    [self updateJS];
}

- (BOOL)hasText{
    return YES;
}

@end
