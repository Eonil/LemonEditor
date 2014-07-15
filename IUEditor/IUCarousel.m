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
        _rightArrowImage = @"Default";
        _leftArrowImage = @"Default";
        initializing = NO;
    }
    return self;
}

- (void)connectWithEditor{
    [super connectWithEditor];
    [self addObserver:self forKeyPath:@"css.assembledTagDictionary.height" options:0 context:
     @"height"];
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUCarousel class] propertiesWithOutProperties:@[@"count"]]];
        if (self.delegate) {
            [self jsReloadForController];
        }
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUCarousel class] propertiesWithOutProperties:@[@"count"]]];
    
}

- (id)copyWithZone:(NSZone *)zone{
    IUCarousel *carousel = [super copyWithZone:zone];
    carousel.autoplay = _autoplay;
    carousel.enableColor = _enableColor;
    carousel.disableArrowControl = _disableArrowControl;
    carousel.controlType = _controlType;
    carousel.selectColor = [_selectColor copy];
    carousel.deselectColor = [_deselectColor copy];
    carousel.leftArrowImage = [_leftArrowImage copy];
    carousel.rightArrowImage = [_rightArrowImage copy];
    carousel.count = [self count];
    
    return carousel;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"css.assembledTagDictionary.height"];
}

-(void)setCount:(NSInteger)count{
    
    if (count == 0 || count > 30 || count == self.children.count ) {
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
//            item.carousel = self;
            [self addIU:item error:nil];
        }
        
        if (initializing == NO) {
            [self.project.identifierManager confirm];
        }
    }
    [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.parent.htmlID];
    [self jsReloadForController];
}

-(void)remakeChildrenHtmlID{
    for (IUItem *item in self.children) {
        if ([item isKindOfClass:[IUItem class]]) {
            [item setHtmlID:[NSString stringWithFormat:@"%@-Templorary%ld", self.name, [self.children indexOfObject:item]]];
        }
    }
    for (IUItem *item in self.children) {
        if ([item isKindOfClass:[IUItem class]]) {
            [item setHtmlID:[NSString stringWithFormat:@"%@-%ld", self.name, [self.children indexOfObject:item]]];
        }
    }
}

#pragma mark Inner CSS (Carousel)

- (NSArray *)cssIdentifierArray{
    NSString *pagerItemID = [NSString stringWithFormat:@"%@pager-item", self.htmlID];
    NSString *leftArrowID = [NSString stringWithFormat:@".%@ .bx-wrapper .bx-controls-direction .bx-prev", self.htmlID];
    NSString *rightArrowID = [NSString stringWithFormat:@".%@ .bx-wrapper .bx-controls-direction .bx-next", self.htmlID];

    NSMutableArray *cssArray = [[super cssIdentifierArray] mutableCopy];
    [cssArray addObjectsFromArray:@[[pagerItemID cssClass], [pagerItemID cssHoverClass], [pagerItemID cssActiveClass], leftArrowID, rightArrowID]];
    return cssArray;
}

- (void)setSelectColor:(NSColor *)selectColor{
    _selectColor = selectColor;
    [self cssForItemColor];
}
- (void)setDeselectColor:(NSColor *)deselectColor{
    _deselectColor = deselectColor;
    [self cssForItemColor];
}

- (void)setEnableColor:(BOOL)enableColor{
    _enableColor = enableColor;
    [self cssForItemColor];
}

- (void)cssForItemColor{
    NSString *itemID = [NSString stringWithFormat:@"%@pager-item", self.htmlID];
    
    if (self.delegate) {
        if(self.enableColor){
            
            if (self.delegate) {
                [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:[itemID cssClass]];
                [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:[itemID cssHoverClass]];
                [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:[itemID cssActiveClass]];

            }

        }
        else{
            [self.delegate IUClassIdentifier:[itemID cssClass] CSSRemovedforWidth:IUCSSMaxViewPortWidth];
            [self.delegate IUClassIdentifier:[itemID cssHoverClass] CSSRemovedforWidth:IUCSSMaxViewPortWidth];
            [self.delegate IUClassIdentifier:[itemID cssActiveClass] CSSRemovedforWidth:IUCSSMaxViewPortWidth];
        }
    }
    
}

- (void)heightContextDidChange:(NSDictionary *)change{
    //redraw arrowimage because of position
    if(_leftArrowImage){
        [self setLeftArrowImage:_leftArrowImage];
    }
    if(_rightArrowImage){
        [self setRightArrowImage:_rightArrowImage];
    }
}

- (void)setLeftArrowImage:(NSString *)leftArrowImage{
    _leftArrowImage = leftArrowImage;
    BOOL change = NO;
    
    if([leftArrowImage isEqualToString:@"Default"] == NO){
        change = YES;
    }
    [self cssForArrowImage:IUCarouselArrowLeft change:change];
}

- (void)setRightArrowImage:(NSString *)rightArrowImage{
    _rightArrowImage = rightArrowImage;
    BOOL change = NO;
    if([rightArrowImage isEqualToString:@"Default"] == NO){
        change = YES;
    }
    [self cssForArrowImage:IUCarouselArrowRight change:change];

}

- (void)cssForArrowImage:(IUCarouselArrow)type change:(BOOL)change{
    NSString *arrowID;
    NSString *leftArrowID = [NSString stringWithFormat:@".%@ .bx-wrapper .bx-controls-direction .bx-prev", self.htmlID];
    NSString *rightArrowID = [NSString stringWithFormat:@".%@ .bx-wrapper .bx-controls-direction .bx-next", self.htmlID];

    if(type == IUCarouselArrowLeft){
        arrowID = leftArrowID;
    }
    else if(type == IUCarouselArrowRight){
        arrowID = rightArrowID;
    }
    if (self.delegate) {
        [self CSSUpdatedForWidth:self.css.editWidth withIdentifier:arrowID];
        
    }
}

#pragma mark JS reload
- (void)setAutoplay:(BOOL)autoplay{
    _autoplay = autoplay;
    if (self.delegate) {
        [self jsReloadForController];
    }
}
- (void)setDisableArrowControl:(BOOL)disableArrowControl{
    _disableArrowControl = disableArrowControl;
    if (self.delegate) {
        [self jsReloadForController];
    }
}
- (void)setControlType:(IUCarouselControlType)controlType{
    _controlType = controlType;
    if (self.delegate) {
        [self jsReloadForController];
    }
}

- (NSString *)carouselAttributes{
    NSString *jsArgs = [self.project.compiler outputJSArgs:self];
    return jsArgs;
}

- (NSInteger)count{
    return [self.children count];
}

- (void)jsReloadForController{
    NSString *jsArgs = [self carouselAttributes];
    if(jsArgs){
        NSString *innerJSArgs = [jsArgs stringByReplacingOccurrencesOfString:@"auto:true" withString:@"auto:false"];
        [self.delegate callWebScriptMethod:@"reloadCarousels" withArguments:@[self.htmlID, innerJSArgs]];
    }
}
@end