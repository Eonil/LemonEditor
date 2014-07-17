//
//  LMWC.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMWC.h"
#import "LMWindow.h"

#import "IUSheetController.h"
#import "IUProject.h"
#import "IUSheetGroup.h"
#import "IUResourceGroup.h"
#import "IUResourceFile.h"


#import "IUResourceManager.h"
#import "IUIdentifierManager.h"

//connect VC
#import "LMAppearanceVC.h"
#import "LMResourceVC.h"
#import "LMFileNaviVC.h"
#import "LMStackVC.h"
#import "LMWidgetLibraryVC.h"
#import "LMCanvasVC.h"
#import "LMEventVC.h"
#import "LMCommandVC.h"

#import "LMTopToolbarVC.h"
#import "LMBottomToolbarVC.h"
#import "LMIUPropertyVC.h"

#import "IUDjangoProject.h"

#import "LMProjectConvertWC.h"
#import "IUProjectDocument.h"

#import "LMConsoleVC.h"
#import "LMProjectPropertyWC.h"


@interface LMWC ()

//toolbar
@property (weak) IBOutlet NSView *topToolbarV;
@property (weak) IBOutlet NSView *bottomToolbarV;

//Left
@property (weak) IBOutlet NSLayoutConstraint *leftVConstraint;
@property (weak) IBOutlet NSSplitView *leftV;
@property (weak) IBOutlet NSView *leftTopV;
@property (weak) IBOutlet NSView *leftBottomV;
@property (weak) IBOutlet NSView *commandV;

//Right-V
@property (weak) IBOutlet NSSplitView *rightV;
@property (weak) IBOutlet NSLayoutConstraint *rightVConstraint;

//Right-top
@property (weak) IBOutlet NSTabView *propertyTabV;
@property (weak) IBOutlet NSMatrix *propertyMatrix;
@property (weak) IBOutlet NSView *propertyV;
@property (weak) IBOutlet NSView *appearanceV;
@property (weak) IBOutlet NSView *eventV;

//Right-bottom
@property (weak) IBOutlet NSTabView *widgetTabV;
@property (weak) IBOutlet NSMatrix *clickWidgetTabMatrix;
@property (weak) IBOutlet NSView *widgetV;
@property (weak) IBOutlet NSView *resourceV;

//center
@property (weak) IBOutlet NSSplitView *centerSplitV;
@property (weak) IBOutlet NSView *centerV;
@property (weak) IBOutlet NSView *consoleV;

//server log
@property (weak) IBOutlet WebView *serverView;

@end

@implementation LMWC{
    IUProject   *_project;

    //VC for view
    //left
    LMFileNaviVC    *fileNaviVC;
    LMStackVC       *stackVC;
    LMCommandVC     *commandVC;
    
    //center
    LMTopToolbarVC  *topToolbarVC;
    LMCanvasVC *canvasVC;
    LMConsoleVC *consoleVC;
    LMBottomToolbarVC     *bottomToolbarVC;

    //right top
    LMIUPropertyVC  *iuInspectorVC;
    LMAppearanceVC  *appearanceVC;
    LMEventVC       *eventVC;
    
    //right bottom
    LMWidgetLibraryVC   *widgetLibraryVC;
    LMResourceVC    *resourceVC;

    //sheet
    LMProjectConvertWC *pcWC;
    LMProjectPropertyWC *projectPropertyWC;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        //allocation
        stackVC = [[LMStackVC alloc] initWithNibName:@"LMStackVC" bundle:nil];
        fileNaviVC = [[LMFileNaviVC alloc] initWithNibName:@"LMFileNaviVC" bundle:nil];
        commandVC = [[LMCommandVC alloc] initWithNibName:@"LMCommandVC" bundle:nil];
        canvasVC = [[LMCanvasVC alloc] initWithNibName:@"LMCanvasVC" bundle:nil];
        topToolbarVC = [[LMTopToolbarVC alloc] initWithNibName:@"LMTopToolbarVC" bundle:nil];
        bottomToolbarVC = [[LMBottomToolbarVC alloc] initWithNibName:@"LMBottomToolbarVC" bundle:nil];
        widgetLibraryVC = [[LMWidgetLibraryVC alloc] initWithNibName:@"LMWidgetLibraryVC" bundle:nil];
        resourceVC = [[LMResourceVC alloc] initWithNibName:@"LMResourceVC" bundle:nil];
        appearanceVC = [[LMAppearanceVC alloc] initWithNibName:@"LMAppearanceVC" bundle:nil];
        iuInspectorVC = [[LMIUPropertyVC alloc] initWithNibName:[LMIUPropertyVC class].className bundle:nil];
        eventVC = [[LMEventVC alloc] initWithNibName:@"LMEventVC" bundle:nil];
        consoleVC = [[LMConsoleVC alloc] initWithNibName:@"LMConsoleVC" bundle:nil];

        
        //bind
        [self bind:@"IUController" toObject:stackVC withKeyPath:@"IUController" options:nil];
        [self bind:@"selectedNode" toObject:fileNaviVC withKeyPath:@"selection" options:nil];
        [self bind:@"documentController" toObject:fileNaviVC withKeyPath:@"documentController" options:nil];
        [commandVC bind:@"docController" toObject:self withKeyPath:@"documentController" options:nil];
        [canvasVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
        [self bind:@"selectedTextRange" toObject:self withKeyPath:@"selectedTextRange" options:nil];
        [widgetLibraryVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
        [appearanceVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
        [iuInspectorVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
        [eventVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
        [topToolbarVC bind:@"sheetController" toObject:fileNaviVC withKeyPath:@"documentController" options:nil];
        
        
        //project binding
        [canvasVC bind:@"documentBasePath" toObject:self withKeyPath:@"document.project.path" options:nil];
    }
    return self;
}



- (void)windowDidLoad
{
    [_leftTopV addSubviewFullFrame:stackVC.view];
    [_leftBottomV addSubviewFullFrame:fileNaviVC.view];
    [_commandV addSubviewFullFrame:commandVC.view];

    
    ////////////////center view/////////////////////////
    [_centerV addSubviewFullFrame:canvasVC.view];
    
    ((LMWindow*)(self.window)).canvasView =  (LMCanvasView *)canvasVC.view;
    
    [_topToolbarV addSubviewFullFrame:topToolbarVC.view];
    [_bottomToolbarV addSubviewFullFrame:bottomToolbarVC.view];
    [_consoleV addSubviewFullFrame:consoleVC.view];
    
    ////////////////right view/////////////////////////
    [_widgetV addSubviewFullFrame:widgetLibraryVC.view];
    [_resourceV addSubviewFullFrame:resourceVC.view];
    
    [_appearanceV addSubviewFullFrame:appearanceVC.view];
    [_propertyV addSubviewFullFrame:iuInspectorVC.view];
    [_eventV addSubviewFullFrame:eventVC.view];
    
    
    [self setLogViewState:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performDoubleClick:) name:IUNotificationDoubleClickCanvas object:self.window];
    [[NSNotificationCenter defaultCenter]addObserverForName:IUNotificationConsoleEnd object:self.window queue:nil usingBlock:^(NSNotification *note) {
        [self setLogViewState:0];
    }];
    [[NSNotificationCenter defaultCenter]addObserverForName:IUNotificationConsoleStart object:self.window queue:nil usingBlock:^(NSNotification *note) {
        [self setLogViewState:1];
    }];
}


- (void)performDoubleClick:(NSNotification*)noti{
    [_propertyTabV selectTabViewItemAtIndex:1];
    [_propertyMatrix selectCellAtRow:0 column:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [iuInspectorVC setFocusForDoubleClickAction];
    });
}


- (void)awakeFromNib{
    self.window.delegate = self;
    
    NSCell *cell = [self.propertyMatrix cellAtRow:0 column:0];
    [self.propertyMatrix setToolTip:@"Appearance" forCell:cell];
    
    NSCell *cell2 = [self.propertyMatrix cellAtRow:0 column:1];
    [self.propertyMatrix setToolTip:@"Property" forCell:cell2];

    NSCell *cell3 = [self.propertyMatrix cellAtRow:0 column:2];
    [self.propertyMatrix setToolTip:@"Event" forCell:cell3];

    
    NSCell *cell7 = [self.clickWidgetTabMatrix cellAtRow:0 column:0];
    [self.clickWidgetTabMatrix setToolTip:@"Primary Widget" forCell:cell7];
    
    NSCell *cell8 = [self.clickWidgetTabMatrix cellAtRow:0 column:1];
    [self.clickWidgetTabMatrix setToolTip:@"Secondary Widget" forCell:cell8];
    

#if DEBUG
#else
    [[_serverView mainFrame] loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://server.iueditor.org/log.html"]]];
#endif
}

- (void)dealloc{
    //release 시점 확인용
    NSAssert(0, @"");
}

- (void)setLeftInspectorState:(NSInteger)state{
    [_leftV setHidden:!state];
    if(state){
        [_leftVConstraint setConstant:0];
    }
    else{
        [_leftVConstraint setConstant:-220];
    }
}

- (void)setRightInspectorState:(NSInteger)state{
    [_rightV setHidden:!state];
    
    if(state){
        [_rightVConstraint setConstant:0];
    }
    else{
        [_rightVConstraint setConstant:-300];
    }
}

- (void)setLogViewState:(NSInteger)state{
    
    CGFloat height = [_centerSplitV bounds].size.height;

    if(state){
        CGFloat lastPosition = [[NSUserDefaults standardUserDefaults] doubleForKey:@"LastConsolePosition"];
        if (lastPosition == 0) {
            lastPosition = 50;
        }
       [_centerSplitV setPosition:height-lastPosition ofDividerAtIndex:0];
    }
    else{
        CGFloat position = _consoleV.frame.size.height;
        [[NSUserDefaults standardUserDefaults] setDouble:position forKey:@"LastConsolePosition"];
        [_centerSplitV setPosition:height ofDividerAtIndex:0];
    }
}


-(LMWindow*)window{
    return (LMWindow*)[super window];
}

- (void)setDocument:(IUProjectDocument *)document{
    //create project class
    [super setDocument:document];
    
    //document == nil means window will be closed
    if(document){
        _project = document.project;
        //[canvasVC bind:@"documentBasePath" toObject:_project withKeyPath:@"path" options:nil];
        NSError *error;
        NSAssert(_project.pageSheets, @"");
        NSAssert(_project.identifierManager, @"");
        NSAssert(_project.resourceManager, @"");
        
        if (error) {
            NSAssert(0, @"");
            return;
        }
        if (_project == nil) {
            return;
        }
        
        //load sizeView
        for(NSNumber *number in _project.mqSizes){
            NSInteger frameSize = [number integerValue];
            [canvasVC addFrame:frameSize];
        }
                
        //vc setting
        
        //construct widget library vc
        NSString *widgetFilePath = [[NSBundle mainBundle] pathForResource:@"widgetForDefault" ofType:@"plist"];
        NSArray *availableWidgetProperties = [NSArray arrayWithContentsOfFile:widgetFilePath];
        [widgetLibraryVC setWidgetProperties:availableWidgetProperties];
        
        //set project
        fileNaviVC.project = _project;
        widgetLibraryVC.project = _project;
        [widgetLibraryVC setProject:_project];
        iuInspectorVC.project = _project;
  
        //set ResourceManager
        canvasVC.resourceManager = _project.resourceManager;
        resourceVC.manager = _project.resourceManager;
        appearanceVC.resourceManager = _project.resourceManager;
        iuInspectorVC.resourceManager = _project.resourceManager;
        bottomToolbarVC.resourceManager = _project.resourceManager;
        
        [_project connectWithEditor];
        [_project setIsConnectedWithEditor];
    }
}

- (void)selectFirstDocument{
    [fileNaviVC selectFirstDocument];
}

-(void)setSelectedNode:(NSObject*)selectedNode{
    _selectedNode = (IUSheet*) selectedNode;
    if ([selectedNode isKindOfClass:[IUSheet class]]) {
        [stackVC setSheet:_selectedNode];
        [canvasVC setSheet:_selectedNode];
        [bottomToolbarVC setSheet:_selectedNode];
        [topToolbarVC setSheet:_selectedNode];
        
        //save for debug
        /*
        //remove this line : saving can't not in the package
        NSString *documentSavePath = [canvasVC.documentBasePath stringByAppendingPathComponent:[_selectedNode.name stringByAppendingPathExtension:@"html"]];
        [_selectedNode.editorSource writeToFile:documentSavePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
         */


        return;
    }
    else if ([selectedNode isKindOfClass:[IUProject class]]){
        [self openProjectPropertyWindow];
        return;
    }
    else if ([selectedNode isKindOfClass:[IUSheetGroup class]]){
        return;
    }
    else if ([selectedNode isKindOfClass:[IUResourceGroup class]]) {
        return;
    }
    else if ([selectedNode isKindOfClass:[IUResourceFile class]]) {
        return;
    }
}

- (void)reloadCurrentDocument{
    [canvasVC reloadSheet];
}



#pragma mark -
#if 0
- (void)saveDocument:(id)sender{
    JDInfoLog(@"saving document");
    [_project save];
}
#endif


#pragma mark -
#pragma mark select TavView
- (void)openProjectPropertyWindow{
    if(projectPropertyWC == nil){
        projectPropertyWC = [[LMProjectPropertyWC alloc] initWithWindowNibName:[LMProjectPropertyWC class].className withIUProject:_project];
    }
    
    [self.window beginSheet:projectPropertyWC.window completionHandler:^(NSModalResponse returnCode) {
        switch (returnCode) {
            case NSModalResponseOK:
                break;
            case NSModalResponseAbort:
            default:
                break;
        }
    }];
}
         

- (IBAction)clickPropertyMatrix:(id)sender {
    NSMatrix *propertyMatrix = sender;
    NSInteger index = [propertyMatrix selectedColumn];
    
    [_propertyTabV selectTabViewItemAtIndex:index];
}
- (IBAction)clickWidgetMatrix:(id)sender {
    NSMatrix *propertyMatrix = sender;
    NSInteger index = [propertyMatrix selectedColumn];
    
    [_widgetTabV selectTabViewItemAtIndex:index];

}


- (IBAction)convertProject:(id)sender{
    //call from menu item
    pcWC = [[LMProjectConvertWC alloc] initWithWindowNibName:@"LMProjectConvertWC"];
    pcWC.currentProject = _project;
    
    [self.window beginSheet:pcWC.window completionHandler:^(NSModalResponse returnCode) {
        switch (returnCode) {
            case NSModalResponseOK:
                [self close];
                break;
            case NSModalResponseAbort:
            default:
                break;
        }
    }];
}

- (NSString *)projectName{
    return _project.name;
}

- (void)windowWillClose:(NSNotification *)notification{
    [commandVC stopServer:self];
}

@end
