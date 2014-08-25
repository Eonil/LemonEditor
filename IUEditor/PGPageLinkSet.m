//
//  PGPageLinkSet.m
//  IUEditor
//
//  Created by jd on 5/8/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "PGPageLinkSet.h"

@implementation PGPageLinkSet


- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    [[self undoManager] disableUndoRegistration];

    if(self){
        _pageLinkAlign = IUAlignCenter;
        _selectedButtonBGColor = [NSColor rgbColorRed:50 green:50 blue:50 alpha:0.5];
        _defaultButtonBGColor = [NSColor rgbColorRed:50 green:50 blue:50 alpha:0.5];
        _buttonMargin = 5.0f;
    }
    
    [[self undoManager] enableUndoRegistration];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[self class] properties]];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [[self undoManager] disableUndoRegistration];

    [aDecoder decodeToObject:self withProperties:[[self class] properties]];
    _buttonMargin = 2;
    
    [[self undoManager] enableUndoRegistration];

    return self;
}


- (id)copyWithZone:(NSZone *)zone{
    PGPageLinkSet *iu = [super copyWithZone:zone];
    [[self undoManager] disableUndoRegistration];
    [self.delegate disableUpdateAll:self];


    iu.pageCountVariable = [_pageCountVariable copy];
    iu.pageLinkAlign = _pageLinkAlign;
    iu.selectedButtonBGColor = [_selectedButtonBGColor copy];
    iu.defaultButtonBGColor = [_defaultButtonBGColor copy];
    iu.buttonMargin = _buttonMargin;
    
    [self.delegate enableUpdateAll:self];
    [[self undoManager] enableUndoRegistration];

    return iu;
}

- (void)setPageLinkAlign:(IUAlign)pageLinkAlign{
    if (_pageLinkAlign == pageLinkAlign) {
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setPageLinkAlign:_pageLinkAlign];
    
    _pageLinkAlign = pageLinkAlign;
    [self updateCSS];

}

- (void)setSelectedButtonBGColor:(NSColor *)selectedButtonBGColor{
    
    if([_selectedButtonBGColor isEqualTo:selectedButtonBGColor]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setSelectedButtonBGColor:_selectedButtonBGColor];
    
    _selectedButtonBGColor = selectedButtonBGColor;
    [self updateCSS];
}

- (void)setDefaultButtonBGColor:(NSColor *)defaultButtonBGColor{
    
    if([_defaultButtonBGColor isEqualTo:defaultButtonBGColor]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setDefaultButtonBGColor:_defaultButtonBGColor];
    
    _defaultButtonBGColor = defaultButtonBGColor;
    [self updateCSS];
}

- (void)setButtonMargin:(float)buttonMargin{
    
    if(_buttonMargin != buttonMargin){
    
        [[self.undoManager prepareWithInvocationTarget:self] setButtonMargin:_buttonMargin];
        
        _buttonMargin = buttonMargin;
        [self updateCSS];
    }
}
#pragma mark - shouldXXX

- (BOOL)shouldAddIUByUserInput{
    return NO;
}

#pragma mark - css

@end