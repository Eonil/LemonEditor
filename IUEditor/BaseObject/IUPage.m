//
//  IUPage.m
//  IUEditor
//
//  Created by jd on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPage.h"
#import "IUBackground.h"
#import "IUPageContent.h"

@implementation IUPage{
    IUPageContent *_pageContent;
    __weak IUBackground *_background;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_pageContent forKey:@"pageContent"];
    [aCoder encodeObject:_background forKey:@"background"];
    [aCoder encodeFromObject:self withProperties:[IUPage properties]];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self.undoManager disableUndoRegistration];
        
        [aDecoder decodeToObject:self withProperties:[IUPage properties]];
        _pageContent = [aDecoder decodeObjectForKey:@"pageContent"];
        _background = [aDecoder decodeObjectForKey:@"background"];
        [_pageContent bind:@"delegate" toObject:self withKeyPath:@"delegate" options:nil];
        
        [self.undoManager enableUndoRegistration];
    }
    return self;
}


- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.undoManager disableUndoRegistration];
        
        [self.css setValue:[NSColor whiteColor] forTag:IUCSSTagBGColor forViewport:IUCSSDefaultViewPort];
        
        [self.css eradicateTag:IUCSSTagPixelX];
        [self.css eradicateTag:IUCSSTagPixelY];
        [self.css eradicateTag:IUCSSTagPixelWidth];
        [self.css eradicateTag:IUCSSTagPixelHeight];

        [self.css eradicateTag:IUCSSTagPercentX];
        [self.css eradicateTag:IUCSSTagPercentY];
        [self.css eradicateTag:IUCSSTagPercentWidth];
        [self.css eradicateTag:IUCSSTagPercentHeight];

        
        [self.undoManager enableUndoRegistration];
        self.positionType = IUPositionTypeRelative;
    }
    return self;
}

- (BOOL)hasHeight{
    return NO;
}

- (BOOL)hasWidth{
    return NO;
}

- (BOOL)hasY{
    return NO;
}

- (BOOL)hasX{
    return NO;
}

- (NSMutableArray *)allIdentifierChildren{
    NSMutableArray *array =  [self allChildren];
    [array removeObject:_background];
    [array removeObjectsInArray:[_background allChildren]];
    return array;
}


-(IUBackground*)background{
    return _background;
}

-(IUPageContent *)pageContent{
    return _pageContent;
}

-(void)setBackground:(IUBackground *)background{
    NSAssert(background.children, @"no children");
    NSAssert(background, @"no background"); // background can't be nil
    IUBackground *myBackground = self.background;
    
    if (myBackground == background) {
        return;
    }
    if (myBackground == nil && background ) {
        _background = background;
        NSArray *children = [self.children copy];
        _pageContent = [[IUPageContent alloc] initWithProject:self.project options:nil];
        _pageContent.htmlID = @"pageContent";
        _pageContent.name = @"pageContent";
        _pageContent.parent = self;
        
        for (IUBox *iu in children) {
            if (iu == (IUBox*)myBackground) {
                continue;
            }
            IUBox *temp = iu;
            [self removeIU:temp];
            [_pageContent addIU:temp error:nil];
        }
    }
    else if (myBackground && background == nil){
        NSArray *children = _pageContent.children;
        for (IUBox *iu in children) {
            [_pageContent removeIU:iu];
        }
    }
    else {
//        [self insertIU:background atIndex:0 error:nil];
    }
    _background = background;
//    _background.parent = self;
    _background.delegate = self.delegate;
    _pageContent.delegate = self.delegate;
    

}

- (void)setDelegate:(id<IUSourceDelegate>)delegate{
    [super setDelegate:delegate];
    if(_background){
        _background.delegate = delegate;
    }
    if(_pageContent){
        _pageContent.delegate = delegate;
    }
}

- (NSArray*)children{
    if (_pageContent && _background) {
        return @[_pageContent, _background];
    }
    else {
        return nil;
    }
}

#pragma mark - property

- (void)setTitle:(NSString *)title{
    if([_title isEqualToString:title]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setTitle:_title];
    _title = title;
}

- (void)setKeywords:(NSString *)keywords{
    if([_keywords isEqualToString:keywords]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setKeywords:_keywords];
    _keywords = keywords;
}

- (void)setDesc:(NSString *)desc{
    if([_desc isEqualToString:desc]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setDesc:_desc];
    _desc = desc;
}

- (void)setMetaImage:(NSString *)metaImage{
    if([_metaImage isEqualToString:metaImage]){
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setMetaImage:_metaImage];
    _metaImage = metaImage;
}


#pragma mark - shouldXXX, canXXX

- (BOOL)canCopy{
    return NO;
}


-(BOOL)shouldRemoveIUByUserInput{
    return NO;
}

-(BOOL)shouldAddIUByUserInput{
    return NO;
}


- (BOOL)floatRightChangeable{
    return NO;
}

- (BOOL)canChangePositionType{
    return NO;
}

- (BOOL)canChangeOverflow{
    return NO;
}



@end