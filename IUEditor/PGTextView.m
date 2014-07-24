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

    if(self){
        [[self undoManager] disableUndoRegistration];


        _placeholder = @"placeholder";
        _inputValue = @"Sample Text";
        
        [self.css setValue:@(130) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(50) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@"1.3" forTag:IUCSSTagLineHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(IUAlignLeft) forTag:IUCSSTagTextAlign forWidth:IUCSSMaxViewPortWidth];
        
        [[self undoManager] enableUndoRegistration];

        
    }

    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];

    if(self){
        [[self undoManager] disableUndoRegistration];
        
        [aDecoder decodeToObject:self withProperties:[[PGTextView class] properties]];
        
        [[self undoManager] enableUndoRegistration];

    }

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
    
    if([placeholder isEqualToString:_placeholder]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setPlaceholder:_placeholder];
    
    _placeholder = placeholder;

    
    [self updateHTML];
    [self updateJS];
}

- (void)setInputValue:(NSString *)inputValue{
    
    if([_inputValue isEqualToString:inputValue]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setInputValue:_inputValue];
    
    _inputValue = inputValue;

    
    [self updateHTML];
    [self updateJS];
}

- (void)setInputName:(NSString *)inputName{
    if([_inputName isEqualToString:inputName]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setInputName:_inputName];
    
    _inputName = inputName;
}

- (BOOL)hasText{
    return YES;
}

@end
