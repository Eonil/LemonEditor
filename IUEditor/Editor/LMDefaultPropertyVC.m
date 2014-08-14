//
//  LMDefaultPropertyVC.m
//  IUEditor
//
//  Created by seungmi on 2014. 8. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMDefaultPropertyVC.h"

@interface LMDefaultPropertyVC ()

@end

@implementation LMDefaultPropertyVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    
}

- (void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selection" options:0 context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"selection"]){
        self.selection = _controller.selection;
    }
}

- (void)dealloc{
    if(_controller){
        [_controller removeObserver:self forKeyPath:@"selection"];
    }
}

#pragma mark - binding
- (void)outlet:(id)outlet bind:(NSString *)binding cssTag:(IUCSSTag)tag{
    [outlet bind:binding toObject:self withKeyPath:[self pathForCSSTag:tag] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
}

- (void)outlet:(id)outlet bind:(NSString *)binding property:(IUPropertyTag)property{
    [outlet bind:binding toObject:self withKeyPath:[self pathForProperty:property] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
}

- (void)outlet:(id)outlet bind:(NSString *)binding cssTag:(IUCSSTag)tag options:(NSDictionary *)options{
    [outlet bind:binding toObject:self withKeyPath:[self pathForCSSTag:tag] options:options];
}

- (void)outlet:(id)outlet bind:(NSString *)binding property:(IUPropertyTag)property options:(NSDictionary *)options{
    [outlet bind:binding toObject:self withKeyPath:[self pathForProperty:property] options:options];
}

#pragma mark - value
- (id)valueForCSSTag:(IUCSSTag)tag{
    return [self valueForKeyPath:[self pathForCSSTag:tag]];
}
- (id)valueForPropertyTag:(IUPropertyTag)property{
     return [self valueForKeyPath:[@"self.selection." stringByAppendingString:property]];
}

- (void)setValue:(id)value forCSSTag:(IUCSSTag)tag{
    [self setValue:value forKeyPath:[self pathForCSSTag:tag]];
}
- (void)setValue:(id)value forIUPropertyTag:(IUPropertyTag)property{
    [self setValue:value forKeyPath:[@"self.selection." stringByAppendingString:property]];
}

#pragma mark - observer

- (void)addObserverForCSSTag:(IUCSSTag)tag options:(NSKeyValueObservingOptions)options context:(void *)context{
    [self addObserver:self forKeyPath:[self pathForCSSTag:tag] options:options context:context];
}

- (void)removeObserverForCSSTag:(IUCSSTag)tag{
    [self removeObserver:self forKeyPath:[self pathForCSSTag:tag]];

}

#pragma mark - keyPath
- (NSString *)pathForCSSTag:(IUCSSTag)tag{
    return [@"self.selection.css.assembledTagDictionary." stringByAppendingString:tag];
}
- (NSString *)pathForProperty:(IUPropertyTag)property{
    return [@"self.selection." stringByAppendingString:property];
}

@end
