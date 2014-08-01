//
//  IUMenuBar.m
//  IUEditor
//
//  Created by seungmi on 2014. 7. 31..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUMenuBar.h"
#import "IUMenuItem.h"
#import "IUProject.h"

@implementation IUMenuBar

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [[self undoManager] disableUndoRegistration];
        
        self.count = 3;
        self.align = IUAlignLeft;
        self.overflowType = IUOverflowTypeVisible;
        
        self.mobileTitle = @"MENU";
        self.iconColor = [NSColor whiteColor];
        
        [[self undoManager] enableUndoRegistration];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [[self undoManager] disableUndoRegistration];
        
        [aDecoder decodeToObject:self withProperties:[[IUMenuBar class] properties]];
        
        [[self undoManager] enableUndoRegistration];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUMenuBar class] properties]];
}

- (id)copyWithZone:(NSZone *)zone{
    IUMenuBar *menuBar = [super copyWithZone:zone];
    [self.undoManager disableUndoRegistration];
    
    //menubar
    menuBar.align = self.align;
    
    //mobile
    menuBar.mobileTitle = [self.mobileTitle copy];
    menuBar.iconColor = [self.iconColor copy];
    
    [self.undoManager enableUndoRegistration];
    return menuBar;
}

#pragma mark - count
- (void)setCount:(NSInteger)count{
    if (count <= 1 || count > 20 || count == self.children.count ) {
        return;
    }
    if( count < self.children.count ){
        NSInteger diff = self.children.count - count;
        for( NSInteger i=0 ; i < diff ; i++ ) {
            [self removeIUAtIndex:[self.children count]-1];
        }
    }
    else if(count > self.children.count) {
        if (self.isConnectedWithEditor) {
            [self.project.identifierManager resetUnconfirmedIUs];
        }
        
        
        for(NSInteger i=self.children.count; i <count; i++){
            IUMenuItem *item = [[IUMenuItem alloc] initWithProject:self.project options:nil];
            item.name = item.htmlID;
            [self addIU:item error:nil];
        }
        
        if (self.isConnectedWithEditor) {
            [self.project.identifierManager confirm];
        }
    }
    
    CGFloat width = (CGFloat)((CGFloat)100/(CGFloat)self.children.count);
    for(IUMenuItem *item in self.children){
        [item.css setValue:@(width) forTag:IUCSSTagPercentWidth forWidth:IUCSSMaxViewPortWidth];
        [item updateCSSForMaxViewPort];
    }
    
    [self updateHTML];

}

- (NSInteger)count{
    return [self.children count];
}



#pragma mark - setProperty

- (void)setMobileTitle:(NSString *)mobileTitle{
    if([_mobileTitle isEqualToString:mobileTitle]){
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setMobileTitle:_mobileTitle];
    _mobileTitle = mobileTitle;
}

- (void)setIconColor:(NSColor *)iconColor{
    if([_iconColor isEqualTo:iconColor]){
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setIconColor:_iconColor];
    _iconColor = iconColor;
}

#pragma mark - changeXXX

- (BOOL)canChangeOverflow{
    return NO;
}

@end
