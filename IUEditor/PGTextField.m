//
//  PGTextField.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "PGTextField.h"

@implementation PGTextField


-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.undoManager disableUndoRegistration];
        
        _placeholder = @"placeholder";
        _inputValue = @"value example";
        _tfType = IUTextFieldTypeDefault;
        
        [self.css setValue:@(130) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(30) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        
        [self.undoManager enableUndoRegistration];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [self.undoManager disableUndoRegistration];
        [aDecoder decodeToObject:self withProperties:[[PGTextField class] properties]];
        [self.undoManager enableUndoRegistration];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[PGTextField class] properties]];
    
}

- (id)copyWithZone:(NSZone *)zone{
    PGTextField *iu = [super copyWithZone:zone];
    [self.undoManager disableUndoRegistration];
    
    iu.inputName = [_inputName copy];
    iu.placeholder = [_placeholder copy];
    iu.inputValue = [_inputValue copy];
    iu.tfType = _tfType;
    
    [self.undoManager enableUndoRegistration];
    return iu;
}


#pragma mark -
#pragma mark should

- (BOOL)shouldAddIUByUserInput{
    return NO;
}

#pragma mark -
#pragma mark setting
- (BOOL)hasText{
    return YES;
}

- (void)setInputName:(NSString *)inputName{
    
    if ([_inputName isEqualToString:inputName]) {
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setInputName:_inputName];
    
    _inputName = inputName;
    [self updateHTML];
    [self updateJS];
}

- (void)setPlaceholder:(NSString *)placeholder{
    
    if([_placeholder isEqualToString:placeholder]){
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
- (void)setTfType:(IUTextFieldType)tfType{
    
    if(tfType == _tfType){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setTfType:_tfType];
    
    _tfType = tfType;
    [self updateHTML];
    [self updateJS];
}

@end
