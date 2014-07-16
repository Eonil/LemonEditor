//
//  IUCarousel.m
//  IUEditor
//
//  Created by jd on 4/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCarousel.h"
#import "IUCarouselItem.h"
#import "IUSheet.h"
#import "IUProject.h"

@implementation IUCarousel{
    BOOL initializing;
}

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        initializing = YES;
        self.count = 3;
        [self.css setValue:@(500) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(300) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:[NSColor clearColor] forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
        _selectColor = [NSColor blackColor];
        _deselectColor = [NSColor grayColor];
        _rightArrowImage = @"arrow_right.png";
        _leftArrowImage = @"arrow_left.png";
        _leftY = 100;
        _rightY = 100;
        _pagerPosition = 50;
        initializing = NO;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUCarousel class] propertiesWithOutProperties:@[@"count"]]];
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUCarousel class] propertiesWithOutProperties:@[@"count"]]];
    
}

- (id)copyWithZone:(NSZone *)zone{
    IUCarousel *carousel = [super copyWithZone:zone];
    //auto
    carousel.autoplay = _autoplay;
    carousel.timer = _timer;
    //arrow
    carousel.disableArrowControl = _disableArrowControl;
    carousel.leftArrowImage = [_leftArrowImage copy];
    carousel.rightArrowImage = [_rightArrowImage copy];
    carousel.leftX = _leftX;
    carousel.leftY = _leftY;
    carousel.rightX = _rightX;
    carousel.rightY = _rightY;
    
    //pager
    carousel.controlType = _controlType;
    carousel.selectColor = [_selectColor copy];
    carousel.deselectColor = [_deselectColor copy];
    carousel.pagerPosition = _pagerPosition;
    
    return carousel;
}


- (void)connectWithEditor{
    [super connectWithEditor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionChanged:) name:IUNotificationSelectionDidChange object:nil];
    
    if(self.children.count > 0){
        IUCarouselItem *item = self.children[0];
        item.isActive = YES;
    }
    


}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setCount:(NSInteger)count{
    
    if (count <= 1 || count > 30 || count == self.children.count ) {
        return;
    }
    if( count < self.children.count ){
        NSInteger diff = self.children.count - count;
        for( NSInteger i=0 ; i < diff ; i++ ) {
            [self removeIUAtIndex:[self.children count]-1];
        }
    }
    else if(count > self.children.count) {
        if (initializing == NO) {
            [self.project.identifierManager resetUnconfirmedIUs];
        }

        for(NSInteger i=self.children.count; i <count; i++){
            IUCarouselItem *item = [[IUCarouselItem alloc] initWithProject:self.project options:nil];
            item.name = item.htmlID;
            [self addIU:item error:nil];
        }
        
        if (initializing == NO) {
            [self.project.identifierManager confirm];
        }
    }

    
    [self updateHTML];
}

-(void)remakeChildrenHtmlID{
    for (IUCarouselItem *item in self.children) {
        if ([item isKindOfClass:[IUItem class]]) {
            [item setHtmlID:[NSString stringWithFormat:@"%@-Templorary%ld", self.name, [self.children indexOfObject:item]]];
        }
    }
    for (IUCarouselItem *item in self.children) {
        if ([item isKindOfClass:[IUItem class]]) {
            [item setHtmlID:[NSString stringWithFormat:@"%@-%ld", self.name, [self.children indexOfObject:item]]];
        }
    }
}

-(void)selectionChanged:(NSNotification*)noti{
    NSMutableSet *set = [NSMutableSet setWithArray:self.children];
    [set intersectSet:[NSSet setWithArray:[noti userInfo][@"selectedObjects"]]];
    if ([set count] != 1) {
        return;
    }
    IUBox *selectedChild = [set anyObject];
    for(IUCarouselItem *item in self.children){
        if([item isEqualTo:selectedChild]){
            [item.css setValue:@(YES) forTag:IUCSSTagDisplay];
            item.isActive = YES;
        }
        else{
            [item.css setValue:@(NO) forTag:IUCSSTagDisplay];
            item.isActive = NO;
        }
    }
    
    [self updateHTML];
    [self updateJS];
}

- (NSInteger)count{
    return [self.children count];
}

#pragma mark Inner CSS (Carousel)
- (NSString *)pagerWrapperID{
    return [NSString stringWithFormat:@"%@ > .Pager", [self.htmlID cssClass]];
}

- (NSString *)pagerID{
    return [NSString stringWithFormat:@"%@ > .Pager > li", [self.htmlID cssClass]];
}
- (NSString *)prevID{
    return [NSString stringWithFormat:@"%@ > .Prev", [self.htmlID cssClass]];
}

- (NSString *)nextID{
    return [NSString stringWithFormat:@"%@ > .Next", [self.htmlID cssClass]];
}

- (NSArray *)cssIdentifierArray{
    NSMutableArray *cssArray = [[super cssIdentifierArray] mutableCopy];
    
    if(self.disableArrowControl == NO){
        [cssArray addObject:self.prevID];
        [cssArray addObject:self.nextID];
    }
    if(self.controlType == IUCarouselControlBottom){
        [cssArray addObjectsFromArray:@[self.pagerID, [self.pagerID cssHoverClass], [self.pagerID cssActiveClass], self.pagerWrapperID]];
    }
    
    return cssArray;
}


#pragma mark - pager
- (void)setControlType:(IUCarouselControlType)controlType{
    _controlType = controlType;
    [self updateHTML];
    [self cssForItemColor];
}

- (void)setSelectColor:(NSColor *)selectColor{
    _selectColor = selectColor;
    [self cssForItemColor];
}
- (void)setDeselectColor:(NSColor *)deselectColor{
    _deselectColor = deselectColor;
    [self cssForItemColor];
}

- (void)setPagerPosition:(NSInteger)pagerPosition{
    _pagerPosition = pagerPosition;
    if (self.delegate) {
        [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:self.pagerWrapperID];
    }
}

- (void)cssForItemColor{
    if (self.delegate) {
        [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:self.pagerID];
        [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:[self.pagerID cssHoverClass]];
        [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:[self.pagerID cssActiveClass]];
    }
}

#pragma mark - arrow
- (void)setDisableArrowControl:(BOOL)disableArrowControl{
    _disableArrowControl = disableArrowControl;
    [self updateHTML];
    [self updateCSSForEditViewPort];
}

- (void)setLeftArrowImage:(NSString *)leftArrowImage{
    _leftArrowImage = leftArrowImage;
    [self cssForArrowImage:IUCarouselArrowLeft];
}

- (void)setRightArrowImage:(NSString *)rightArrowImage{
    _rightArrowImage = rightArrowImage;
    [self cssForArrowImage:IUCarouselArrowRight];

}

- (void)setLeftX:(int)leftX{
    _leftX = leftX;
    [self cssForArrowImage:IUCarouselArrowLeft];
}
- (void)setLeftY:(int)leftY{
    _leftY = leftY;
    [self cssForArrowImage:IUCarouselArrowLeft];
}

- (void)setRightX:(int)rightX{
    _rightX = rightX;
    [self cssForArrowImage:IUCarouselArrowRight];
}
- (void)setRightY:(int)rightY{
    _rightY = rightY;
    [self cssForArrowImage:IUCarouselArrowRight];
}

- (void)cssForArrowImage:(IUCarouselArrow)type{
    NSString *arrowID;
    if(type == IUCarouselArrowLeft){
        arrowID = self.prevID;
    }
    else if(type == IUCarouselArrowRight){
        arrowID = self.nextID;
    }
    
    if (self.delegate) {
        [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:arrowID];
        
    }
}

@end