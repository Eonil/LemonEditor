//
//  IUMenuBarItem.m
//  IUEditor
//
//  Created by seungmi on 2014. 7. 31..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUMenuItem.h"
#import "IUMenuBar.h"
#import "IUProject.h"

@implementation IUMenuItem

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.undoManager disableUndoRegistration];
        
        self.text = @"MENU";
        self.positionType = IUPositionTypeRelative;
        self.overflowType = IUOverflowTypeVisible;
        
        [self.css setValue:[NSColor grayColor] forTag:IUCSSTagBGColor forWidth:IUCSSDefaultViewPort];
        [self.css setValue:[NSColor whiteColor] forTag:IUCSSTagFontColor forWidth:IUCSSDefaultViewPort];
        [self.css setValue:@(1) forTag:IUCSSTagWidthUnitIsPercent forWidth:IUCSSDefaultViewPort];
        
        self.bgActive = [NSColor blackColor];
        self.fontActive = [NSColor whiteColor];

        [self.undoManager enableUndoRegistration];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [[self undoManager] disableUndoRegistration];
        
        [aDecoder decodeToObject:self withProperties:[[IUMenuItem class] propertiesWithOutProperties:@[@"isOpened"]]];
        
        [[self undoManager] enableUndoRegistration];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUMenuItem class]  propertiesWithOutProperties:@[@"isOpened"]]];
}

- (id)copyWithZone:(NSZone *)zone{
    IUMenuItem *menuItem = [super copyWithZone:zone];
    [self.undoManager disableUndoRegistration];
    
    menuItem.bgActive = [NSColor grayColor];
    menuItem.fontActive = [NSColor whiteColor];
    
    [self.undoManager enableUndoRegistration];
    return menuItem;
}


- (void)connectWithEditor{
    [super connectWithEditor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionChanged:) name:IUNotificationSelectionDidChange object:nil];
    [self addObserver:self forKeyPath:@"parent.css.assembledTagDictionary.height" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:@"height"];


}

- (void)dealloc{
    if([self isConnectedWithEditor]){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeObserver:self forKeyPath:@"parent.css.assembledTagDictionary.height"];
    }
}


-(void)selectionChanged:(NSNotification*)noti{
    
    if(self.children.count > 0 && self.css.editWidth > 640){
        NSMutableSet *set = [NSMutableSet setWithArray:[self.allChildren arrayByAddingObject:self]];
        [set intersectSet:[NSSet setWithArray:[noti userInfo][@"selectedObjects"]]];
        
        if ([set count] >= 1) {
            _isOpened = YES;
        }
        else{
            _isOpened = NO;
        }
        
        [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:[self editorDisplayIdentifier]];

    }
    
}


- (void)heightContextDidChange:(NSDictionary *)dictionary{
    JDInfoLog(@"haha");
    if(self.depth==1){
        [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:[self itemIdentifier]];
        if(self.children.count >0){
            [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:[self closureIdentifier]];
        }

    }
}



#pragma mark - count
- (void)setCount:(NSInteger)count{
    if (count < 1 || count > 20 || count == self.children.count ) {
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
            IUMenuItem *subMenu = [[IUMenuItem alloc] initWithProject:self.project options:nil];
            subMenu.name = subMenu.htmlID;
            [self addIU:subMenu error:nil];
        }
        
        if (self.isConnectedWithEditor) {
            [self.project.identifierManager confirm];
        }
    }
    
    
    [self updateHTML];
    
}

- (NSInteger)count{
    return [self.children count];
}

#pragma mark - depth

- (NSInteger)depth{
    if([self.parent isKindOfClass:[IUMenuBar class]]){
        return 1;
    }
    else if([self.parent isKindOfClass:[IUMenuItem class]]){
        return 1 + [(IUMenuItem *)self.parent depth];
    }
    return 0;
}

- (BOOL)hasItemChildren{
    if([self depth] > 2){
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - property

- (void)setBgActive:(NSColor *)bgActive{
    if([_bgActive isEqualTo:bgActive]){
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setBgActive:_bgActive];
    _bgActive = bgActive;

    [self cssForItemColor];
}

- (void)setFontActive:(NSColor *)fontActive{
    if([_fontActive isEqualTo:fontActive]){
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setFontActive:_fontActive];
    _fontActive = fontActive;
    
    [self cssForItemColor];
}

#pragma mark - css
- (NSString *)editorDisplayIdentifier{
    if(self.children.count > 0){
        return [[self.htmlID cssClass] stringByAppendingString:@" > ul"];
    }
    return nil;
}

- (NSString *)itemIdentifier{
    return [[self.htmlID cssClass] stringByAppendingString:@" > a"];
}
- (NSString *)hoverItemIdentifier{
    return [[[self.htmlID cssClass] cssHoverClass] stringByAppendingString:@" > a"];
}

- (NSString *)activeItemIdentifier{
    return [[[self.htmlID cssClass] cssActiveClass] stringByAppendingString:@" > a"];
}
- (NSString *)closureIdentifier{
    if(self.children.count > 0){
        return [[self.htmlID cssClass] stringByAppendingString:@" > div.closure"];
    }
    return nil;
}

- (NSArray *)cssIdentifierArray{
    if(self.children.count > 0){
        return @[[self.htmlID cssClass], [self itemIdentifier], [self hoverItemIdentifier], [self activeItemIdentifier], [self closureIdentifier], [self editorDisplayIdentifier]];
    }
    else{
        return @[[self.htmlID cssClass], [self itemIdentifier], [self hoverItemIdentifier], [self activeItemIdentifier]];
    }
}


- (void)cssForItemColor{
    if(self.delegate){
        [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:[self hoverItemIdentifier]];
        [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:[self activeItemIdentifier]];
    }
}


#pragma mark - shouldXXX

- (BOOL)hasX{
    return NO;
}
- (BOOL)hasY{
    return NO;
}
- (BOOL)hasHeight{
    return NO;
}
- (BOOL)hasWidth{
    return YES;
}
- (BOOL)canChangeWidthByUserInput{
    return NO;
}
- (BOOL)canChangePositionType{
    return NO;
}
- (BOOL)canChangeOverflow{
    return NO;
}
- (BOOL)shouldAddIUByUserInput{
    return NO;
}
- (BOOL)shouldRemoveIUByUserInput{
    return NO;
}

@end
