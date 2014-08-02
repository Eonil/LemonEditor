//
//  IUBox.m
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUIdentifierManager.h"

#import "IUBox.h"
#import "NSObject+JDExtension.h"
#import "NSCoder+JDExtension.h"
#import "IUCompiler.h"
#import "IUSheet.h"
#import "IUBox.h"
#import "IUClass.h"
#import "IUProject.h"
#import "IUItem.h"
#import "IUImport.h"

@interface IUBox()
@end

@implementation IUBox{
    NSMutableSet *changedCSSWidths;
    NSPoint originalPoint, originalPercentPoint;
    NSSize originalSize, originalPercentSize;
    __weak IUProject *_tempProject;
    BOOL    _isConnectedWithEditor;
}


/* Note
 IUText is not programmed.
 */
#pragma mark - initialize


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [[self undoManager] disableUndoRegistration];

        [aDecoder decodeToObject:self withProperties:[[IUBox class] propertiesWithOutProperties:@[@"delegate", @"textType"]]];
        
        //VERSION COMPABILITY: texttype decode int issue
        @try {
            _textType = [aDecoder decodeInt32ForKey:@"textType"] ;
        }
        @catch (NSException *exception) {
            _textType = IUTextTypeDefault;
        }
        _css = [aDecoder decodeObjectForKey:@"css"];
        _css.delegate = self;
        _event = [aDecoder decodeObjectForKey:@"event"];
        _m_children=[aDecoder decodeObjectForKey:@"children"];
        changedCSSWidths = [NSMutableSet set];
        if ([self.htmlID length] == 0) {
            self.htmlID = [NSString randomStringWithLength:8];
        }
        NSAssert([self.htmlID length] != 0 , @"");
        
        [[self undoManager] enableUndoRegistration];

        
        /* version control code */
        IUEditorVersion = [aDecoder decodeIntForKey:@"IUEditorVersion"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if ([self.htmlID length] == 0) {
#ifdef DEBUG
        NSAssert(0, @"");
#endif 
        self.htmlID = [NSString randomStringWithLength:8];
    }
    [aCoder encodeFromObject:self withProperties:[[IUBox class] propertiesWithOutProperties:@[@"identifierManager", @"textController"]]];
    [aCoder encodeObject:self.css forKey:@"css"];
    [aCoder encodeObject:self.event forKey:@"event"];
    [aCoder encodeObject:_m_children forKey:@"children"];
    
    [aCoder encodeInt:1 forKey:@"IUEditorVersion"];
}

-(id)init{
    //only called from copyWithZone
    self = [super init];
    if (self) {
        _css = [[IUCSS alloc] init];
        _css.delegate = self;
        _event = [[IUEvent alloc] init];
        _m_children = [NSMutableArray array];
        
        changedCSSWidths = [NSMutableSet set];
        IUEditorVersion = 1;
    }
    return self;
}



-(id)initWithProject:(IUProject*)project options:(NSDictionary*)options{
    self = [super init];
    if(self){
        
        [[self undoManager] disableUndoRegistration];
        
        _tempProject = project;
        _css = [[IUCSS alloc] init];
        _css.delegate = self;
        _event = [[IUEvent alloc] init];
        _m_children = [NSMutableArray array];
        
        _overflowType = IUOverflowTypeHidden;
        
        [_css setValue:@(0) forTag:IUCSSTagXUnit forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagYUnit forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagWidthUnit forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagHeightUnit forWidth:IUCSSMaxViewPortWidth];
        
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
        _lineHeightAuto = YES;
#endif
        
        
        if (self.hasWidth) {
            [_css setValue:@(100) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        }
        if (self.hasHeight) {
            [_css setValue:@(60) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        }
        
        //background
        [_css setValue:[NSColor randomColor] forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(IUBGSizeTypeAuto) forTag:IUCSSTagBGSize forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagBGXPosition forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagBGYPosition forWidth:IUCSSMaxViewPortWidth];
        
        //border
        [_css setValue:@(0) forTag:IUCSSTagBorderTopWidth forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagBorderLeftWidth forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagBorderRightWidth forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagBorderBottomWidth forWidth:IUCSSMaxViewPortWidth];
        
        [_css setValue:[NSColor rgbColorRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderTopColor forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:[NSColor rgbColorRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderLeftColor forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:[NSColor rgbColorRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderRightColor forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:[NSColor rgbColorRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderBottomColor forWidth:IUCSSMaxViewPortWidth];
        
        //font-type
        [_css setValue:@"Auto" forTag:IUCSSTagLineHeight forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(12) forTag:IUCSSTagFontSize forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@"Helvetica" forTag:IUCSSTagFontName forWidth:IUCSSMaxViewPortWidth];
        
        changedCSSWidths = [NSMutableSet set];
        
        [project.identifierManager setNewIdentifierAndRegisterToTemp:self withKey:nil];
        self.name = self.htmlID;
        [[self undoManager] enableUndoRegistration];
        
        // version control
        IUEditorVersion = 1;
    }
    
    return self;
}


- (void)connectWithEditor{
    NSAssert(self.project, @"");
    
    [[self undoManager] disableUndoRegistration];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMQSelect:) name:IUNotificationMQSelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMQSize:) name:IUNotificationMQAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMQSize:) name:IUNotificationMQRemoved object:nil];
    for (IUBox *box in self.children) {
        [box connectWithEditor];
    }
    
    [[self undoManager] enableUndoRegistration];

}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - copy

- (id)copyWithZone:(NSZone *)zone{
    
    [[self undoManager] disableUndoRegistration];

    IUBox *box = [[[self class] allocWithZone: zone] init];
    if(box){
        IUCSS *newCSS = [_css copy];
        IUEvent *newEvent = [_event copy];
        NSArray *children = [self.children deepCopy];
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
        box.text = [_text copy];
        box.lineHeightAuto  = _lineHeightAuto;
#endif
        
        box.overflowType = _overflowType;
        box.positionType = _positionType;
        box.css = newCSS;
        newCSS.delegate  = box;
        box.event = newEvent;
        
        box.delegate = self.delegate;
        [box setTempProject:self.project];
        
        for (IUBox *iu in children) {
            BOOL result = [box addIU:iu error:nil];
            NSAssert(result == YES, @"copy");
        }
        
        NSAssert(self.project, @"project");
        [self.project.identifierManager resetUnconfirmedIUs];
        [self.project.identifierManager setNewIdentifierAndRegisterToTemp:box withKey:@"copy"];
        box.name = box.htmlID;
        [box.project.identifierManager confirm];
        
        [box connectWithEditor];
        [box setIsConnectedWithEditor];
        
        [[self undoManager] enableUndoRegistration];
    }


    return box;
}

- (BOOL)canCopy{
    return YES;
}
#pragma mark - Undo Manager
- (NSUndoManager *)undoManager{
   return [[[[NSApp mainWindow] windowController] document] undoManager];
}

#pragma mark - setXXX

-(void)setDelegate:(id<IUSourceDelegate>)delegate{
    _delegate = delegate;
    for (IUBox *obj in _m_children) {
        obj.delegate = delegate;
    }
}

-(IUSheet*)sheet{
    if ([self isKindOfClass:[IUSheet class]]) {
        return (IUSheet*)self;
    }
    if (self.parent) {
        return self.parent.sheet;
    }
    return nil;
}

- (IUProject *)project{
    if (self.sheet.group.project) {
        return self.sheet.group.project;
    }
    else if (_tempProject) {
        //not assigned to document
        return _tempProject;
    }
    NSAssert(0, @"project");
    return nil;
}

-(NSString*)description{
    return [[super description] stringByAppendingFormat:@" %@", self.htmlID];
}

- (void)setTempProject:(IUProject*)project{
    _tempProject = project;
}

- (void)setCss:(IUCSS *)css{
    _css = css;
}

#pragma <#arguments#>

- (void)setEvent:(IUEvent *)event{
    _event = event;
}

- (void)setOpacityMove:(float)opacityMove{
    if(_opacityMove != opacityMove){
        [[self.undoManager prepareWithInvocationTarget:self] setOpacityMove:_opacityMove];
        _opacityMove = opacityMove;
    }
}

- (void)setXPosMove:(float)xPosMove{
    if(_xPosMove != xPosMove){
        [[self.undoManager prepareWithInvocationTarget:self] setXPosMove:_xPosMove];
        _xPosMove = xPosMove;
    }
}

#pragma mark - setXXX : can Undo

- (void)setName:(NSString *)name{
    
    //ignore same name
    if([_name isEqualToString:name]){
        return;
    }
    //loading - not called rename notification
    if (_name == nil) {
        _name = [name copy];
    }
    //rename precedure
    else {
        _name = [name copy];
        if (self.isConnectedWithEditor) {
            [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationStructureDidChange object:self.project userInfo:
             @{IUNotificationStructureChangeType: IUNotificationStructureChangeTypeRenaming,
               IUNotificationStructureChangedIU: self}];
        }
    }
}
-(void)setLink:(id)link{
    if([link isEqualTo:_link] == NO){
        [[self.undoManager prepareWithInvocationTarget:self] setLink:_link];
    }
    _link = link;
}

-(void)setDivLink:(id)divLink{
    if([divLink isEqualTo:_divLink]== NO){
        [[self.undoManager prepareWithInvocationTarget:self] setDivLink:_divLink];
    }
    _divLink = divLink;
}

- (void)setImageName:(NSString *)imageName{
 
    NSString *currentImage = _css.assembledTagDictionary[IUCSSTagImage];
    if([currentImage isEqualToString:imageName] == NO){
        [[[self undoManager] prepareWithInvocationTarget:self] setImageName:_css.assembledTagDictionary[IUCSSTagImage]];
    }
    
    [self willChangeValueForKey:@"imageName"];


    NSDictionary *defaultTagDictionary = [_css tagDictionaryForWidth:IUCSSMaxViewPortWidth];
    if (defaultTagDictionary) {
        [_css setValue:imageName forTag:IUCSSTagImage forWidth:_css.editWidth];
    }
    [_css setValue:imageName forTag:IUCSSTagImage forWidth:IUCSSMaxViewPortWidth];
    
     [self didChangeValueForKey:@"imageName"];
}
- (NSString *)imageName{
    return _css.assembledTagDictionary[IUCSSTagImage];
}



- (void)setPgContentVariable:(NSString *)pgContentVariable{
    if([pgContentVariable isEqualToString:_pgContentVariable]){
        return;
    }
    [[[self undoManager] prepareWithInvocationTarget:self] setPgContentVariable:_pgContentVariable];

    _pgContentVariable = pgContentVariable;
}

- (void)setPgVisibleConditionVariable:(NSString *)pgVisibleConditionVariable{
    if([pgVisibleConditionVariable isEqualToString:_pgVisibleConditionVariable]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setPgVisibleConditionVariable:_pgVisibleConditionVariable];
    
    _pgVisibleConditionVariable = pgVisibleConditionVariable;
}



//iucontroller & inspectorVC sync가 안맞는듯.
- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

- (void)confirmIdentifier{
    [self.project.identifierManager confirm];
}


#pragma mark - mq

- (void)addMQSize:(NSNotification *)notification{
    NSInteger size = [[notification.userInfo objectForKey:IUNotificationMQSize] integerValue];
    NSInteger oldMaxSize = [[notification.userInfo valueForKey:IUNotificationMQOldMaxSize] integerValue];
    NSInteger maxSize = [[notification.userInfo valueForKey:IUNotificationMQMaxSize] integerValue];

    if(size == maxSize){
        [_css copyMaxSizeToSize:oldMaxSize];
    }
    
}

- (void)removeMQSize:(NSNotification *)notification{
    NSInteger size = [[notification.userInfo objectForKey:IUNotificationMQSize] integerValue];
    [_css removeTagDictionaryForWidth:size];

}


- (void)changeMQSelect:(NSNotification *)notification{
    NSInteger selectedSize = [[notification.userInfo valueForKey:IUNotificationMQSize] integerValue];
    NSInteger maxSize = [[notification.userInfo valueForKey:IUNotificationMQMaxSize] integerValue];

    if (selectedSize == maxSize) {
        [_css setEditWidth:IUCSSMaxViewPortWidth];
    }
    else {
        [_css setEditWidth:selectedSize];
    }
    
}



#pragma mark JS

- (void)updateJS{
    if(self.delegate){
        [self.delegate runCSSJS];
    }
}

//source
#pragma mark HTML

-(NSString*)html{
    return [self.project.compiler editorHTML:self].string;
}


- (void)updateHTML{
    if (self.delegate) {
        [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.parent.htmlID];

    }
}


#pragma mark - css

-(NSString*)cssForWidth:(NSInteger)width withIdentifier:(NSString *)identifer{

    NSDictionary *dict = [self.project.compiler CSSContentWithIdentifier:identifer ofIU:self width:width isEdit:YES];
    NSString *code = [self.project.compiler CSSCodeFromDictionary:dict];

    return code;
}

//delegate from IUCSS
-(void)CSSUpdatedForWidth:(NSInteger)width withIdentifier:(NSString *)identifer{
    if(self.delegate){
        NSString *css = [self cssForWidth:width withIdentifier:identifer];
        [self.delegate IUClassIdentifier:identifer CSSUpdated:css forWidth:width];
    }
}
/**
 @brief use cssIdentifierArray when remove IU, All CSS Identifiers should be in it.
 
 */
- (NSArray *)cssIdentifierArray{
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[[self.htmlID cssClass], [[self.htmlID cssClass] cssHoverClass]]];
    
    if(_pgContentVariable){
        [array addObject:[[self.htmlID cssClass] stringByAppendingString:@">p"]];
    }
    
    return array;
}

- (void)updateCSSForMaxViewPort{
    if (self.delegate) {
        for(NSString *cssIdentifier in [self cssIdentifierArray]){
            [self CSSUpdatedForWidth:IUCSSMaxViewPortWidth withIdentifier:cssIdentifier];
            
        }
    }
}

- (void)updateCSSForViewPortWidth:(NSInteger)width{
    if (self.delegate) {
        for(NSString *cssIdentifier in [self cssIdentifierArray]){
            [self CSSUpdatedForWidth:width withIdentifier:cssIdentifier];
        }
    }
}

- (void)updateCSSForEditViewPort{
    [self updateCSSForViewPortWidth:_css.editWidth];
}

//delegation
-(BOOL)CSSShouldChangeValue:(id)value forTag:(IUCSSTag)tag forWidth:(NSInteger)width{
    return YES;
}

#pragma mark - manage IU


#pragma mark children

- (NSMutableArray *)allIdentifierChildren{
    return [self allChildren];
}


-(NSMutableArray*)allChildren{
    if (self.children) {
        NSMutableArray *array = [NSMutableArray array];
        for (IUBox *iu in self.children) {
            [array addObject:iu];
            [array addObjectsFromArray:iu.allChildren];
        }
        return array;
    }
    return nil;
}

-(NSArray*)children{
    return [_m_children copy];
}

#pragma mark should

-(BOOL)shouldAddIUByUserInput{
    return YES;
}
- (BOOL)shouldRemoveIU{
    return YES;
}
- (BOOL)shouldRemoveIUByUserInput{
    return YES;
}

#pragma mark add
-(BOOL)addIU:(IUBox *)iu error:(NSError**)error{
    NSInteger index = [_m_children count];
    return [self insertIU:iu atIndex:index error:error];
}

-(BOOL)isConnectedWithEditor{
    return _isConnectedWithEditor;
}

-(void)setIsConnectedWithEditor{
    _isConnectedWithEditor = YES;
    for (IUBox *iu in self.children) {
        [iu setIsConnectedWithEditor];
    }
}

-(BOOL)insertIU:(IUBox *)iu atIndex:(NSInteger)index  error:(NSError**)error{
    if ([iu isKindOfClass:[IUImport class]] && [[self sheet] isKindOfClass:[IUImport class]]) {
        [JDUIUtil hudAlert:@"IUImport can't be inserted to IUImport" second:2];
        return NO;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] removeIU:iu];
    
    [_m_children insertObject:iu atIndex:index];
    
    //iu 의 delegate와 children
    if (iu.delegate == nil) {
        iu.delegate = self.delegate;
    }
    
    iu.parent = self;
    if (self.isConnectedWithEditor) {
        [iu connectWithEditor];
        [iu setIsConnectedWithEditor];
    }
    
    if ([self.sheet isKindOfClass:[IUClass class]]) {
        for (IUBox *import in [(IUClass*)self.sheet references]) {
            
            [import updateHTML];
            [import updateCSSForMaxViewPort];
            if(_css.editWidth != IUCSSMaxViewPortWidth){
                [import updateCSSForEditViewPort];
            }
            
            for (IUBox *child in iu.children) {
                [child updateCSSForMaxViewPort];
                if(_css.editWidth != IUCSSMaxViewPortWidth){
                    [child updateCSSForEditViewPort];
                }
            }
        }
    }
    

    [iu updateHTML];
    [iu updateCSSForMaxViewPort];
    if(_css.editWidth != IUCSSMaxViewPortWidth){
        [iu updateCSSForEditViewPort];
    }
    for (IUBox *child in iu.children) {
        [child updateCSSForMaxViewPort];
        if(_css.editWidth != IUCSSMaxViewPortWidth){
            [child updateCSSForEditViewPort];
        }
    }

    [self updateJS];
    [iu bind:@"identifierManager" toObject:self withKeyPath:@"identifierManager" options:nil];

    if (self.isConnectedWithEditor) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationStructureDidChange object:self.project userInfo:@{IUNotificationStructureChangeType: IUNotificationStructureAdding, IUNotificationStructureChangedIU: iu}];
    }

    return YES;
}

-(BOOL)addIUReference:(IUBox *)iu error:(NSError**)error{
    [_m_children addObject:iu];
    if (self.delegate) {
        iu.delegate = self.delegate;
    }
    return YES;
}


-(BOOL)removeIU:(IUBox *)iu{
    if([iu shouldRemoveIU]){
        
        NSInteger index = [_m_children indexOfObject:iu];
        [[self.undoManager prepareWithInvocationTarget:self] insertIU:iu atIndex:index error:nil];
        
        //IURemoved 호출한 다음에 m_children을 호출해야함.
        //border를 지울려면 controller 에 iu 정보 필요.
        //--undo [self.project.identifierManager unregisterIUs:@[iu]];
        [self.delegate IURemoved:iu.htmlID withParentID:iu.parent.htmlID];
        [_m_children removeObject:iu];
        
        if (self.isConnectedWithEditor) {
            [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationStructureDidChange object:self.project userInfo:@{IUNotificationStructureChangeType: IUNotificationStructureChangeRemoving, IUNotificationStructureChangedIU: iu}];
        }

        return YES;
    }
    return NO;
}

-(BOOL)changeIUIndex:(IUBox*)iu to:(NSUInteger)index error:(NSError**)error{
    NSInteger currentIndex = [_m_children indexOfObject:iu];

    [[self.undoManager prepareWithInvocationTarget:self] changeIUIndex:iu to:currentIndex error:nil];
    
    //자기보다 앞으로 갈 경우
    [_m_children removeObject:iu];
    if (index > currentIndex) {
        index --;
    }
    [_m_children insertObject:iu atIndex:index];
    
    [self updateHTML];
    [self updateJS];
    if (self.isConnectedWithEditor) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationStructureDidChange object:self.project userInfo:@{IUNotificationStructureChangeType: IUNotificationStructureChangeReindexing, IUNotificationStructureChangedIU: iu}];
    }
    
    return YES;
}

-(BOOL)removeIUAtIndex:(NSUInteger)index{
    
    IUBox *box = [_m_children objectAtIndex:index];
    return [self removeIU:box];
}



#pragma mark - Frame


#pragma mark has frame
- (BOOL)shouldCompileFontInfo{
    if (self.text || self.pgContentVariable) {
        return YES;
    }
    return NO;
}

-(BOOL)hasX{
    return YES;
}
-(BOOL)hasY{
    return YES;
}
-(BOOL)hasWidth{
    return YES;
}
-(BOOL)hasHeight{
    return YES;
}
- (BOOL)centerChangeable{
    return YES;
}

- (BOOL)canChangeXByUserInput{
    if (self.positionType == IUPositionTypeAbsoluteCenter || self.positionType == IUPositionTypeRelativeCenter) {
        return NO;
    }
    return YES;
}
- (BOOL)canChangeYByUserInput{
    return YES;
}
- (BOOL)canChangeWidthByUserInput{
    return YES;
}
- (BOOL)canChangeHeightByUserInput{
    return YES;
}

#pragma mark setFrame

- (void)setPosition:(NSPoint)position{
    [_css setValue:@(position.x) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagX]];
    [_css setValue:@(position.y) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagY]];
}

- (void)setPercentFrame:(NSRect)frame{
    CGFloat x = frame.origin.x;
    CGFloat xExist =[[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentX] floatValue];
    if (x != xExist) {
        [_css setValue:@(frame.origin.x) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentX]];
    }
    if (frame.origin.x != [[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentY] floatValue]) {
        [_css setValue:@(frame.origin.y) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentY]];
    }
    if (frame.origin.x != [[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentHeight] floatValue]) {
        [_css setValue:@(frame.size.height) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentHeight]];
    }
    if (frame.origin.x != [[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentWidth] floatValue]) {
        [_css setValue:@(frame.size.width) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentWidth]];
    }
}

- (void)setPixelFrame:(NSRect)frame{
    [_css setValue:@(frame.origin.x) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagX]];
    [_css setValue:@(frame.origin.y) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagY]];
    [_css setValue:@(frame.size.height) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagHeight]];
    [_css setValue:@(frame.size.width) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagWidth]];
    
}

-(BOOL)percentUnitAtCSSTag:(IUCSSTag)tag{
    BOOL unit = [[_css valueForKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:tag]] boolValue];
    return unit;
}

#pragma mark move by drag & drop




/*
 drag 중간의 diff size로 하면 css에 의한 오차가 생김.
 drag session이 시작될때부터 위치에서의 diff size로 계산해야 오차가 발생 안함.
 drag session이 시작할때 그 때의 위치를 저장함.
 */

- (NSPoint)currentPosition{
    NSInteger currentX = [_css.assembledTagDictionary[IUCSSTagX] integerValue];
    NSInteger currentY = 0;
    if([_css.assembledTagDictionary objectForKey:IUCSSTagY]){
        currentY = [_css.assembledTagDictionary[IUCSSTagY] integerValue];
    }
    else if(self.positionType == IUPositionTypeRelative || self.positionType == IUPositionTypeFloatRight ||
            self.positionType == IUPositionTypeFloatLeft){
        NSPoint distancePoint = [self.delegate distanceFromIU:self.htmlID to:self.parent.htmlID];
        currentY = distancePoint.y;
    }
    return NSMakePoint(currentX, currentY);
}
- (NSPoint)currentPercentPosition{
    NSInteger currentX = 0;
    NSInteger currentY = 0;
    if([_css.assembledTagDictionary objectForKey:IUCSSTagPercentX]){
        currentX = [_css.assembledTagDictionary[IUCSSTagPercentX] integerValue];
    }
    if([_css.assembledTagDictionary objectForKey:IUCSSTagPercentY]){
        currentY = [_css.assembledTagDictionary[IUCSSTagPercentY] integerValue];
    }
    return NSMakePoint(currentX, currentY);
}
- (NSSize)currentSize{
    NSInteger currentWidth = [_css.assembledTagDictionary[IUCSSTagWidth] integerValue];
    NSInteger currentHeight = [_css.assembledTagDictionary[IUCSSTagHeight] integerValue];
    
    return NSMakeSize(currentWidth, currentHeight);
}

- (NSSize)currentPercentSize{
    NSInteger currentPWidth = [_css.assembledTagDictionary[IUCSSTagPercentWidth] floatValue];
    NSInteger currentPHeight = [_css.assembledTagDictionary[IUCSSTagPercentHeight] floatValue];
    
    return NSMakeSize(currentPWidth, currentPHeight);
}
- (void)startDragSession{
    originalSize = [self currentSize];
    originalPercentSize = [self currentPercentSize];
    originalPoint = [self currentPosition];
    originalPercentPoint = [self currentPercentPosition];
}

- (void)endDragSession{
    [[self undoManager] beginUndoGrouping];
    [[[self undoManager] prepareWithInvocationTarget:self] undoPoisition:originalPoint];
    [[[self undoManager] prepareWithInvocationTarget:self] undoPercentPosition:originalPercentPoint];
    [[[self undoManager] prepareWithInvocationTarget:self] undoSize:originalSize];
    [[[self undoManager] prepareWithInvocationTarget:self] undoPercentSize:originalPercentSize];
    [[self undoManager] endUndoGrouping];
}

- (void)undoPoisition:(NSPoint)point{
    
    [[[self undoManager] prepareWithInvocationTarget:self] undoPoisition:[self currentPosition]];
    
    if([self hasX] && [self canChangeXByUserInput]){
        [_css setValue:@(point.x) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagX]];
    }
    if([self hasY] && [self canChangeYByUserInput]){
        [_css setValue:@(point.y) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagY]];
    }
    [self updateCSSForEditViewPort];
}

- (void)undoPercentPosition:(NSPoint)point{
    
    [[[self undoManager] prepareWithInvocationTarget:self] undoPercentPosition:[self currentPercentPosition]];
    
    if([self hasX] && [self canChangeXByUserInput]){
        [_css setValue:@(point.x) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentX]];
    }
    if([self hasY] && [self canChangeYByUserInput]){
        [_css setValue:@(point.y) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentY]];
    }
    [self updateCSSForEditViewPort];
}
- (void)undoSize:(NSSize)size{
    [[[self undoManager] prepareWithInvocationTarget:self] undoSize:[self currentSize]];

    if([self hasWidth] && [self canChangeWidthByUserInput]){
        [_css setValue:@(size.width) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagWidth]];
    }
    if([self hasHeight] && [self canChangeHeightByUserInput]){
        [_css setValue:@(size.height) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagHeight]];
    }
    [self updateCSSForEditViewPort];

}
- (void)undoPercentSize:(NSSize)size{
    
    [[[self undoManager] prepareWithInvocationTarget:self] undoPercentSize:[self currentPercentSize]];

    
    if([self hasWidth] && [self canChangeWidthByUserInput]){
        [_css setValue:@(size.width) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentWidth]];
    }
    if([self hasHeight] && [self canChangeHeightByUserInput]){
        [_css setValue:@(size.height) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentHeight]];
    }
    [self updateCSSForEditViewPort];
    
}

- (void)movePosition:(NSPoint)point withParentSize:(NSSize)parentSize{
    
    //Set Pixel
    if([self hasX] && [self canChangeXByUserInput]){
        NSInteger currentX = originalPoint.x + point.x;
        
        [_css setValue:@(currentX) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagX]];
        //set Percent if enablePercent
        BOOL enablePercentX = [self percentUnitAtCSSTag:IUCSSTagXUnit];
        if(enablePercentX){
            CGFloat percentX = 0;
            if(parentSize.width!=0){
                percentX = (currentX / parentSize.width) * 100;
            }
            [_css setValue:@(percentX) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentX]];
            
        }
    }
    
    if([self hasY] && [self canChangeYByUserInput]){
        
        NSInteger currentY = originalPoint.y + point.y;
        [_css setValue:@(currentY) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagY]];
        
        
        BOOL enablePercentY = [self percentUnitAtCSSTag:IUCSSTagYUnit];
        if(enablePercentY){
            CGFloat percentY = 0;
            if(parentSize.height!=0){
                percentY = (currentY / parentSize.height) * 100;
            }
            [_css setValue:@(percentY) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentY]];
        }
    }
    
}

- (void)increaseSize:(NSSize)size withParentSize:(NSSize)parentSize{
    if([self hasWidth] && [self canChangeWidthByUserInput]){
        NSInteger currentWidth = originalSize.width;
        currentWidth += size.width;
        [_css setValue:@(currentWidth) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagWidth]];
        
        CGFloat percentWidth = originalPercentSize.width;
        if(parentSize.width!=0){
            percentWidth += (size.width / parentSize.width) *100;
        }
        [_css setValue:@(percentWidth) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentWidth]];
        
     
    }
    if([self hasHeight] && [self canChangeHeightByUserInput]){
        NSInteger currentHeight = originalSize.height;
        currentHeight += size.height;
        [_css setValue:@(currentHeight) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagHeight]];
        
        CGFloat percentHeight = originalPercentSize.height;
        if(parentSize.height!=0){
            percentHeight += (size.height / parentSize.height) *100;
        }
        [_css setValue:@(percentHeight) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentHeight]];
        
    }
}

#pragma mark - position

#pragma mark - shouldXXX
- (BOOL)canChangePositionType{
    return YES;
}

- (BOOL)canChangePositionAbsolute{
    return YES;
}

- (BOOL)canChangePositionRelative{
    return YES;
}

- (BOOL)canChangePositionFloatLeft{
    return YES;
}

- (BOOL)canChangePositionFloatRight{
    return YES;
}

- (BOOL)canChangePositionAbsoluteCenter{
    return YES;
}

- (BOOL)canChangePositionRelativeCenter{
    return YES;
}

- (BOOL)canChangeOverflow{
    return YES;
}

#pragma mark - setting position

- (void)setPositionType:(IUPositionType)positionType{
    BOOL isCurrentCenter = NO;
    BOOL isAfterCenter = NO;
    BOOL centerChanged = NO;
    
    if (_positionType == IUPositionTypeAbsoluteCenter || _positionType == IUPositionTypeRelativeCenter) {
        isCurrentCenter = YES;
    }
    
    if (positionType == IUPositionTypeAbsoluteCenter || positionType == IUPositionTypeRelativeCenter) {
        isAfterCenter = YES;
    }
    
    if ( (isCurrentCenter == NO && isAfterCenter == YES ) || (isCurrentCenter == YES && isAfterCenter == NO ) ) {
        centerChanged = YES;
    }
    if (centerChanged) {
        [self willChangeValueForKey:@"canChangeXByUserInput"];
    }
    
    _positionType = positionType;
    [self updateCSSForEditViewPort];
    [self updateHTML];
    [self updateJS];
    if (centerChanged) {
        [self didChangeValueForKey:@"canChangeXByUserInput"];
    }
}

- (void)setOverflowType:(IUOverflowType)overflowType{
    _overflowType = overflowType;
    [self updateCSSForEditViewPort];
    [self updateHTML];
}



#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
#pragma mark -text

- (void)setText:(NSString *)text{
    _text = text;
    [self updateHTML];
    [self updateJS];
}

- (void)setLineHeightAuto:(BOOL)lineHeightAuto{
    _lineHeightAuto = lineHeightAuto;
    [self updateHTML];
    [self updateJS];
}


#endif

@end
