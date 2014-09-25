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
#import "IUCSSCompiler.h"

#import "IUSheet.h"
#import "IUBox.h"
#import "IUClass.h"
#import "IUProject.h"
#import "IUItem.h"
#import "IUImport.h"
#import "IUPage.h"

@interface IUBox()
@end

@implementation IUBox{
    NSMutableSet *changedCSSWidths;
    
    //for undo
    NSMutableDictionary *undoFrameDict;
    
    //for draggin precisely
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

        [aDecoder decodeToObject:self withProperties:[[IUBox class] propertiesWithOutProperties:@[@"delegate", @"textType", @"linkCaller"]]];
        
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
        changedCSSWidths = [NSMutableSet set];
        if ([self.htmlID length] == 0) {
            self.htmlID = [NSString randomStringWithLength:8];
        }
        NSAssert([self.htmlID length] != 0 , @"");
        
        [[self undoManager] enableUndoRegistration];


    }
    return self;
}
/**
 Review: _m_children의 decode는 순서가 꼬이기 때문에 initWithCoder가 아닌 awkaAfterUsingCoder로 하도록한다.
 (self가 다 할당되기전에 children이 먼저 할당 되면서 발생하는 문제 제거)
 */
- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder{
    [super awakeAfterUsingCoder:aDecoder];
    [self.undoManager disableUndoRegistration];
    
    _m_children = [aDecoder decodeObjectForKey:@"children"];
    
    
    //version Control
    if(self.project){
        if(IU_VERSION_V1_GREATER_THAN_V2(IU_VERSION_LAYOUT, self.project.IUProjectVersion)){
            _enableHCenter = [aDecoder decodeInt32ForKey:@"enableCenter"];
        }
    }
    [self.undoManager enableUndoRegistration];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if ([self.htmlID length] == 0) {
#ifdef DEBUG
        NSAssert(0, @"");
#endif 
        self.htmlID = [NSString randomStringWithLength:8];
    }
    [aCoder encodeFromObject:self withProperties:[[IUBox class] propertiesWithOutProperties:@[@"identifierManager", @"textController", @"linkCaller"]]];
    [aCoder encodeObject:self.css forKey:@"css"];
    [aCoder encodeObject:self.event forKey:@"event"];
    [aCoder encodeObject:_m_children forKey:@"children"];
    
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
        _lineHeightAuto = YES;
        
        _overflowType = IUOverflowTypeHidden;
        
        [_css setValue:@(0) forTag:IUCSSTagXUnitIsPercent forViewport:IUCSSDefaultViewPort];
        [_css setValue:@(0) forTag:IUCSSTagYUnitIsPercent forViewport:IUCSSDefaultViewPort];
        [_css setValue:@(0) forTag:IUCSSTagWidthUnitIsPercent forViewport:IUCSSDefaultViewPort];
        [_css setValue:@(0) forTag:IUCSSTagHeightUnitIsPercent forViewport:IUCSSDefaultViewPort];
        
        if (self.hasWidth) {
            [_css setValue:@(100) forTag:IUCSSTagPixelWidth forViewport:IUCSSDefaultViewPort];
        }
        if (self.hasHeight) {
            [_css setValue:@(60) forTag:IUCSSTagPixelHeight forViewport:IUCSSDefaultViewPort];
        }
        
        //background
        [_css setValue:[NSColor randomLightMonoColor] forTag:IUCSSTagBGColor forViewport:IUCSSDefaultViewPort];
        [_css setValue:@(IUBGSizeTypeAuto) forTag:IUCSSTagBGSize forViewport:IUCSSDefaultViewPort];
        [_css setValue:@(0) forTag:IUCSSTagBGXPosition forViewport:IUCSSDefaultViewPort];
        [_css setValue:@(0) forTag:IUCSSTagBGYPosition forViewport:IUCSSDefaultViewPort];
        
        //border
        [_css setValue:@(0) forTag:IUCSSTagBorderTopWidth forViewport:IUCSSDefaultViewPort];
        [_css setValue:@(0) forTag:IUCSSTagBorderLeftWidth forViewport:IUCSSDefaultViewPort];
        [_css setValue:@(0) forTag:IUCSSTagBorderRightWidth forViewport:IUCSSDefaultViewPort];
        [_css setValue:@(0) forTag:IUCSSTagBorderBottomWidth forViewport:IUCSSDefaultViewPort];
        
        [_css setValue:[NSColor rgbColorRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderTopColor forViewport:IUCSSDefaultViewPort];
        [_css setValue:[NSColor rgbColorRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderLeftColor forViewport:IUCSSDefaultViewPort];
        [_css setValue:[NSColor rgbColorRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderRightColor forViewport:IUCSSDefaultViewPort];
        [_css setValue:[NSColor rgbColorRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderBottomColor forViewport:IUCSSDefaultViewPort];
        
        //font-type
        [_css setValue:@(1.0) forTag:IUCSSTagLineHeight forViewport:IUCSSDefaultViewPort];
        [_css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign forViewport:IUCSSDefaultViewPort];
        
        changedCSSWidths = [NSMutableSet set];
        
        if (options[IUFileName]) {
            [project.identifierManager setIdentifierAndRegisterToTemp:self identifier:options[IUFileName]];
        }
        else {
            [project.identifierManager setNewIdentifierAndRegisterToTemp:self withKey:nil];
        }
        self.name = self.htmlID;
        [[self undoManager] enableUndoRegistration];
        
    }
    
    return self;
}



- (void)connectWithEditor{
    NSAssert(self.project, @"");
    
    
    [[self undoManager] disableUndoRegistration];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMQSelect:) name:IUNotificationMQSelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMQSize:) name:IUNotificationMQAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMQSize:) name:IUNotificationMQRemoved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureChanged:) name:IUNotificationStructureDidChange object:self.project];
    
    
    for (IUBox *box in self.children) {
        [box connectWithEditor];
    }
    
    [[self undoManager] enableUndoRegistration];
    
}
- (void)disconnectWithEditor{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (IUBox *box in self.children) {
        [box disconnectWithEditor];
    }
    _isConnectedWithEditor = NO;
    
}

- (void)dealloc{
    if([self isConnectedWithEditor]){
        [self disconnectWithEditor];
    }
}
#pragma mark - default box 

/**
 
 Some convenience methods to create iubox
 */
+(IUBox *)copyrightBoxWithProject:(IUProject*)project{
    IUBox *copyright = [[IUBox alloc] initWithProject:project options:nil];
    [copyright.undoManager disableUndoRegistration];
    
    copyright.name = @"Copyright";
    copyright.text = @"Copyright (C) IUEditor all rights reserved";
    copyright.enableHCenter = YES;
    [copyright.css setValue:@(40) forTag:IUCSSTagPixelY forViewport:IUCSSDefaultViewPort];
    [copyright.css eradicateTag:IUCSSTagPixelWidth];
    [copyright.css eradicateTag:IUCSSTagPixelHeight];
    [copyright.css eradicateTag:IUCSSTagBGColor];
    
    [copyright.css setValue:@"Roboto" forTag:IUCSSTagFontName forViewport:IUCSSDefaultViewPort];
    [copyright.css setValue:@(12) forTag:IUCSSTagFontSize forViewport:IUCSSDefaultViewPort];
    [copyright.css setValue:@(1.5) forTag:IUCSSTagLineHeight forViewport:IUCSSDefaultViewPort];
    [copyright.css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign forViewport:IUCSSDefaultViewPort];
    [copyright.css setValue:[NSColor rgbColorRed:102 green:102 blue:102 alpha:1] forTag:IUCSSTagFontColor forViewport:IUCSSDefaultViewPort];
    
    
    [copyright.undoManager enableUndoRegistration];
    return copyright;
}


#pragma mark - copy

- (id)copyWithZone:(NSZone *)zone{
    
    [[self undoManager] disableUndoRegistration];
    [self.delegate disableUpdateAll:self];

    IUBox *box = [[[self class] allocWithZone: zone] init];
    if(box){
        
        IUCSS *newCSS = [_css copy];
        IUEvent *newEvent = [_event copy];
        NSArray *children = [self.children deepCopy];
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
        box.text = [_text copy];
#endif
        
        box.overflowType = _overflowType;
        box.positionType = _positionType;
        box.enableHCenter = _enableHCenter;
        box.enableVCenter = _enableVCenter;
        
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

    [self.delegate enableUpdateAll:self];
    return box;
}
- (void)copyCSSFromIU:(IUBox *)box{
    IUCSS *newCSS = [box.css copy];
    _css = newCSS;
    _css.delegate = self;
}

- (BOOL)canCopy{
    return YES;
}
- (BOOL)canSelectAtFirst{
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
    //FIXME: decoder할때 project가 없을때가 있음 확인요
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

#pragma mark - Event

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
        
        if(xPosMove !=0 && _enableHCenter==YES){
            self.enableHCenter = NO;
        }
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
    [self updateCSS];
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
        
        [self willChangeValueForKey:@"imageName"];
        [_css setValue:imageName forTag:IUCSSTagImage];
        [self didChangeValueForKey:@"imageName"];
    }
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


#pragma mark - noti
- (CalledByNoti)structureChanged:(NSNotification*)noti{
    NSDictionary *userInfo = noti.userInfo;
    
    if ([userInfo[IUNotificationStructureChangeType] isEqualToString:IUNotificationStructureChangeRemoving]
        && [userInfo[IUNotificationStructureChangedIU] isKindOfClass:[IUPage class]]) {
        if([self.link isEqualTo:userInfo[IUNotificationStructureChangedIU]]){
            //disable undoManager;
            _link = nil;
            _divLink = nil;
            [self updateCSS];
        }
    }
}

- (void)addMQSize:(NSNotification *)notification{
    NSInteger size = [[notification.userInfo objectForKey:IUNotificationMQSize] integerValue];
    NSInteger oldMaxSize = [[notification.userInfo valueForKey:IUNotificationMQOldMaxSize] integerValue];
    NSInteger maxSize = [[notification.userInfo valueForKey:IUNotificationMQMaxSize] integerValue];

    if(size == maxSize){
        [_css copyMaxSizeToSize:oldMaxSize];
    }
    [_css setMaxWidth:maxSize];
    
}

- (void)removeMQSize:(NSNotification *)notification{
    NSInteger size = [[notification.userInfo objectForKey:IUNotificationMQSize] integerValue];
    NSInteger maxSize = [[notification.userInfo valueForKey:IUNotificationMQMaxSize] integerValue];
    [_css removeTagDictionaryForViewport:size];
    [_css setMaxWidth:maxSize];

}


- (void)changeMQSelect:(NSNotification *)notification{
    
    [self willChangeValueForKey:@"canChangeHCenter"];

    NSInteger selectedSize = [[notification.userInfo valueForKey:IUNotificationMQSize] integerValue];
    NSInteger maxSize = [[notification.userInfo valueForKey:IUNotificationMQMaxSize] integerValue];

    if (selectedSize == maxSize) {
        [_css setEditWidth:IUCSSDefaultViewPort];
    }
    else {
        [_css setEditWidth:selectedSize];
    }
    [_css setMaxWidth:maxSize];
    
    [self didChangeValueForKey:@"canChangeHCenter"];
        
    
}

//source
#pragma mark HTML


- (void)updateHTML{
    if (self.delegate && [self.delegate isUpdateHTMLEnabled]) {
        
        [self.delegate disableUpdateJS:self];
        NSString *editorHTML = [self.project.compiler htmlCode:self target:IUTargetEditor].string;
        
        [self.delegate IUHTMLIdentifier:self.htmlID HTML:editorHTML withParentID:self.parent.htmlID];

        if([self.sheet isKindOfClass:[IUClass class]]){
            for(IUBox *box in ((IUClass *)self.sheet).references){
                [box updateHTML];
            }
        }
        
        for(IUBox *box in self.allChildren){
            [box updateCSS];
        }
        
        [self.delegate enableUpdateJS:self];
        [self updateCSS];
        
    }
    
}


#pragma mark - css

/**
 @brief use cssIdentifierArray when remove IU, All CSS Identifiers should be in it.
 
 */
- (NSArray *)cssIdentifierArray{
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[[self cssIdentifier], [self cssHoverClass]]];
    
    if(_pgContentVariable){
        [array addObject:[[self cssIdentifier] stringByAppendingString:@">p"]];
    }
    
    return array;
}


- (void)updateCSS{
    if (self.delegate) {
        
        if(_lineHeightAuto && self.shouldCompileFontInfo){
            
            if(_css.assembledTagDictionary[IUCSSTagPixelHeight]){
                
                NSInteger brCount = [self.delegate countOfLineWithIdentifier:self.htmlID];
                CGFloat height = [_css.assembledTagDictionary[IUCSSTagPixelHeight] floatValue];
                CGFloat fontSize = [_css.assembledTagDictionary[IUCSSTagFontSize] floatValue];
                CGFloat lineheight;
                                
                if(height < 0.1 || height < fontSize || brCount <0.1 || fontSize <0.1){
                    lineheight = 1.0;
                }
                else{
                    lineheight = ((height/brCount)/fontSize);
                }
                
                if(brCount > 3 && lineheight > 50){
                    lineheight = 50;
                }
                [_css setValueWithoutUpdateCSS:@(lineheight) forTag:IUCSSTagLineHeight];
            }
        }
        
        IUCSSCode *cssCode = [self.project.compiler cssCodeForIU:self];
        NSDictionary *dictionaryWithIdentifier = [cssCode stringTagDictionaryWithIdentifierForEditorViewport:(int)_css.editWidth];
        for (NSString *identifier in dictionaryWithIdentifier) {
            [self.delegate IUClassIdentifier:identifier CSSUpdated:dictionaryWithIdentifier[identifier]];
        }
        
        
        //Review : sheet css로 들어가는 id 들은 없어지면, 지워줘야함.
        NSMutableArray *removedIdentifier = [NSMutableArray arrayWithArray:[self cssIdentifierArray]];
        [removedIdentifier removeObjectsInArray:[dictionaryWithIdentifier allKeys]];
        
        for(NSString *identifier in removedIdentifier){
            if([identifier containsString:@"hover"]){
                [self.delegate removeCSSTextInDefaultSheetWithIdentifier:identifier];
            }
        }
        
        
        [self.delegate updateJS];
        
    }
}

- (void)updateCSSWithIdentifiers:(NSArray *)identifiers{
    if (self.delegate) {
        IUCSSCode *cssCode = [self.project.compiler cssCodeForIU:self];
        NSDictionary *dictionaryWithIdentifier = [cssCode stringTagDictionaryWithIdentifierForEditorViewport:(int)_css.editWidth];
        
        for (NSString *identifier in identifiers) {
            [self.delegate IUClassIdentifier:identifier CSSUpdated:dictionaryWithIdentifier[identifier]];
        }
    }
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

-(BOOL)canAddIUByUserInput{
    return YES;
}

- (BOOL)canRemoveIUByUserInput{
    return YES;
}

-(BOOL)shouldCompileChildrenForOutput{
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
        }
    }
    

    [self updateHTML];
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
    
    [iu disconnectWithEditor];
    [self updateHTML];
    return YES;
}

-(BOOL)removeAllIU{
    NSArray *children = self.children;
    for (IUBox *iu in children) {
        NSInteger index = [_m_children indexOfObject:iu];
        [[self.undoManager prepareWithInvocationTarget:self] insertIU:iu atIndex:index error:nil];
        
        //IURemoved 호출한 다음에 m_children을 호출해야함.
        //border를 지울려면 controller 에 iu 정보 필요.
        //--undo [self.project.identifierManager unregisterIUs:@[iu]];
        [self.delegate IURemoved:iu.htmlID withParentID:iu.parent.htmlID];
        [_m_children removeObject:iu];
    }
    
    if (self.isConnectedWithEditor) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationStructureDidChange object:self.project userInfo:@{IUNotificationStructureChangeType: IUNotificationStructureChangeRemoving, IUNotificationStructureChangedIU: children}];
    }
    
    return YES;
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

- (BOOL)shouldCompileImagePositionInfo{
    return YES;
}


-(BOOL)hasX{
    return YES;
}

-(BOOL)hasY{
    if (self.positionType == IUPositionTypeAbsoluteBottom) {
        return NO;
    }
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
    if(self.enableHCenter){
        return NO;
    }
    return YES;
}
- (BOOL)canChangeYByUserInput{
    if(self.enableVCenter){
        return NO;
    }
    return YES;
}
- (BOOL)canChangeWidthByUserInput{
    return YES;
}
- (BOOL)canChangeHeightByUserInput{
    return YES;
}
- (BOOL)canChangeWidthUnitByUserInput{
    return YES;
}

#pragma mark setFrame

- (void)setPosition:(NSPoint)position{
    [_css setValueWithoutUpdateCSS:@(position.x) forTag:IUCSSTagPixelX];
    [_css setValueWithoutUpdateCSS:@(position.y) forTag:IUCSSTagPixelY];
}

- (void)setPercentFrame:(NSRect)frame{
    CGFloat x = frame.origin.x;
    CGFloat xExist =[_css.assembledTagDictionary[IUCSSTagPercentX] floatValue];
    if (x != xExist) {
        [_css setValueWithoutUpdateCSS:@(frame.origin.x) forTag:IUCSSTagPercentX];
    }
    if (frame.origin.x != [_css.assembledTagDictionary[IUCSSTagPercentY] floatValue]) {
        [_css setValueWithoutUpdateCSS:@(frame.origin.y) forTag:IUCSSTagPercentY];
    }
    if (frame.origin.x != [_css.assembledTagDictionary[IUCSSTagPercentHeight] floatValue]) {
        [_css setValueWithoutUpdateCSS:@(frame.size.height) forTag:IUCSSTagPercentHeight];
    }
    if (frame.origin.x != [_css.assembledTagDictionary[IUCSSTagPercentWidth] floatValue]) {
        [_css setValueWithoutUpdateCSS:@(frame.size.width) forTag:IUCSSTagPercentWidth];
    }
}

- (void)setPixelFrame:(NSRect)frame{
    [_css setValueWithoutUpdateCSS:@(frame.origin.x) forTag:IUCSSTagPixelX];
    [_css setValueWithoutUpdateCSS:@(frame.origin.y) forTag:IUCSSTagPixelY];
    [_css setValueWithoutUpdateCSS:@(frame.size.height) forTag:IUCSSTagPixelHeight];
    [_css setValueWithoutUpdateCSS:@(frame.size.width) forTag:IUCSSTagPixelWidth];
}

-(BOOL)percentUnitAtCSSTag:(IUCSSTag)tag{
    BOOL unit = [_css.assembledTagDictionary[tag] boolValue];
    return unit;
}

#pragma mark move by drag & drop




/*
 drag 중간의 diff size로 하면 css에 의한 오차가 생김.
 drag session이 시작될때부터 위치에서의 diff size로 계산해야 오차가 발생 안함.
 drag session이 시작할때 그 때의 위치를 저장함.
 */

- (NSPoint)currentPosition{
    NSInteger currentX = [_css.assembledTagDictionary[IUCSSTagPixelX] integerValue];
    NSInteger currentY = 0;
    if([_css.assembledTagDictionary objectForKey:IUCSSTagPixelY]){
        currentY = [_css.assembledTagDictionary[IUCSSTagPixelY] integerValue];
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
    NSInteger currentWidth = [_css.assembledTagDictionary[IUCSSTagPixelWidth] integerValue];
    NSInteger currentHeight = [_css.assembledTagDictionary[IUCSSTagPixelHeight] integerValue];
    
    return NSMakeSize(currentWidth, currentHeight);
}

- (NSSize)currentPercentSize{
    NSInteger currentPWidth = [_css.assembledTagDictionary[IUCSSTagPercentWidth] floatValue];
    NSInteger currentPHeight = [_css.assembledTagDictionary[IUCSSTagPercentHeight] floatValue];
    
    return NSMakeSize(currentPWidth, currentPHeight);
}
- (void)startDragSession{
    
    undoFrameDict = [NSMutableDictionary dictionary];
    
    if(_css.assembledTagDictionary[IUCSSTagPixelX]){
        undoFrameDict[IUCSSTagPixelX] = _css.assembledTagDictionary[IUCSSTagPixelX];
    }
    if(_css.assembledTagDictionary[IUCSSTagPixelY]){
        undoFrameDict[IUCSSTagPixelY] = _css.assembledTagDictionary[IUCSSTagPixelY];
    }
    if(_css.assembledTagDictionary[IUCSSTagPixelWidth]){
        undoFrameDict[IUCSSTagPixelWidth] = _css.assembledTagDictionary[IUCSSTagPixelWidth];
    }
    if(_css.assembledTagDictionary[IUCSSTagPixelHeight]){
        undoFrameDict[IUCSSTagPixelHeight] = _css.assembledTagDictionary[IUCSSTagPixelHeight];
    }

    
    if(_css.assembledTagDictionary[IUCSSTagPercentX]){
        undoFrameDict[IUCSSTagPercentX] = _css.assembledTagDictionary[IUCSSTagPercentX];
    }
    if(_css.assembledTagDictionary[IUCSSTagPercentY]){
        undoFrameDict[IUCSSTagPercentY] = _css.assembledTagDictionary[IUCSSTagPercentY];
    }
    if(_css.assembledTagDictionary[IUCSSTagPercentWidth]){
        undoFrameDict[IUCSSTagPercentWidth] = _css.assembledTagDictionary[IUCSSTagPercentWidth];
    }
    if(_css.assembledTagDictionary[IUCSSTagPercentHeight]){
        undoFrameDict[IUCSSTagPercentHeight] = _css.assembledTagDictionary[IUCSSTagPercentHeight];
    }

    originalSize = [self currentSize];
    originalPercentSize = [self currentPercentSize];
    originalPoint = [self currentPosition];
    originalPercentPoint = [self currentPercentPosition];
    
}

- (void)endDragSession{
    [[self undoManager] beginUndoGrouping];
    [[self.undoManager prepareWithInvocationTarget:self] undoFrameWithDictionary:undoFrameDict];
    [[self undoManager] endUndoGrouping];
}

- (void)undoFrameWithDictionary:(NSMutableDictionary *)dictionary{
    NSMutableDictionary *currentFrameDict = [NSMutableDictionary dictionary];
    
    if(_css.assembledTagDictionary[IUCSSTagPixelX]){
        currentFrameDict[IUCSSTagPixelX] = _css.assembledTagDictionary[IUCSSTagPixelX];
    }
    if(_css.assembledTagDictionary[IUCSSTagPixelY]){
        currentFrameDict[IUCSSTagPixelY] = _css.assembledTagDictionary[IUCSSTagPixelY];
    }
    if(_css.assembledTagDictionary[IUCSSTagPixelWidth]){
        currentFrameDict[IUCSSTagPixelWidth] = _css.assembledTagDictionary[IUCSSTagPixelWidth];
    }
    if(_css.assembledTagDictionary[IUCSSTagPixelHeight]){
        currentFrameDict[IUCSSTagPixelHeight] = _css.assembledTagDictionary[IUCSSTagPixelHeight];
    }
    
    
    if(_css.assembledTagDictionary[IUCSSTagPercentX]){
        currentFrameDict[IUCSSTagPercentX] = _css.assembledTagDictionary[IUCSSTagPercentX];
    }
    if(_css.assembledTagDictionary[IUCSSTagPercentY]){
        currentFrameDict[IUCSSTagPercentY] = _css.assembledTagDictionary[IUCSSTagPercentY];
    }
    if(_css.assembledTagDictionary[IUCSSTagPercentWidth]){
        currentFrameDict[IUCSSTagPercentWidth] = _css.assembledTagDictionary[IUCSSTagPercentWidth];
    }
    if(_css.assembledTagDictionary[IUCSSTagPercentHeight]){
        currentFrameDict[IUCSSTagPercentHeight] = _css.assembledTagDictionary[IUCSSTagPercentHeight];
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] undoFrameWithDictionary:currentFrameDict];
    
    [_css setValueWithoutUpdateCSS:dictionary[IUCSSTagPixelX] forTag:IUCSSTagPixelX];
    [_css setValueWithoutUpdateCSS:dictionary[IUCSSTagPixelY] forTag:IUCSSTagPixelY];
    [_css setValueWithoutUpdateCSS:dictionary[IUCSSTagPixelWidth] forTag:IUCSSTagPixelWidth];
    [_css setValueWithoutUpdateCSS:dictionary[IUCSSTagPixelHeight] forTag:IUCSSTagPixelHeight];

    [_css setValueWithoutUpdateCSS:dictionary[IUCSSTagPixelX] forTag:IUCSSTagPixelX];
    [_css setValueWithoutUpdateCSS:dictionary[IUCSSTagPixelY] forTag:IUCSSTagPixelY];
    [_css setValueWithoutUpdateCSS:dictionary[IUCSSTagPercentWidth] forTag:IUCSSTagPercentWidth];
    [_css setValueWithoutUpdateCSS:dictionary[IUCSSTagPercentHeight] forTag:IUCSSTagPercentHeight];

    
    [self updateCSS];
}

- (void)movePosition:(NSPoint)point withParentSize:(NSSize)parentSize{
    //Set Pixel
    if([self hasX] && [self canChangeXByUserInput]){
        NSInteger currentX = originalPoint.x + point.x;
        
        [_css setValueWithoutUpdateCSS:@(currentX) forTag:IUCSSTagPixelX];

        //set Percent if enablePercent
        BOOL enablePercentX = [self percentUnitAtCSSTag:IUCSSTagXUnitIsPercent];
        if(enablePercentX){
            CGFloat percentX = 0;
            if(parentSize.width!=0){
                percentX = (currentX / parentSize.width) * 100;
            }
            [_css setValueWithoutUpdateCSS:@(percentX) forTag:IUCSSTagPercentX];
        }
    }
    
    if([self hasY] && [self canChangeYByUserInput]){
        
        NSInteger currentY = originalPoint.y + point.y;
        [_css setValueWithoutUpdateCSS:@(currentY) forTag:IUCSSTagPixelY];

        
        BOOL enablePercentY = [self percentUnitAtCSSTag:IUCSSTagYUnitIsPercent];
        if(enablePercentY){
            CGFloat percentY = 0;
            if(parentSize.height!=0){
                percentY = (currentY / parentSize.height) * 100;
            }
            [_css setValueWithoutUpdateCSS:@(percentY) forTag:IUCSSTagPercentY];
        }
    }
    
}

- (void)increaseSize:(NSSize)size withParentSize:(NSSize)parentSize{
    if([self hasWidth] && [self canChangeWidthByUserInput] && size.width != CGFLOAT_INVALID){
        NSInteger currentWidth = originalSize.width;
        currentWidth += size.width;
        if(currentWidth < 0){
            currentWidth = 0;
        }
        [_css setValueWithoutUpdateCSS:@(currentWidth) forTag:IUCSSTagPixelWidth];

        CGFloat percentWidth = originalPercentSize.width;
        if(parentSize.width!=0){
            percentWidth += (size.width / parentSize.width) *100;
        }
        if(percentWidth < 0){
            percentWidth =0;
        }
        [_css setValueWithoutUpdateCSS:@(percentWidth) forTag:IUCSSTagPercentWidth];
     
    }
    if([self hasHeight] && [self canChangeHeightByUserInput]  && size.height != CGFLOAT_INVALID){
        NSInteger currentHeight = originalSize.height;
        currentHeight += size.height;
        if(currentHeight < 0){
            currentHeight =0;
        }
        [_css setValueWithoutUpdateCSS:@(currentHeight) forTag:IUCSSTagPixelHeight];
        
        CGFloat percentHeight = originalPercentSize.height;
        if(parentSize.height!=0){
            percentHeight += (size.height / parentSize.height) *100;
        }
        if(percentHeight < 0){
            percentHeight = 0;
        }
        [_css setValueWithoutUpdateCSS:@(percentHeight) forTag:IUCSSTagPercentHeight];        
    }
}


- (NSSize)currentApproximatePixelSize{

    NSSize pixelSize;
    NSInteger currentWidth;
    if(_css.editWidth == IUCSSDefaultViewPort){
        currentWidth = _css.maxWidth;
    }
    else{
        currentWidth = _css.editWidth;
    }
    
    if([self percentUnitAtCSSTag:IUCSSTagWidthUnitIsPercent]){
        CGFloat pWidth = [self currentPercentSize].width;
        pixelSize.width = (pWidth/100) * currentWidth;
    }
    else{
        pixelSize.width = [self currentSize].width;
    }
    if( [self percentUnitAtCSSTag:IUCSSTagHeightUnitIsPercent]){
        CGFloat pHeight = [self currentPercentSize].height;
        pixelSize.height =(pHeight/100) * currentWidth;
    }
    else{
        pixelSize.height = [self currentSize].height;
    }
    return pixelSize;
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

- (BOOL)canChangePositionAbsoluteBottom{
    return YES;
}
- (BOOL)canChangePositionFixed{
    return YES;
}
- (BOOL)canChangePositionFixedBottom{
    return YES;
}

- (BOOL)canChangeHCenter{
    if(_positionType == IUPositionTypeFloatLeft || _positionType == IUPositionTypeFloatRight
       || _css.editWidth != IUCSSDefaultViewPort){
        return NO;
    }
    return YES;
}

- (BOOL)canChangeVCenter{
    if(_positionType == IUPositionTypeAbsolute ||
       _positionType == IUPositionTypeFixed){
        return YES;
    }
    return NO;
}


- (BOOL)canChangeInitialPosition{
    return YES;
}


- (BOOL)canChangeOverflow{
    return YES;
}

#pragma mark - setting position

- (void)setPositionType:(IUPositionType)positionType{
    
    if(_positionType == positionType){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setPositionType:_positionType];
    
    if (_positionType == IUPositionTypeFloatRight || positionType == IUPositionTypeFloatRight){
        [self.css setValue:@(0) forTag:IUCSSTagPixelX];
        [self.css setValue:@(0) forTag:IUCSSTagPercentX];
    }
    
    BOOL disableCenterFlag = NO;
    if (positionType == IUPositionTypeFloatLeft || positionType == IUPositionTypeFloatRight
        || _positionType == IUPositionTypeFloatLeft || _positionType == IUPositionTypeFloatRight) {
        if(positionType == IUPositionTypeFloatLeft || positionType == IUPositionTypeFloatRight){
            self.enableHCenter = NO;
        }
        disableCenterFlag = YES;
        [self willChangeValueForKey:@"canChangeHCenter"];

    }
    
    BOOL disableVCenterFlag = NO;
    if(positionType == IUPositionTypeFloatLeft || positionType == IUPositionTypeFloatRight
       || positionType == IUPositionTypeRelative
       || positionType == IUPositionTypeAbsoluteBottom
       || positionType == IUPositionTypeFixedBottom
       || _positionType == IUPositionTypeFloatLeft
       || _positionType == IUPositionTypeFloatRight
       || _positionType == IUPositionTypeRelative
       || _positionType == IUPositionTypeAbsoluteBottom
       || _positionType == IUPositionTypeFixedBottom){
        
        if( _positionType == IUPositionTypeFloatLeft
           || _positionType == IUPositionTypeFloatRight
           || _positionType == IUPositionTypeRelative
           || _positionType == IUPositionTypeAbsoluteBottom
           || _positionType == IUPositionTypeFixedBottom){
            self.enableVCenter = NO;
        }
        
        [self willChangeValueForKey:@"canChangeVCenter"];
        disableVCenterFlag= YES;
        
    }
    
    
    BOOL absoluteBottomFlag = _positionType == IUPositionTypeAbsoluteBottom || positionType == IUPositionTypeAbsoluteBottom;
    if (absoluteBottomFlag) {
        [self.css setValue:@(0) forTag:IUCSSTagPixelY];
        [self.css setValue:@(0) forTag:IUCSSTagPercentY];
        [self.css setValue:@(NO) forTag:IUCSSTagYUnitIsPercent];
        [self willChangeValueForKey:@"hasY"];
    }
    _positionType = positionType;
    if (absoluteBottomFlag) {
        [self didChangeValueForKey:@"hasY"];
    }
    if (disableCenterFlag){
        [self didChangeValueForKey:@"canChangeHCenter"];

    }
    if (disableVCenterFlag){
        [self didChangeValueForKey:@"canChangeVCenter"];
    }
    
    
    if(_positionType == IUPositionTypeRelative ||
       _positionType == IUPositionTypeFloatLeft ||
       _positionType == IUPositionTypeFloatRight){
        //html order
        [self.parent updateHTML];
    }
    else{
        [self updateCSS];
    }

}
- (void)setEnableHCenter:(BOOL)enableHCenter{

    if(_enableHCenter != enableHCenter){
        [self willChangeValueForKey:@"canChangeXByUserInput"];
        [[self.undoManager prepareWithInvocationTarget:self] setEnableHCenter:_enableHCenter];
        _enableHCenter = enableHCenter;
        [self updateHTML];
        [self didChangeValueForKey:@"canChangeXByUserInput"];
    }
}


- (void)setEnableVCenter:(BOOL)enableVCenter{
    
    if(_enableVCenter != enableVCenter){
        [self willChangeValueForKey:@"canChangeYByUserInput"];
        [[self.undoManager prepareWithInvocationTarget:self] setEnableVCenter:_enableVCenter];
        _enableVCenter = enableVCenter;
        [self updateHTML];
        [self didChangeValueForKey:@"canChangeYByUserInput"];
    }
}



- (void)setOverflowType:(IUOverflowType)overflowType{
    _overflowType = overflowType;
    [self updateHTML];
}



#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
#pragma mark -text

- (void)setText:(NSString *)text{
    if([_text isEqualToString:text]){
        return;
    }
    BOOL isNeedUpdated = NO;
    if(_text == nil || text == nil){
        [self willChangeValueForKey:@"shouldCompileFontInfo"];
        isNeedUpdated = YES;
    }
    _text = text;
    
    if(_text.length > 300){
        [self setLineHeightAuto:NO];
    }
    [self updateHTML];
    
    if(isNeedUpdated){
        [self didChangeValueForKey:@"shouldCompileFontInfo"];
    }

}

- (void)setLineHeightAuto:(BOOL)lineHeightAuto{
    if( _text && _text.length > 300){
        lineHeightAuto = false;
    }
    if(lineHeightAuto != _lineHeightAuto){
        [[self.undoManager prepareWithInvocationTarget:self] setLineHeightAuto:_lineHeightAuto];
        _lineHeightAuto = lineHeightAuto;
        [self updateCSS];
    }
}

#endif

- (NSString*)cssIdentifier{
    return [@"." stringByAppendingString:self.htmlID];
}
- (NSString*)cssHoverClass{
    return [NSString stringWithFormat:@"%@:hover", self.cssIdentifier];
}
- (NSString*)cssActiveClass{
    return [NSString stringWithFormat:@"%@.active", self.cssIdentifier];
}

- (NSString*)cssClassStringForHTML{
    NSArray *classPedigree = [[self class] classPedigreeTo:[IUBox class]];
    NSMutableString *className = [NSMutableString string];
    for (NSString *str in classPedigree) {
        [className appendString:str];
        [className appendString:@" "];
    }
    [className appendFormat:@" %@", self.htmlID];
    return className;
}



- (BOOL)canMoveToOtherParent{
    return YES;
}
@end
