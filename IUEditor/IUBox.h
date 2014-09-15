//
//  IUBox.h
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCSS.h"
#import "IUEvent.h"
#import "IUIdentifierManager.h"


@protocol IUSourceDelegate <NSObject>
@required

//enable, disable update
- (void)enableUpdateAll:(id)sender;
- (void)disableUpdateAll:(id)sender;
- (void)enableUpdateCSS:(id)sender;
- (void)disableUpdateCSS:(id)sender;
- (BOOL)isUpdateCSSEnabled;
- (void)enableUpdateJS:(id)sender;
- (void)disableUpdateJS:(id)sender;
- (BOOL)isUpdateJSEnabled;
- (void)enableUpdateHTML:(id)sender;
- (void)disableUpdateHTML:(id)sender;
- (BOOL)isUpdateHTMLEnabled;

//css update
-(void)IUClassIdentifier:(NSString *)identifier CSSUpdated:(NSString*)css;
//style-sheet css
-(void)removeCSSTextInDefaultSheetWithIdentifier:(NSString *)identifier;

//js update (frame)
- (void)updateJS;

//html update
-(void)IUHTMLIdentifier:(NSString*)identifier textHTML:(NSString *)html withParentID:(NSString *)parentID nearestID:(NSString *)nID index:(NSUInteger)index;
-(void)IUHTMLIdentifier:(NSString *)identifier HTML:(NSString *)html withParentID:(NSString *)parentID;

-(void)IUClassIdentifier:(NSString *)classIdentifier addClass:(NSString *)className;
-(void)IUClassIdentifier:(NSString *)classIdentifier removeClass:(NSString *)className;
-(void)updateTextRangeFromID:(NSString *)fromID toID:(NSString *)toID;

-(void)IURemoved:(NSString*)identifier withParentID:(NSString *)parentID;

- (NSPoint)distanceFromIU:(NSString *)iuName to:(NSString *)parentName;
- (NSSize)frameSize:(NSString *)identifier;
- (NSInteger)countOfLineWithIdentifier:(NSString *)identifier;
/**
 @brief call javascript function
 @param args javascirpt function argument, argument에 들어가는 것중에 dict, array는 string으로 보내서javascript내부에서 새로 var를 만들어서 사용
*/
- (id)callWebScriptMethod:(NSString *)function withArguments:(NSArray *)args;
- (id)evaluateWebScript:(NSString *)script;


@end

typedef enum _IUPositionType{
    IUPositionTypeAbsolute,
    IUPositionTypeAbsoluteBottom,
    IUPositionTypeRelative,
    IUPositionTypeFloatLeft,
    IUPositionTypeFloatRight,
    IUPositionTypeFixed,
    IUPositionTypeFixedBottom,
}IUPositionType;


typedef enum{
    IUTextTypeDefault,
    IUTextTypeH1,
    IUTextTypeH2,
}IUTextType;

typedef enum _IUOverflowType{
    IUOverflowTypeHidden,
    IUOverflowTypeVisible,
    IUOverflowTypeScroll,
}IUOverflowType;


@class IUBox;
@class IUSheet;
@class IUProject;

@interface IUBox : NSObject <NSCoding, IUCSSDelegate, NSCopying>{
    NSMutableArray *_m_children;
    
}

/* default box */
+(IUBox *)copyrightBoxWithProject:(IUProject*)project;

/*
 Following are options
 */

#define IUFileName @"FileName"
/**
 initialize IU with project
 @param project project that will initizlie IU. Should not nil.
 @param options NSDictionary of options. \n
 IUFileName : define filename
 */
-(id)initWithProject:(IUProject*)project options:(NSDictionary*)options;
- (void)connectWithEditor;
- (void)disconnectWithEditor;

- (BOOL)isConnectedWithEditor;
- (void)setIsConnectedWithEditor;

-(IUSheet *)sheet;


/**
 @brief return project of box
 @note if iu is not confirmed, return project argument at initialize process
 */
-(IUProject *)project;

#pragma mark - IU Setting

@property (copy, nonatomic) NSString *name;
@property (copy) NSString *htmlID;
- (void)confirmIdentifier;

@property (nonatomic, weak) id<IUSourceDelegate> delegate;
@property (weak) IUBox    *parent;

#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
@property (nonatomic) NSString *text;

#endif

//undoManager
- (NSUndoManager *)undoManager;


//mediaquery
- (void)addMQSize:(NSNotification *)notification;
- (void)removeMQSize:(NSNotification *)notification;
- (void)changeMQSelect:(NSNotification *)notification;

//Event
@property (readonly) IUEvent *event;

//scroll event
@property (nonatomic) float opacityMove;
@property (nonatomic) float xPosMove;

//Programming
@property (nonatomic) NSString *pgVisibleConditionVariable;
@property (nonatomic) NSString *pgContentVariable;


//CSS
@property (readonly) IUCSS *css; //used by subclass
- (NSArray *)cssIdentifierArray;
- (void)updateCSS;
- (void)updateCSSWithIdentifiers:(NSArray *)identifiers;

//HTML
//-(NSString*)html; //DEPRECATED;
- (void)updateHTML;

//children
- (NSArray*)children;
- (NSMutableArray*)allChildren;
- (NSMutableArray *)allIdentifierChildren;


-(BOOL)shouldAddIUByUserInput;

-(BOOL)insertIU:(IUBox *)iu atIndex:(NSInteger)index  error:(NSError**)error;
-(BOOL)addIU:(IUBox *)iu error:(NSError**)error;

/**
 removeIUAtIndex:
 @note removeIUAtIndex: uses removeIU: as implementation.
        unregister identifier automatically.
 */
-(BOOL)removeIUAtIndex:(NSUInteger)index;

/**
 removeIU:
 @note unregister identifier automatically.
 */
-(BOOL)removeIU:(IUBox *)iu;
-(BOOL)removeAllIU;

-(BOOL)canRemoveIUByUserInput;
-(BOOL)changeIUIndex:(IUBox*)iu to:(NSUInteger)index error:(NSError**)error;
-(BOOL)addIUReference:(IUBox *)iu error:(NSError**)error;


//Frame
//user interface status
@property (readonly) BOOL canChangeXByUserInput;
@property (readonly) BOOL canChangeYByUserInput;
@property (readonly) BOOL canChangeWidthByUserInput;
@property (readonly) BOOL canChangeHeightByUserInput;

- (BOOL)hasX;
- (BOOL)hasY;
- (BOOL)hasWidth;
- (BOOL)hasHeight;
- (BOOL)shouldCompileFontInfo;
- (BOOL)shouldCompileImagePositionInfo;

- (void)setPixelFrame:(NSRect)frame;
- (void)setPercentFrame:(NSRect)frame;
- (void)setPosition:(NSPoint)position;
- (void)startDragSession;
- (void)endDragSession;
- (void)movePosition:(NSPoint)point withParentSize:(NSSize)parentSize;
- (void)increaseSize:(NSSize)size withParentSize:(NSSize)parentSize;
- (NSSize)currentApproximatePixelSize;


//Position
@property (nonatomic) IUPositionType positionType;
@property (nonatomic) BOOL enableCenter;
- (BOOL)canChangePositionType;
- (BOOL)canChangePositionAbsolute;
- (BOOL)canChangePositionRelative;
- (BOOL)canChangePositionFloatLeft;
- (BOOL)canChangePositionFloatRight;
- (BOOL)canChangePositionAbsoluteBottom;
- (BOOL)canChangePositionFixed;
- (BOOL)canChangePositionFixedBottom;
- (BOOL)canChangeCenter;
- (BOOL)canChangeInitialPosition;


//Property
- (BOOL)canCopy;
- (BOOL)canChangeOverflow;
- (BOOL)canSelectAtFirst;
@property (nonatomic) IUOverflowType overflowType;
@property (nonatomic) BOOL lineHeightAuto;

- (void)setImageName:(NSString *)imageName;
- (NSString *)imageName;

@property (nonatomic) id link, divLink;
@property BOOL linkTarget;


//0 for default, 1 for H1, 2 for H2
@property IUTextType textType;

- (NSString*)cssClass;
- (NSString*)cssHoverClass;
- (NSString*)cssActiveClass;
- (NSString*)cssClassStringForHTML;

//can move to other parent?
- (BOOL)canMoveToOtherParent;
@end