//
//  IUCompiler.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCompiler.h"
#import "IUProtocols.h"
#import "IUCSSCompiler.h"


#import "NSString+JDExtension.h"
#import "IUSheet.h"
#import "NSDictionary+JDExtension.h"
#import "JDUIUtil.h"
#import "IUPage.h"
#import "IUHeader.h"
#import "IUPageContent.h"
#import "IUClass.h"
#import "IUBackground.h"
#import "PGTextField.h"
#import "PGTextView.h"

#import "IUHTML.h"
#import "IUImage.h"
#import "IUMovie.h"
#import "IUWebMovie.h"
#import "IUFBLike.h"
#import "IUCarousel.h"
#import "IUItem.h"
#import "IUCarouselItem.h"
#import "IUCollection.h"
#import "PGSubmitButton.h"
#import "PGForm.h"
#import "PGPageLinkSet.h"
#import "IUTransition.h"
#import "JDCode.h"
#import "IUProject.h"
#import "IUMenuBar.h"
#import "IUMenuItem.h"
#import "IUTweetButton.h"

#import "IUCSSCompiler.h"

#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
#import "IUText.h"
#endif

#import "LMFontController.h"
#import "WPArticle.h"

@implementation IUCompiler{
    IUCSSCompiler *cssCompiler;
}

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - Header Part

/**
 
 metadata information
 http://moz.com/blog/meta-data-templates-123
 
 <!-- Update your html tag to include the itemscope and itemtype attributes. -->
 <html itemscope itemtype="http://schema.org/Product">
 
 <!-- Place this data between the <head> tags of your website -->
 <title>Page Title. Maximum length 60-70 characters</title>
 <meta name="description" content="Page description. No longer than 155 characters." />
 
 <!-- Schema.org markup for Google+ -->
 <meta itemprop="name" content="The Name or Title Here">
 <meta itemprop="description" content="This is the page description">
 <meta itemprop="image" content=" http://www.example.com/image.jpg">
 
 <!-- Twitter Card data -->
 <meta name="twitter:card" content="product">
 <meta name="twitter:site" content="@publisher_handle">
 <meta name="twitter:title" content="Page Title">
 <meta name="twitter:description" content="Page description less than 200 characters">
 <meta name="twitter:creator" content="@author_handle">
 <meta name="twitter:image" content=" http://www.example.com/image.html">
 <meta name="twitter:data1" content="$3">
 <meta name="twitter:label1" content="Price">
 <meta name="twitter:data2" content="Black">
 <meta name="twitter:label2" content="Color">
 
 <!-- Open Graph data -->
 <meta property="og:title" content="Title Here" />
 <meta property="og:type" content="article" />
 <meta property="og:url" content=" http://www.example.com/" />
 <meta property="og:image" content=" http://example.com/image.jpg" />
 <meta property="og:description" content="Description Here" />
 <meta property="og:site_name" content="Site Name, i.e. Moz" />
 <meta property="og:price:amount" content="15.00" />
 <meta property="og:price:currency" content="USD" />
 
 @brief : metadata for page
 
 */

-(JDCode *)metadataSource:(IUPage *)page{

    JDCode *code = [[JDCode alloc] init];
    //for google
    if(page.title && page.title.length != 0){
        [code addCodeLineWithFormat:@"<title>%@</title>", page.title];
        [code addCodeLineWithFormat:@"<meta property='og:title' content='%@' />", page.title];
        [code addCodeLineWithFormat:@"<meta name='twitter:title' content='%@'>", page.title];
        [code addCodeLineWithFormat:@"<meta itemprop='name' content='%@'>", page.title];

    }
    if(page.desc && page.desc.length != 0){
        [code addCodeLineWithFormat:@"<meta name='description' content='%@'>", page.desc];
        [code addCodeLineWithFormat:@"<meta property='og:description' content='%@' />", page.desc];
        [code addCodeLineWithFormat:@"<meta name='twitter:description' content='%@'>", page.desc];
        [code addCodeLineWithFormat:@"<meta itemprop='description' content='%@'>", page.desc];
    }
    if(page.keywords && page.keywords.length != 0){
        [code addCodeLineWithFormat:@"<meta name='keywords' content='%@'>", page.keywords];
    }
    if(page.project.author && page.project.author.length != 0){
        [code addCodeLineWithFormat:@"<meta name='author' content='%@'>", page.project.author];
        [code addCodeLineWithFormat:@"<meta property='og:site_name' content='%@' />", page.project.author];
        [code addCodeLineWithFormat:@"<meta name='twitter:creator' content='%@'>", page.project.author];

    }
    if(page.metaImage && page.metaImage.length !=0){
        NSString *imgSrc = [self imagePathWithImageName:page.metaImage isEdit:NO];
        [code addCodeLineWithFormat:@"<meta property='og:image' content='%@' />", imgSrc];
        [code addCodeLineWithFormat:@"<meta name='twitter:image' content='%@'>", imgSrc];
        [code addCodeLineWithFormat:@"<meta itemprop='image' content='%@'>", imgSrc];

    }
    if(page.project.favicon && page.project.favicon.length > 0){

        NSString *type = [page.project.favicon faviconType];
        if(type){
            NSString *imgSrc = [self imagePathWithImageName:page.project.favicon isEdit:NO];
            [code addCodeLineWithFormat:@"<link rel='icon' type='image/%@' href='%@'>",type, imgSrc];
            
        }
    }
    //for google analytics
    if(page.googleCode && page.googleCode.length != 0){
        [code addCodeLine:page.googleCode];
    }
    
    //js for tweet
    for(IUBox *child in page.allChildren){
        if([child isKindOfClass:[IUTweetButton class]]){
            [code addCodeLine:@"<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=\"https://platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script>"];
            break;
        }
    }
    


    return code;
}

-(JDCode *)webfontImportSourceForEdit{
    
    JDCode *code = [[JDCode alloc] init];
    LMFontController *fontController = [LMFontController sharedFontController];
    for(NSDictionary *dict  in fontController.fontDict.allValues){
        if([[dict objectForKey:LMFontNeedLoad] boolValue]){
            NSString *fontHeader = [dict objectForKey:LMFontHeaderLink];
            [code addCodeLine:fontHeader];
        }
    }
    
    return code;
}

-(JDCode *)webfontImportSourceForOutput:(IUPage *)page{
    NSMutableArray *fontNameArray = [NSMutableArray array];

    for (IUBox *box in page.allChildren){
        
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
        NSString *fontName = [box.css valueForKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagFontName]];
        if(fontName && fontName.length >0 && [fontNameArray containsString:fontName] == NO){
            [fontNameArray addObject:fontName];
        }
#else
        if([box isKindOfClass:[IUText class]]){
            for(NSString *fontName in [(IUText *)box fontNameArray]){
                if([fontNameArray containsString:fontName] == NO){
                    [fontNameArray addObject:fontName];
                }
            }
        }
        else{
            NSString *fontName = [box.css valueForKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagFontName]];
            if([fontNameArray containsString:fontName] == NO){
                [fontNameArray addObject:fontName];
            }
        }
#endif
    }

    JDCode *code = [[JDCode alloc] init];
    LMFontController *fontController = [LMFontController sharedFontController];
    
    for(NSString *fontName in fontNameArray){
        if([fontController isNeedHeader:fontName]){
            [code addCodeLine:[fontController headerForFontName:fontName]];
        }
    }
    return code;
}

- (NSArray *)outputClipArtArray:(IUSheet *)document{
    NSMutableArray *array = [NSMutableArray array];
    for (IUBox *box in document.allChildren){
        NSString *imageName = box.imageName;
        
        if(imageName){
            if([[imageName pathComponents][0] isEqualToString:@"clipArt"]){
                NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"clipArtList" ofType:@"plist"];
                NSDictionary *clipArtDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
                
                if([clipArtDict objectForKey:[imageName lastPathComponent]] != nil){
                    [array addObject:imageName];
                }
            }
        }
        
    }

    return array;
}

#pragma mark default

-(NSString *)HTMLOneAttributeStringWithTagArray:(NSArray *)tagArray{
    NSMutableString *code = [NSMutableString string];
    for (NSString *key in tagArray) {
        [code appendFormat:@"%@ ", key];
        
    }
    [code trim];
    return code;
}


-(IUCSSUnit)unitWithBool:(BOOL)value{
    if(value){
        return IUCSSUnitPercent;
    }
    else{
        return IUCSSUnitPixel;
    }
}


- (NSString *)imagePathWithImageName:(NSString *)imageName isEdit:(BOOL)isEdit{
    NSString *imgSrc;
    if ([imageName isHTTPURL]) {
        return imageName;
    }
    //clipart
    //path : clipart/arrow_right.png
    else if([[imageName pathComponents][0] isEqualToString:@"clipArt"]){
        if(isEdit){
            imgSrc = [[NSBundle mainBundle] pathForImageResource:[imageName lastPathComponent]];
        }
        else{
            if(_rule == IUCompileRuleDjango){
                imgSrc = [@"/resource/" stringByAppendingString:imageName];
            }
            else{
                imgSrc = [@"resource/" stringByAppendingString:imageName];
            }
        }
    }
    else {
        
        IUResourceFile *file = [self.resourceManager resourceFileWithName:imageName];
        if(file){
            if(_rule == IUCompileRuleDjango && isEdit == NO){
                imgSrc = [@"/" stringByAppendingString:[file relativePath]];
            }
            else{
                imgSrc = [file relativePath];
            }
        }
        
    }
    return imgSrc;
}

- (JDCode *)javascriptHeaderForProject:(IUProject *)project isEdit:(BOOL)isEdit{
    JDCode *code = [[JDCode alloc] init];
    if(isEdit){
        for(NSString *filename in project.defaultEditorJSArray){
            NSString *jsPath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
            [code addCodeWithFormat:@"<script type=\"text/javascript\" src=\"%@\"></script>", jsPath];
        }
     
    }
    else{
        for(NSString *filename in project.defaultOutputJSArray){
            [code addCodeWithFormat:@"<script type=\"text/javascript\" src=\"resource/js/%@\"></script>", filename];
        }
    }
    return code;
}

- (JDCode *)cssHeaderForSheet:(IUSheet *)sheet isEdit:(BOOL)isEdit{
    IUProject *project = sheet.project;
    JDCode *code = [[JDCode alloc] init];
    if(isEdit){
        for(NSString *filename in project.defaultEditorCSSArray){
            NSString *cssPath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
            [code addCodeWithFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"%@\">", cssPath];
        }
        
    }
    else{
        for(NSString *filename in project.defaultOutputCSSArray){
            [code addCodeWithFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"resource/css/%@\">", filename];
        }
        [code addCodeWithFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"resource/css/%@.css\">", sheet.name];

    }
    return code;
}


#pragma mark - output body source
- (NSString *)outputCSSSource:(IUSheet*)sheet mqSizeArray:(NSArray *)mqSizeArray{
    //change css
    JDCode *cssCode = [self cssSource:sheet cssSizeArray:mqSizeArray isEdit:NO];
    
    if(_rule == IUCompileRuleDefault){
        [cssCode replaceCodeString:@"\"resource/" toCodeString:@"../"];
        [cssCode replaceCodeString:@"./resource/" toCodeString:@"../"];
        [cssCode replaceCodeString:@"('resource/" toCodeString:@"('../"];
    }
    else if (_rule == IUCompileRuleDjango) {
        [cssCode replaceCodeString:@"\"resource/" toCodeString:@"\"/resource/"];
        [cssCode replaceCodeString:@"./resource/" toCodeString:@"/resource/"];
        [cssCode replaceCodeString:@"('resource/" toCodeString:@"('/resource/"];
    }
    else if (_rule == IUCompileRuleWordpress) {
        [cssCode replaceCodeString:@"\"resource/" toCodeString:@"\"<?php bloginfo('template_url'); ?>/resource/"];
        [cssCode replaceCodeString:@"./resource/" toCodeString:@"<?php bloginfo('template_url'); ?>/resource/"];
        [cssCode replaceCodeString:@"('resource/" toCodeString:@"('<?php bloginfo('template_url'); ?>/resource/"];
    }
    
    return cssCode.string;
}


-(NSString*)outputHTMLSource:(IUSheet*)sheet{
    if ([sheet isKindOfClass:[IUClass class]]) {
        return [self outputHTML:sheet].string;
    }
    NSString *templateFilePath = [[NSBundle mainBundle] pathForResource:@"webTemplate" ofType:@"html"];
    
    JDCode *sourceCode = [[JDCode alloc] initWithCodeString: [NSString stringWithContentsOfFile:templateFilePath encoding:NSUTF8StringEncoding error:nil]];

    //replace metadata;
    if([sheet isKindOfClass:[IUPage class]]){
        JDCode *metaCode = [self metadataSource:(IUPage *)sheet];
        [sourceCode replaceCodeString:@"<!--METADATA_Insert-->" toCode:metaCode];
        
        JDCode *webFontCode = [self webfontImportSourceForOutput:(IUPage *)sheet];
        [sourceCode replaceCodeString:@"<!--WEBFONT_Insert-->" toCode:webFontCode];

        JDCode *jsCode = [self javascriptHeaderForProject:sheet.project isEdit:NO];
        [sourceCode replaceCodeString:@"<!--JAVASCRIPT_Insert-->" toCode:jsCode];
        
        
        JDCode *iuCSS = [self cssHeaderForSheet:sheet isEdit:NO];
        [sourceCode replaceCodeString:@"<!--CSS_Insert-->" toCode:iuCSS];
        
        [sourceCode replaceCodeString:@"<!--CSS_Replacement-->" toCodeString:@""];
        
        //change html
        JDCode *htmlCode = [self outputHTML:sheet];
        [sourceCode replaceCodeString:@"<!--HTML_Replacement-->" toCode:htmlCode];
        
        JDSectionInfoLog( IULogSource, @"source : %@", [@"\n" stringByAppendingString:sourceCode.string]);
        
        if (_rule == IUCompileRuleDjango) {
            [sourceCode replaceCodeString:@"\"resource/" toCodeString:@"\"/resource/"];
            [sourceCode replaceCodeString:@"./resource/" toCodeString:@"/resource/"];
            [sourceCode replaceCodeString:@"('resource/" toCodeString:@"('/resource/"];
        }
        if (_rule == IUCompileRuleWordpress) {
            [sourceCode replaceCodeString:@"\"resource/" toCodeString:@"\"<?php bloginfo('template_url'); ?>/resource/"];
            [sourceCode replaceCodeString:@"./resource/" toCodeString:@"<?php bloginfo('template_url'); ?>/resource/"];
            [sourceCode replaceCodeString:@"('resource/" toCodeString:@"('<?php bloginfo('template_url'); ?>/resource/"];
        }
    }
    
    
    return sourceCode.string;
}



-(JDCode*)outputHTMLAsBox:(IUBox*)iu option:(NSDictionary*)option{
    NSString *tag = @"div";
    if ([iu isKindOfClass:[PGForm class]]) {
        tag = @"form";
    }
    else if (iu.textType == IUTextTypeH1){
        tag = @"h1";
    }
    else if (iu.textType == IUTextTypeH2){
        tag = @"h2";
    }
    JDCode *code = [[JDCode alloc] init];
    if ([iu.pgVisibleConditionVariable length] && _rule == IUCompileRuleDjango) {
        [code addCodeLineWithFormat:@"{%%if %@%%}", iu.pgVisibleConditionVariable];
    }
    
    
    [code addCodeLineWithFormat:@"<%@ %@>", tag, [self HTMLAttributes:iu option:nil isEdit:NO]];
    if ( self.rule == IUCompileRuleDjango && [iu isKindOfClass:[PGForm class]]) {
        [code addCodeLine:@"{% csrf_token %}"];
    }
    
    
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
    if (self.rule == IUCompileRuleDjango && iu.pgContentVariable) {
        if ([iu.sheet isKindOfClass:[IUClass class]]) {
            [code addCodeLineWithFormat:@"<p>{{object.%@|linebreaksbr}}</p>", iu.pgContentVariable];
        }
        else {
            [code addCodeLineWithFormat:@"<p>{{%@|linebreaksbr}}</p>", iu.pgContentVariable];
        }
    }
    else if(iu.text && iu.text.length > 0){
        NSString *htmlText = [iu.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        htmlText = [htmlText stringByReplacingOccurrencesOfString:@"  " withString:@" &nbsp;"];
        [code addCodeLineWithFormat:@"<p>%@</p>",htmlText];
    }
    
    
#endif
    if (iu.children.count) {
        for (IUBox *child in iu.children) {
            [code addCode:[self outputHTML:child]];
        }
    }
    [code addCodeLineWithFormat:@"</%@>", tag];
    if ([iu.pgVisibleConditionVariable length] && _rule == IUCompileRuleDjango) {
        [code addCodeLine:@"{% endif %}"];
    }
    return code;
}

-(JDCode *)outputHTML:(IUBox *)iu{
    JDCode *code = [[JDCode alloc] init];
#pragma mark IUBox
    if ([iu conformsToProtocol:@protocol(IUCodeProtocol)]) {
        NSObject <IUCodeProtocol>* iuCode = (id)iu;
        [code addCodeWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:NO]];
        if ([iuCode respondsToSelector:@selector(prefixCode)]) {
            [code addCodeWithFormat:[iuCode prefixCode]];
        }
        if ([iuCode respondsToSelector:@selector(code)]) {
            [code addCodeWithFormat:[iuCode code]];
        }
        if (iu.children.count) {
            for (IUBox *child in iu.children) {
                [code addCode:[self outputHTML:child]];
            }
        }
        if ([iuCode respondsToSelector:@selector(postfixCode)]) {
            [code addCodeWithFormat:[iuCode postfixCode]];
        }
        [code addCodeLine:@"</div>"];
    }
#pragma mark IUPage
    else if ([iu isKindOfClass:[IUPage class]]) {
        IUPage *page = (IUPage*)iu;
        if (page.background) {
            [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:NO]];
            for (IUBox *obj in page.background.children) {
                [code addCode:[self outputHTML:obj]];
            }
            if (iu.children.count) {
                [code increaseIndentLevelForEdit];
                for (IUBox *child in iu.children) {
                    if (child == page.background) {
                        continue;
                    }
                    [code addCode:[self outputHTML:child]];
                }
                [code decreaseIndentLevelForEdit];
            }
            [code addCodeLine:@"</div>"];
        }
        else {
            [code addCode:[self outputHTMLAsBox:iu option:nil]];
        }
    }
#pragma mark IUMenuBar
    else if([iu isKindOfClass:[IUMenuBar class]]){
        IUMenuBar *menuBar =(IUMenuBar *)iu;
        [code addCodeLineWithFormat:@"<div %@>", [self HTMLAttributes:menuBar option:nil isEdit:NO]];
        NSString *title = menuBar.mobileTitle;
        if(title == nil){
            title = @"MENU";
        }
        [code addCodeLineWithFormat:@"<div class=\"mobile-button\">%@<div class='menu-top'></div><div class='menu-bottom'></div></div>", title];
        
        if(menuBar.children.count > 0){
            [code increaseIndentLevelForEdit];
            [code addCodeLine:@"<ul>"];
            
            [code increaseIndentLevelForEdit];
            for (IUBox *child in menuBar.children){
                [code addCode:[self outputHTML:child]];
            }
            [code decreaseIndentLevelForEdit];
            [code addCodeLine:@"</ul>"];
            [code decreaseIndentLevelForEdit];
        }
        
        [code addCodeLine:@"</div>"];
        
    }
#pragma mark IUMenuItem
    else if([iu isKindOfClass:[IUMenuItem class]]){
        IUMenuItem *menuItem = (IUMenuItem *)iu;
        [code addCodeLineWithFormat:@"<li %@>", [self HTMLAttributes:menuItem option:nil isEdit:NO]];
        [code increaseIndentLevelForEdit];

        if(menuItem.link){
            [code addCodeLineWithFormat:@"%@%@</a>", [self linkHeaderString:menuItem], menuItem.text];
        }
        else{
            [code addCodeLineWithFormat:@"<a href='#'>%@</a>", menuItem.text];
        }
        if(menuItem.children.count > 0){
            [code addCodeLine:@"<div class='closure'></div>"];
            [code addCodeLine:@"<ul>"];
            [code increaseIndentLevelForEdit];
            for(IUBox *child in menuItem.children){
                [code addCode:[self outputHTML:child]];
            }
            [code decreaseIndentLevelForEdit];
            [code addCodeLine:@"</ul>"];
        }
        
        [code decreaseIndentLevelForEdit];
        [code addCodeLine:@"</li>"];
        
    }
#pragma mark IUCollection
    else if ([iu isKindOfClass:[IUCollection class]]){
        IUCollection *iuCollection = (IUCollection*)iu;
        if (_rule == IUCompileRuleDjango ) {
            [code addCodeLineWithFormat:@"<div %@>", [self HTMLAttributes:iuCollection option:nil isEdit:NO]];
            [code addCodeLineWithFormat:@"    {%% for object in %@ %%}", iuCollection.collectionVariable];
            [code addCodeLineWithFormat:@"        {%% include '%@.html' %%}", iuCollection.prototypeClass.name];
            [code addCodeLine:@"    {% endfor %}"];
            [code addCodeLineWithFormat:@"</div>"];
        }
        else {
            [code addCode:[self outputHTMLAsBox:iuCollection option:nil]];
        }
    }
#pragma mark IUCarousel
    else if([iu isKindOfClass:[IUCarousel class]]){
        IUCarousel *carousel = (IUCarousel *)iu;
        [code addCodeLineWithFormat:@"<div %@>", [self HTMLAttributes:iu option:nil isEdit:NO]];
        //carousel item
        [code addCodeLineWithFormat:@"<div class='wrapper' id='wrapper_%@'>", iu.htmlID];
        for(IUItem *item in iu.children){
            [code addCode:[self outputHTML:item]];
        }
        [code addCodeLine:@"</div>"];
        
        //control
        if(carousel.disableArrowControl == NO){
            [code addCodeLine:@"<div class='Next'></div>"];
            [code addCodeLine:@"<div class='Prev'></div>"];
        }
        
        if(carousel.controlType == IUCarouselControlBottom){
            [code addCodeLine:@"<ul class='Pager'>"];
            [code increaseIndentLevelForEdit];
            for(int i=0; i<iu.children.count; i++){
                [code addCodeLine:@"<li></li>"];
            }
            [code decreaseIndentLevelForEdit];
            [code addCodeLine:@"</ul>"];
        }
        
        [code addCodeLine:@"</div>"];
    }
#pragma mark IUMovie
    else if([iu isKindOfClass:[IUMovie class]]){
        NSDictionary *option = [NSDictionary dictionaryWithObject:@(NO) forKey:@"editor"];
        [code addCodeLineWithFormat:@"<video %@>", [self HTMLAttributes:iu option:option isEdit:NO]];
        
        if(((IUMovie *)iu).videoPath){
            NSMutableString *compatibilitySrc = [NSMutableString stringWithString:@"\
                                                 <source src=\"$moviename$\" type=\"video/$type$\">\n\
                                                 <object data=\"$moviename$\" width=\"100%\" height=\"100%\">\n\
                                                 <embed width=\"100%\" height=\"100%\" src=\"$moviename$\">\n\
                                                 </object>"];
            
            [compatibilitySrc replaceOccurrencesOfString:@"$moviename$" withString:((IUMovie *)iu).videoPath options:0 range:NSMakeRange(0, compatibilitySrc.length)];
            [compatibilitySrc replaceOccurrencesOfString:@"$type$" withString:((IUMovie *)iu).videoPath.pathExtension options:0 range:NSMakeRange(0, compatibilitySrc.length)];
            
            [code addCodeLine:compatibilitySrc];
        }
        if( ((IUMovie *)iu).altText){
            [code addCodeLine:((IUMovie *)iu).altText];
        }
        
        [code addCodeLine:@"</video>"];
    }
#pragma mark IUImage
    else if([iu isKindOfClass:[IUImage class]]){
        [code addCodeLineWithFormat:@"<img %@ >", [self HTMLAttributes:iu option:nil isEdit:NO]];
    }

#pragma mark IUHTML
    else if([iu isKindOfClass:[IUHTML class]]){
        [code addCodeLineWithFormat:@"<div %@>", [self HTMLAttributes:iu option:nil isEdit:NO]];
        if(((IUHTML *)iu).hasInnerHTML){
            [code addCodeLine:((IUHTML *)iu).innerHTML];
        }
        if (iu.children.count) {
            for (IUBox *child in iu.children) {
                [code addCode:[self outputHTML:child]];
            }
        }
        [code addCodeLineWithFormat:@"</div>"];
        
    }
#pragma mark PGPageLinkSet
    
    else if ([iu isKindOfClass:[PGPageLinkSet class]]){
        [code addCodeLineWithFormat:@"<div %@>\n", [self HTMLAttributes:iu option:nil isEdit:NO]];
        [code addCodeLine:@"    <div>"];
        [code addCodeLine:@"    <ul>"];
        [code addCodeLineWithFormat:@"        {%% for i in %@ %%}", [(PGPageLinkSet *)iu pageCountVariable]];

        NSString *linkStr;
        if([iu.link isKindOfClass:[IUBox class]]){
            linkStr = [((IUBox *)iu.link).htmlID lowercaseString];
        }
        if(linkStr){
            [code addCodeLineWithFormat:@"        <a href=/%@/{{i}}>", linkStr];
            [code addCodeLine:@"            <li> {{i}} </li>"];
            [code addCodeLine:@"        </a>"];
        }
        [code addCodeLine:@"        {% endfor %}"];
        [code addCodeLine:@"    </ul>"];
        [code addCodeLine:@"    </div>"];
        [code addCodeLine:@"</div>"];
    }
#pragma mark IUImport
    else if([iu isKindOfClass:[IUImport class]]){
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:NO]];
        if (iu.children.count) {
            for (IUBox *child in iu.children) {
                [code addCode:[self outputHTML:child]];
            }
        }
        [code addCodeLineWithFormat:@"</div>"];
        
    }
#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
#pragma mark IUText
    else if([iu isKindOfClass:[IUText class]]){
        IUText *textIU = (IUText *)iu;
        if (_rule == IUCompileRuleDjango && iu.textVariable) {
            JDCode *outputCode = [self outputHTMLAsBox:iu option:nil];
            [code addCode:outputCode];
        }
        else{
            [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:NO]];
            if (self.rule == IUCompileRuleDjango && textIU.pgContentVariable) {
                if ([iu.sheet isKindOfClass:[IUClass class]]) {
                    [code addCodeLineWithFormat:@"{{object.%@}}", textIU.pgContentVariable];
                }
                else {
                    [code addCodeLineWithFormat:@"{{%@}}", textIU.pgContentVariable];
                }
            }
            else if (textIU.textHTML) {
                [code addCodeLine:textIU.textHTML];
            }
            [code addCodeLine:@"</div>"];
        }
        
    }
#endif
#pragma mark IUTextFeild
    
    else if ([iu isKindOfClass:[PGTextField class]]){
        [code addCodeLineWithFormat:@"<input %@ >", [self HTMLAttributes:iu option:nil isEdit:NO]];
    }
    
#pragma mark PGTextView
    
    else if ([iu isKindOfClass:[PGTextView class]]){
        NSString *inputValue = [[(PGTextView *)iu inputValue] length] ? [(PGTextView *)iu inputValue] : @"";
        [code addCodeLineWithFormat:@"<textarea %@ >%@</textarea>", [self HTMLAttributes:iu option:nil isEdit:NO], inputValue];
    }
    
    else if ([iu isKindOfClass:[PGForm class]]){
        [code addCode:[self outputHTMLAsBox:iu option:nil]];
    }
    else if ([iu isKindOfClass:[PGSubmitButton class]]){
        [code addCodeLineWithFormat:@"<input %@ >", [self HTMLAttributes:iu option:nil isEdit:NO]];
    }
    
    
#pragma mark IUBox
    else if ([iu isKindOfClass:[IUBox class]]) {
        JDCode *outputCode = [self outputHTMLAsBox:iu option:nil];
        [code addCode:outputCode];
    }
    
    
#pragma mark - link
    if (iu.link && [self hasLink:iu]) {
        NSString *linkStr = [self linkHeaderString:iu];
        [code wrapTextWithStartString:linkStr endString:@"</a>"];
    }
    return code;
    
}

#pragma mark - link Header

- (BOOL)hasLink:(IUBox *)iu{
    if([iu isKindOfClass:[PGPageLinkSet class]]
       || [iu isKindOfClass:[IUMenuBar class]]
       || [iu isKindOfClass:[IUMenuItem class]]){
        return NO;
    }
    
    return YES;
}

- (NSString *)linkHeaderString:(IUBox *)iu{
    
    //find link url
    NSString *linkStr;
    if([iu.link isKindOfClass:[NSString class]]){
        linkStr = iu.link;
    }
    else if([iu.link isKindOfClass:[IUBox class]]){
        linkStr = [((IUBox *)iu.link).htmlID lowercaseString];
    }
    NSString *linkURL = linkStr;
    if ([linkStr isHTTPURL] == NO) {
        if (_rule == IUCompileRuleDjango) {
            if(iu.divLink){
                linkURL = [NSString stringWithFormat:@"/%@#%@", linkStr , ((IUBox *)iu.divLink).htmlID];
            }
            else{
                linkURL = [NSString stringWithFormat:@"/%@", linkStr];
            }
        }
        else {
            if(iu.divLink){
                linkURL = [NSString stringWithFormat:@"./%@.html#%@", linkStr, ((IUBox *)iu.divLink).htmlID];
            }
            else{
                linkURL = [NSString stringWithFormat:@"./%@.html", linkStr];
            }
        }
    }
    
    
    //make a tag
    NSString *str;
    if(iu.linkTarget){
        str = [NSString stringWithFormat:@"<a href='%@' target='_blank'>", linkURL];
    }
    else{
        str = [NSString stringWithFormat:@"<a href='%@'>", linkURL];
    }
    
    return str;
}



#pragma mark - editor body source

-(NSString*)editorSource:(IUSheet*)document mqSizeArray:(NSArray *)mqSizeArray{
    NSString *templateFilePath = [[NSBundle mainBundle] pathForResource:@"webTemplate" ofType:@"html"];
    
    
    NSMutableString *sourceString = [NSMutableString stringWithContentsOfFile:templateFilePath encoding:NSUTF8StringEncoding error:nil];
    
    JDCode *sourceCode = [[JDCode alloc] initWithCodeString:sourceString];
    
    
    JDCode *webFontCode = [self webfontImportSourceForEdit];
    [sourceCode replaceCodeString:@"<!--WEBFONT_Insert-->" toCode:webFontCode];
    
    JDCode *jsCode = [self javascriptHeaderForProject:document.project isEdit:YES];
    [sourceCode replaceCodeString:@"<!--JAVASCRIPT_Insert-->" toCode:jsCode];
    
    
    JDCode *iuCSS = [self cssHeaderForSheet:document isEdit:YES];
    [sourceCode replaceCodeString:@"<!--CSS_Insert-->" toCode:iuCSS];
    
    JDCode *cssCode = [self cssSource:document cssSizeArray:mqSizeArray isEdit:YES];
    [sourceCode replaceCodeString:@"<!--CSS_Replacement-->" toCode:cssCode];
    
    //change html
    JDCode *htmlCode = [self editorHTML:document];
    [sourceCode replaceCodeString:@"<!--HTML_Replacement-->" toCode:htmlCode];
    

    
    JDSectionInfoLog( IULogSource, @"source : %@", [@"\n" stringByAppendingString:sourceCode.string]);

    return sourceCode.string;
}



- (JDCode*)editorHTMLAsBOX:(IUBox *)iu{
    JDCode *code = [[JDCode alloc] init];
    [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
    if(iu.text && iu.text.length > 0){
        NSString *htmlText = [iu.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        htmlText = [htmlText stringByReplacingOccurrencesOfString:@"  " withString:@" &nbsp;"];
        [code addCodeLineWithFormat:@"<p>%@</p>",htmlText];
    }
#endif
    if (iu.children.count) {
        for (IUBox *child in iu.children) {
            [code addCode:[self editorHTML:child]];
        }
    }
    [code addCodeLineWithFormat:@"</div>"];
    return code;
}

-(JDCode *)editorHTML:(IUBox*)iu{
    JDCode *code = [[JDCode alloc] init];
#pragma mark IUPage
    if ([iu isKindOfClass:[IUPage class]]) {
        IUPage *page = (IUPage*)iu;
        if (page.background) {
            [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
            for (IUBox *obj in page.background.children) {
                [code increaseIndentLevelForEdit];
                [code addCode:[self editorHTML:obj]];
                [code decreaseIndentLevelForEdit];
            }
            if (iu.children.count) {
                for (IUBox *child in iu.children) {
                    if (child == page.background) {
                        continue;
                    }
                    [code increaseIndentLevelForEdit];
                    [code addCode:[self editorHTML:child]];
                    [code decreaseIndentLevelForEdit];
                }
            }
            [code addCodeLine:@"</div>"];
        }
        else {
            [code addCode:[self editorHTMLAsBOX:iu]];
        }
    }
    else if ([iu conformsToProtocol:@protocol(IUSampleHTMLProtocol) ]){
        IUBox <IUSampleHTMLProtocol> *sampleProtocolIU = (id)iu;
        NSString *sampleHTML = [sampleProtocolIU sampleHTML];
        [code addCodeLineWithFormat:@"<div %@ >%@</div>", [self HTMLAttributes:iu option:nil isEdit:YES], sampleHTML];
    }
    
#pragma mark IUMenuBar
    else if([iu isKindOfClass:[IUMenuBar class]]){
        IUMenuBar *menuBar =(IUMenuBar *)iu;
        [code addCodeLineWithFormat:@"<div %@>", [self HTMLAttributes:menuBar option:nil isEdit:NO]];
        NSString *title = menuBar.mobileTitle;
        if(title == nil){
            title = @"MENU";
        }
        [code addCodeLineWithFormat:@"<div class=\"mobile-button\">%@<div class='menu-top'></div><div class='menu-bottom'></div></div>", title];
        
        if(menuBar.children.count > 0){
            [code increaseIndentLevelForEdit];
            [code addCodeLine:@"<ul>"];
            
            [code increaseIndentLevelForEdit];
            for (IUBox *child in menuBar.children){
                [code addCode:[self outputHTML:child]];
            }
            [code decreaseIndentLevelForEdit];
            [code addCodeLine:@"</ul>"];
            [code decreaseIndentLevelForEdit];
        }
        
        [code addCodeLine:@"</div>"];
        
    }
#pragma mark IUMenuItem
    else if([iu isKindOfClass:[IUMenuItem class]]){
        IUMenuItem *menuItem = (IUMenuItem *)iu;
        [code addCodeLineWithFormat:@"<li %@>", [self HTMLAttributes:menuItem option:nil isEdit:NO]];
        [code increaseIndentLevelForEdit];
        
        if(menuItem.link){
            [code addCodeLineWithFormat:@"%@%@</a>", [self linkHeaderString:menuItem], menuItem.text];
        }
        else{
            [code addCodeLineWithFormat:@"<a href='#'>%@</a>", menuItem.text];
        }
        if(menuItem.children.count > 0){
            [code addCodeLine:@"<div class='closure'></div>"];
            [code addCodeLine:@"<ul>"];
            [code increaseIndentLevelForEdit];
            for(IUBox *child in menuItem.children){
                [code addCode:[self outputHTML:child]];
            }
            [code decreaseIndentLevelForEdit];
            [code addCodeLine:@"</ul>"];
        }
        
        [code decreaseIndentLevelForEdit];
        [code addCodeLine:@"</li>"];
        
    }
#pragma mark IUCarousel
    else if([iu isKindOfClass:[IUCarousel class]]){
        IUCarousel *carousel = (IUCarousel *)iu;
        [code addCodeLineWithFormat:@"<div %@>", [self HTMLAttributes:carousel option:nil isEdit:YES]];
        //carousel item
        for(IUCarouselItem *item in iu.children){
            [code addCode:[self editorHTML:item]];
        }        
        //control
        if(carousel.disableArrowControl == NO){
            [code addCodeLine:@"<div class='Next'></div>"];
            [code addCodeLine:@"<div class='Prev'></div>"];
        }
        if(carousel.controlType == IUCarouselControlBottom){
            [code addCodeLine:@"<ul class='Pager'>"];
            [code increaseIndentLevelForEdit];
            for(IUCarouselItem *item in iu.children){
                if(item.isActive){
                    [code addCodeLine:@"<li class='active'></li>"];
                }
                else{
                    [code addCodeLine:@"<li></li>"];
                }
            }
            [code decreaseIndentLevelForEdit];
            [code addCodeLine:@"</ul>"];
        }
        
        [code addCodeLine:@"</div>"];
    }
#pragma mark IUImage
    else if([iu isKindOfClass:[IUImage class]]){
        IUImage *iuImage = (IUImage *)iu;
        if(iuImage.imageName){
            [code addCodeLineWithFormat:@"<img %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
        }
        //editor mode에서는 default image 를 만들어줌
        else{
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"image_default" ofType:@"png"];
            [code addCodeLineWithFormat:@"<img %@ src='%@' >",  [self HTMLAttributes:iu option:nil isEdit:YES], imagePath];
            
        }
    }
#pragma mark IUMovie
    else if([iu isKindOfClass:[IUMovie class]]){
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:@[@(1)] forKey:@[@"editor"]];
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:dict isEdit:YES]];
        
        IUMovie *iuMovie = (IUMovie *)iu;
        
        NSString *thumbnailPath;
        if(iuMovie.videoPath && iuMovie.posterPath){
            thumbnailPath = [NSString stringWithString:iuMovie.posterPath];
        }
        else{
            thumbnailPath = [[NSBundle mainBundle] pathForResource:@"video_bg" ofType:@"png"];
        }
        
        [code addCodeLineWithFormat:@"<div style=\"background-image:url('%@');\
         background-size:contain;\
         background-repeat:no-repeat; \
         background-position:center; \
         width:100%%; height:100%%; \
         position:absolute; left:0; top:0\"></div>", thumbnailPath];
        
        
        NSString *videoPlayImagePath = [[NSBundle mainBundle] pathForResource:@"video_play" ofType:@"png"];
        [code addCodeLineWithFormat:@"<div style=\"background-image:url('%@'); \
         background-size:20%%;\
         background-repeat:no-repeat; \
         background-position:center; \
         position:absolute;  width:100%%; height:100%%; \"></div>", videoPlayImagePath];
        
        [code addCodeLine:@"</div>"];
        
    }
#pragma mark IUWebMovie
    else if([iu isKindOfClass:[IUWebMovie class]]){
        IUWebMovie *iuWebMovie = (IUWebMovie *)iu;
        
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
        NSString *thumbnailPath;
        if(iuWebMovie.thumbnail){
            thumbnailPath = [NSString stringWithString:iuWebMovie.thumbnailPath];
        }
        else{
            thumbnailPath = [[NSBundle mainBundle] pathForResource:@"video_bg" ofType:@"png"];
        }
        
        [code addCodeLineWithFormat:@"<img src = \"%@\" width='100%%' height='100%%' style='position:absolute; left:0; top:0'>", thumbnailPath];
        
        NSString *videoPlayImagePath = [[NSBundle mainBundle] pathForResource:@"video_play" ofType:@"png"];
        [code addCodeLineWithFormat:@"<div style=\"background-image:url('%@'); \
         background-size:20%%;\
         background-repeat:no-repeat; \
         background-position:center; \
         position:absolute;  width:100%%; height:100%%; \"></div>", videoPlayImagePath];
        
        [code addCodeLine:@"</div>"];
        
    }
#pragma mark IUFBLike
    else if([iu isKindOfClass:[IUFBLike class]]){
        
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
        
        NSString *fbPath = [[NSBundle mainBundle] pathForResource:@"FBSampleImage" ofType:@"png"];
        NSString *editorHTML = [NSString stringWithFormat:@"<img src=\"%@\" align=\"middle\" style=\"float:left;margin:0 5px 0 0; \" ><p style=\"font-size:11px ; font-family:'Helvetica Neue', Helvetica, Arial, 'lucida grande',tahoma,verdana,arial,sans-serif\">263,929 people like this. Be the first of your friends.</p>", fbPath];
        [code addCodeLine:editorHTML];
        
        [code addCodeLine:@"</div>"];
    }
#pragma mark IUTweetButton
    else if([iu isKindOfClass:[IUTweetButton class]]){
        IUTweetButton *tweet = (IUTweetButton *)iu;
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
        
        NSString *imageName;
        switch (tweet.countType) {
            case IUTweetButtonCountTypeVertical:
                imageName = @"ttwidgetVertical";
                break;
            case IUTweetButtonCountTypeHorizontal:
                if(tweet.sizeType == IUTweetButtonSizeTypeLarge){
                    imageName = @"ttwidgetLargeHorizontal";
                }
                else{
                    imageName = @"ttwidgetHorizontal";
                }
                break;
            case IUTweetButtonCountTypeNone:
                if(tweet.sizeType == IUTweetButtonSizeTypeLarge){
                    imageName = @"ttwidgetLargeNone";
                }
                else{
                    imageName = @"ttwidgetNone";
                }
        }
        
        NSString *imagePath = [[NSBundle mainBundle] pathForImageResource:imageName];
        NSString *innerHTML = [NSString stringWithFormat:@"<img src=\"%@\" style=\"width:100%%; height:100%%\"></imbc>", imagePath];
        
        [code addCodeLine:innerHTML];
        [code addCodeLine:@"</div>"];

    }
#pragma mark IUHTML
    else if([iu isKindOfClass:[IUHTML class]]){
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
        if(((IUHTML *)iu).hasInnerHTML){
            [code addCodeLine:((IUHTML *)iu).innerHTML];
        }
        if (iu.children.count) {
            
            for (IUBox *child in iu.children) {
                [code addCode:[self editorHTML:child]];
            }
        }
        [code addCodeLineWithFormat:@"</div>"];
        
    }
#pragma mark PGPageLinkSet
    else if ([iu isKindOfClass:[PGPageLinkSet class]]){

        [code addCodeLineWithFormat:@"<div %@>\n", [self HTMLAttributes:iu option:nil isEdit:YES]];
        [code addCodeLineWithFormat:@"    <div class='IUPageLinkSetClip'>\n"];
        [code addCodeLineWithFormat:@"       <ul>\n"];
        [code addCodeLineWithFormat:@"           <a><li>1</li></a><a><li>2</li></a><a><li>3</li></a>"];
        [code addCodeLineWithFormat:@"       </div>"];
        [code addCodeLineWithFormat:@"    </div>"];
        [code addCodeLineWithFormat:@"</div"];
    }
#pragma mark IUText
#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
    else if([iu isKindOfClass:[IUText class]]){
        IUText *textIU = (IUText *)iu;
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
        if (textIU.textHTML) {
            [code addCodeLineWithFormat:textIU.textHTML];
            
        }
        [code addCodeLineWithFormat:@"</div>"];
        
    }
#endif
#pragma mark IUTextFeild
    
    else if ([iu isKindOfClass:[PGTextField class]]){
        [code addCodeLineWithFormat:@"<input %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
    }
    
#pragma mark PGTextView
    
    else if ([iu isKindOfClass:[PGTextView class]]){
        NSString *inputValue = [[(PGTextView *)iu inputValue] length] ? [(PGTextView *)iu inputValue] : @"";
        [code addCodeLineWithFormat:@"<textarea %@ >%@</textarea>", [self HTMLAttributes:iu option:nil isEdit:YES], inputValue];
    }
    
#pragma mark IUImport
    else if ([iu isKindOfClass:[IUImport class]]) {
        //add prefix, <ImportedBy_[IUName]_ to all id html (including chilren)
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
        JDCode *importCode = [self editorHTML:[(IUImport*)iu prototypeClass]];
        NSString *idReplacementString = [NSString stringWithFormat:@" id=ImportedBy_%@_", iu.htmlID];
        [importCode replaceCodeString:@" id=" toCodeString:idReplacementString];
        [code addCode:importCode];
        [code addCodeLine:@"</div>"];
    }
    
#pragma mark PGSubmitButton
    else if ([iu isKindOfClass:[PGSubmitButton class]]){
        [code addCodeLineWithFormat:@"<input %@ >", [self HTMLAttributes:iu option:nil isEdit:YES]];
    }
    
#pragma mark IUBox
    else if ([iu isKindOfClass:[IUBox class]]) {
        [code addCode:[self editorHTMLAsBOX:iu]];
    }
    
    return code;
}


#pragma mark - HTML Attributes

- (NSString*)HTMLAttributes:(IUBox*)iu option:(NSDictionary*)option isEdit:(BOOL)isEdit{
    NSMutableString *retString = [NSMutableString string];
    [retString appendFormat:@"id=%@", iu.htmlID];
    
    NSArray *classPedigree = [[iu class] classPedigreeTo:[IUBox class]];
    NSMutableString *className = [NSMutableString string];
    for (NSString *str in classPedigree) {
        [className appendString:str];
        [className appendString:@" "];
    }
    [className appendFormat:@" %@", iu.htmlID];
    
#pragma mark IUCarouselItem
    if([iu isKindOfClass:[IUCarouselItem class]]){
        if(isEdit && ((IUCarouselItem *)iu).isActive){
            [className appendString:@" active"];
        }
    }
#pragma mark IUMenuBar, IUMenuItem
    else if([iu isKindOfClass:[IUMenuBar class]] ||
            [iu isKindOfClass:[IUMenuItem class]]){
        if(iu.children.count >0){
            [className appendString:@" has-sub"];
        }
        
        if([iu isKindOfClass:[IUMenuBar class]]){
            IUMenuBar *menuBar = (IUMenuBar *)iu;
            if(menuBar.align == IUAlignCenter){
                [className appendString:@" align-center"];
            }
            else if(menuBar.align == IUAlignRight){
                [className appendString:@" align-right"];
            }
        }
    }
    [className trim];
    [retString appendFormat:@" class='%@'", className];
    
    if(isEdit && iu.shouldAddIUByUserInput) {
        [retString appendString:@" hasChildren"];
    }
    
    if (iu.positionType == IUPositionTypeAbsoluteCenter || iu.positionType == IUPositionTypeRelativeCenter) {
        [retString appendString:@" horizontalCenter='1'"];
    }
    if (iu.opacityMove) {
        [retString appendFormat:@" opacityMove='%.1f'", iu.opacityMove];
    }
    if (iu.xPosMove) {
        [retString appendFormat:@" xPosMove='%.1f'", iu.xPosMove];
    }
    id value = [iu.css tagDictionaryForViewport:IUCSSDefaultViewPort][IUCSSTagImage];
    if([value isDjangoVariable] && _rule == IUCompileRuleDjango){
        [retString appendFormat:@" style='background-image:url(%@)'", value];
    }
    
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
    if([iu shouldCompileFontInfo]){
        if(iu.lineHeightAuto){
            [retString appendString:@" autoLineHeight='1'"];
        }
    }
#else
#pragma mark IUText
    if( [iu isKindOfClass:[IUText class]] ){
        if(((IUText *)iu).lineHeightAuto){
            [retString appendString:@" autoLineHeight='1'"];
        }
        
    }
#endif
    
#pragma mark IUImage
    if ([iu isKindOfClass:[IUImage class]]) {
        IUImage *iuImage = (IUImage*)iu;
        if (iuImage.pgContentVariable && _rule == IUCompileRuleDjango) {
            if ([iu.sheet isKindOfClass:[IUClass class]]) {
                [retString appendFormat:@" src={{ object.%@ }}", iuImage.pgContentVariable];
            }
            else {
                [retString appendFormat:@" src={{ %@ }}", iuImage.pgContentVariable];
            }
        }else{
            //image tag attributes
            if(iuImage.imageName){
                NSString *imgSrc = [self imagePathWithImageName:iuImage.imageName isEdit:isEdit];
                [retString appendFormat:@" src='%@'", imgSrc];
            }
            if(iuImage.altText){
                [retString appendFormat:@" alt='%@'", iuImage.altText];
            }
        }
    }
    
#pragma mark IUWebMovie
    else if([iu isKindOfClass:[IUWebMovie class]]){
        IUWebMovie *iuWebMovie = (IUWebMovie *)iu;
        if(iuWebMovie.eventautoplay){
            [retString appendString:@" eventAutoplay='1'"];
            [retString appendFormat:@" videoid='%@'", iuWebMovie.thumbnailID];
            [retString appendFormat:@" videotype='%@'", iuWebMovie.type];
        }
    }
#pragma mark IUMovie
    else if ([iu isKindOfClass:[IUMovie class]]) {
        if(option){
            BOOL editor = [[option objectForKey:@"editor"] boolValue];
            if(editor == NO){
                IUMovie *iuMovie = (IUMovie*)iu;
                if (iuMovie.enableControl) {
                    [retString appendString:@" controls"];
                }
                if (iuMovie.enableLoop) {
                    [retString appendString:@" loop"];
                }
                if (iuMovie.enableMute) {
                    [retString appendString:@" muted"];
                }
                if (iuMovie.enableAutoPlay) {
                    [retString appendString:@" autoplay"];
                }
                if (iuMovie.posterPath) {
                    [retString appendFormat:@" poster=%@", iuMovie.posterPath];
                }
            }
        }
    }
#pragma mark IUCarousel
    else if([iu isKindOfClass:[IUCarousel class]]){
        IUCarousel *carousel = (IUCarousel *)iu;
        if(isEdit == NO && carousel.autoplay){
            if(carousel.timer > 0){
                [retString appendFormat:@" timer='%ld'", carousel.timer*1000];
            }
        }
    }
#pragma mark IUCollection
    else if ([iu isKindOfClass:[IUCollection class]]){
        IUCollection *iuCollection = (IUCollection*)iu;
        
        if(iuCollection.responsiveSetting){
            NSData *data = [NSJSONSerialization dataWithJSONObject:iuCollection.responsiveSetting options:0 error:nil];
            [retString appendFormat:@" responsive=%@ defaultItemCount=%ld",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], iuCollection.defaultItemCount];
        }
    }
#pragma mark PGTextField
    else if ([iu isKindOfClass:[PGTextField class]]){
        PGTextField *pgTextField = (PGTextField *)iu;
        if(pgTextField.inputName){
            [retString appendFormat:@" name=\"%@\"",pgTextField.inputName];
        }
        if(pgTextField.placeholder){
            [retString appendFormat:@" placeholder=\"%@\"",pgTextField.placeholder];
        }
        if(pgTextField.inputValue){
            [retString appendFormat:@" value=\"%@\"",pgTextField.inputValue];
        }
        if(pgTextField.type == IUTextFieldTypePassword){
            [retString appendFormat:@" type=\"password\""];
        }
        else {
            [retString appendString:@" type=\"text\""];
        }
    }
#pragma mark PGSubmitButton
    else if ([iu isKindOfClass:[PGSubmitButton class]]){
        [retString appendFormat:@" type=\"submit\" value=\"%@\"",((PGSubmitButton *)iu).label];
    }
#pragma mark PGForm
    else if ([iu isKindOfClass:[PGForm class]]){
        
        NSString *targetStr;
        if([((PGForm *)iu).target isKindOfClass:[NSString class]]){
            targetStr = ((PGForm *)iu).target;
        }
        else if([((PGForm *)iu).target isKindOfClass:[IUBox class]]){
            targetStr = ((IUBox *)((PGForm *)iu).target).htmlID ;
        }
        
        [retString appendFormat:@" method=\"post\" action=\"%@\"", targetStr];
    }
#pragma mark PGTextView
    else if([iu isKindOfClass:[PGTextView class]]){
        PGTextView *pgTextView = (PGTextView *)iu;
        if(pgTextView.placeholder){
            [retString appendFormat:@" placeholder=\"%@\"",pgTextView.placeholder];
        }
        if(pgTextView.inputName){
            [retString appendFormat:@" name=\"%@\"",pgTextView.inputName];
        }
    }
#pragma mark IUTransition
    else if ([iu isKindOfClass:[IUTransition class]]){
        IUTransition *transitionIU = (IUTransition*)iu;
        if ([transitionIU.eventType length]) {
            if ([transitionIU.eventType isEqualToString:kIUTransitionEventClick]) {
                [retString appendFormat:@" transitionEvent=\"click\""];
            }
            else if ([transitionIU.eventType isEqualToString:kIUTransitionEventMouseOn]){
                [retString appendFormat:@" transitionEvent=\"mouseOn\""];
            }
            else {
                NSAssert(0, @"Missing Code");
            }
            float duration = transitionIU.duration;
            if(duration < 1){
                [retString appendString:@" transitionDuration=0"];
            }
            else{
                [retString appendFormat:@" transitionDuration=%.2f", duration * 1000];
            }
        }
        if ([transitionIU.animation length]) {
            [retString appendFormat:@" transitionAnimation=\"%@\"", [transitionIU.animation lowercaseString]];
        }
    }
    
    return retString;
}

#pragma mark - cssSource

- (void)setResourceManager:(IUResourceManager *)resourceManager{
    _resourceManager = resourceManager;
    cssCompiler = [[IUCSSCompiler alloc] initWithResourceManager:self.resourceManager];
}


- (IUCSSCode*)cssCodeForIU:(IUBox*)iu{
    return [cssCompiler cssCodeForIU:iu];
}

-(JDCode *)cssSource:(IUSheet *)sheet cssSizeArray:(NSArray *)cssSizeArray isEdit:(BOOL)isEdit{
    
    NSMutableArray *mqSizeArray = [cssSizeArray mutableCopy];
    //remove default size
    NSInteger largestWidth = [[mqSizeArray objectAtIndex:0] integerValue];
    [mqSizeArray removeObjectAtIndex:0];

    
    JDCode *code = [[JDCode alloc] init];
    //    NSMutableString *css = [NSMutableString string];
    //default-
    if(isEdit){
        [code addCodeLine:@"<style id=default>"];
        [code increaseIndentLevelForEdit];
    }


    IUTarget target = isEdit ? IUTargetEditor : IUTargetOutput;
    NSDictionary *cssDict = [[cssCompiler cssCodeForIU:sheet] stringTagDictionaryWithIdentifierForTarget:target viewport:IUCSSDefaultViewPort];
    
    for (NSString *identifier in cssDict) {
        [code addCodeLineWithFormat:@"%@ {%@}", identifier, cssDict[identifier]];
    }
    NSSet *districtChildren = [NSSet setWithArray:sheet.allChildren];
    
    for (IUBox *obj in districtChildren) {
            NSDictionary *cssDict = [[cssCompiler cssCodeForIU:obj] stringTagDictionaryWithIdentifierForTarget:target viewport:IUCSSDefaultViewPort];
            for (NSString *identifier in cssDict) {
                [code addCodeLineWithFormat:@"%@ {%@}", identifier, cssDict[identifier]];
        }
    }
    if(isEdit){
        [code decreaseIndentLevelForEdit];
        [code addCodeLine:@"</style>"];
    }
    
    [code addNewLine];
    
#pragma mark extract MQ css
    //mediaQuery css
    for(int count=0; count<mqSizeArray.count; count++){
        int size = [[mqSizeArray objectAtIndex:count] intValue];
        

        
        if(isEdit){
            //edit는 stylesheet html tag로 들어감
            //<style type="text/css" media="screen and (max-width:400px)" id="style400">
            if(count < mqSizeArray.count-1){
                [code addCodeWithFormat:@"<style type=\"text/css\" media ='screen and (min-width:%dpx) and (max-width:%dpx)' id='style%d'>" , size, largestWidth-1, size];
                largestWidth = size;
            }
            else{
                [code addCodeWithFormat:@"<style type=\"text/css\" media ='screen and (max-width:%dpx)' id='style%d'>" , largestWidth-1, size];
                
            }
        }
        else{
            //build는 css파일로 따로 뽑아줌
            if(count < mqSizeArray.count-1){
                [code addCodeWithFormat:@"@media screen and (min-width:%dpx) and (max-width:%dpx){" , size, largestWidth-1];
                largestWidth = size;
            }
            else{
                [code addCodeWithFormat:@"@media screen and (max-width:%dpx){" , largestWidth-1];
                
            }
            
        }
        [code increaseIndentLevelForEdit];
        
        NSDictionary *cssDict =  [[cssCompiler cssCodeForIU:sheet] stringTagDictionaryWithIdentifierForTarget:target viewport:size];
        for (NSString *identifier in cssDict) {
            if ([[cssDict[identifier] stringByTrim]length]) {
                [code addCodeLineWithFormat:@"%@ {%@}", identifier, cssDict[identifier]];
            }
        }
        
        NSSet *districtChildren = [NSSet setWithArray:sheet.allChildren];
        
        for (IUBox *obj in districtChildren) {
            NSDictionary *cssDict = [[cssCompiler cssCodeForIU:obj] stringTagDictionaryWithIdentifierForTarget:target viewport:size];
            for (NSString *identifier in cssDict) {
                if ([[cssDict[identifier] stringByTrim]length]) {
                    [code addCodeLineWithFormat:@"%@ {%@}", identifier, cssDict[identifier]];
                }
            }
        }
        [code decreaseIndentLevelForEdit];
        
        if(isEdit){
            [code addCodeLine:@"</style>"];
        }
        else{
            [code addCodeLine:@"}"];
        }
    }
    return code;
}





#pragma mark css default

/**
 @breif This method makes whole css source
 */
-(NSDictionary*)cssSourceForIU:(IUBox*)iu width:(int)width isEdit:(BOOL)isEdit{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for(NSString *identifier in iu.cssIdentifierArray){
        NSDictionary *cssContentDict = [self CSSContentWithIdentifier:identifier ofIU:iu width:width isEdit:isEdit];
        if(cssContentDict.count > 0){
            NSString *cssString = [cssContentDict CSSCode];
            [dict setObject:cssString forKey:identifier];
        }
    }
    
    return dict;
}


- (NSDictionary *)CSSContentWithIdentifier:(NSString *)identifier ofIU:(IUBox *)iu width:(NSInteger)width isEdit:(BOOL)isEdit{
    //convert css tag dictionry or property css to css string dictionary
    
    NSMutableDictionary *cssDict = [NSMutableDictionary dictionary];
    
    if([identifier isEqualToString:[iu.htmlID cssClass]]){
        cssDict = [[self cssStringDictionaryWithCSSTagDictionary:[iu.css tagDictionaryForViewport:width] ofClass:iu isHover:NO isEdit:isEdit] mutableCopy];
    }
    else if([identifier isEqualToString:[[iu.htmlID cssClass] cssHoverClass]]){
        cssDict = [[self cssStringDictionaryWithCSSTagDictionary:[iu.css tagDictionaryForViewport:width] ofClass:iu isHover:YES isEdit:isEdit] mutableCopy];
    }
    
//    [cssDict addEntriesFromDictionary:[self cssStringDictionaryWithIdentifier:identifier ofIU:iu width:width isEdit:isEdit]];

    if(width != IUCSSDefaultViewPort){
        [cssDict removeObjectForKey:@"position"];
        [cssDict removeObjectForKey:@"overflow"];
        [cssDict removeObjectForKey:@"z-index"];
        [cssDict removeObjectForKey:@"float"];
    }
    
    return cssDict;
    
}

/**
 @breif this method makes property css dictionary
 */
#pragma mark - property css dictionary



/**
 @breif This method makes default css dictionary (1st property)
*/
-(IUCSSStringDictionary*)cssStringDictionaryWithCSSTagDictionary:(NSDictionary*)cssTagDict ofClass:(IUBox*)obj isHover:(BOOL)isHover isEdit:(BOOL)isEdit{
    IUCSSStringDictionary *dict = [IUCSSStringDictionary dictionary];
    id value;
    
#pragma mark - 
#pragma mark mouseHover CSS
    if (isHover){
        if ([cssTagDict[IUCSSTagHoverBGImagePositionEnable] boolValue]) {
            value = cssTagDict[IUCSSTagHoverBGImageX];
            if (value) {
                [dict putTag:@"background-position-x" floatValue:[value floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
            }
            value = cssTagDict[IUCSSTagHoverBGImageY];
            if (value) {
                [dict putTag:@"background-position-y" floatValue:[value floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
            }
        }
        
        if ([cssTagDict[IUCSSTagHoverBGColorEnable] boolValue]){
            value = cssTagDict[IUCSSTagHoverBGColor];
            if(value){
                NSColor *color = value;
                [dict putTag:@"background-color"  string:[color cssBGColorString]];
            }
        }
        
        if ([cssTagDict[IUCSSTagHoverTextColorEnable] boolValue]){
            value = cssTagDict[IUCSSTagHoverTextColor];
            if(value){
                [dict putTag:@"color" color:value ignoreClearColor:YES];
            }
        }
    }
#pragma mark -
#pragma mark normal CSS
    else {
        
        if(obj.link){
            [dict putTag:@"cursor" string:@"pointer"];
        }
        
        switch (obj.positionType) {
            case IUPositionTypeAbsolute:
            case IUPositionTypeAbsoluteCenter:
                [dict putTag:@"position" string:@"absolute"];
                break;
            case IUPositionTypeRelative:
            case IUPositionTypeRelativeCenter:
                [dict putTag:@"position" string:@"relative"];
                break;
            case IUPositionTypeFloatLeft:
                [dict putTag:@"position" string:@"relative"];
                [dict putTag:@"float" string:@"left"];
                break;
            case IUPositionTypeFloatRight:
                [dict putTag:@"position" string:@"relative"];
                [dict putTag:@"float" string:@"right"];
                break;
            case IUPositionTypeFixed:
                [dict putTag:@"position" string:@"fixed"];
                break;
                
            default:
                break;
        }
        switch (obj.overflowType) {
            case IUOverflowTypeHidden:
                [dict putTag:@"overflow" string:@"hidden"];
                break;
            case IUOverflowTypeVisible:
                [dict putTag:@"overflow" string:@"visible"];
                break;
            case IUOverflowTypeScroll:
                [dict putTag:@"overflow" string:@"scroll"];
                break;
                
            default:
                break;
        }
        if ( [obj isKindOfClass:[IUHeader class]]) {
            [dict putTag:@"z-index" string:@"10"];
        }
        if ([obj isKindOfClass:[IUPageContent class]] || [obj isKindOfClass:[IUHeader class]]) {
            [dict putTag:@"position" string:@"relative"];
        }
        
        if (obj.hasX) {
            BOOL enablePercent =[cssTagDict[IUCSSTagXUnitIsPercent] boolValue];
            IUCSSUnit unit =  [self unitWithBool:enablePercent];
            
            if(enablePercent){
                value = cssTagDict[IUCSSTagPercentX];
            }
            else{
                value = cssTagDict[IUCSSTagPixelX];
            }
            if(value){
                switch (obj.positionType) {
                    case IUPositionTypeAbsolute:
                        [dict putTag:@"left" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                        break;
                    case IUPositionTypeRelative:
                    case IUPositionTypeFloatLeft:
                        [dict putTag:@"margin-left" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                        break;
                    case IUPositionTypeFloatRight:
                        [dict putTag:@"margin-right" floatValue:[value floatValue] * (-1) ignoreZero:NO unit:unit];
                        break;
                    case IUPositionTypeFixed:
                        [dict putTag:@"left" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                        break;
                    default:
                        break;
                }
            }
        }
        if (obj.hasY) {
            BOOL enablePercent =[cssTagDict[IUCSSTagYUnitIsPercent] boolValue];
            IUCSSUnit unit = [self unitWithBool:enablePercent];
            
            if(enablePercent){
                value = cssTagDict[IUCSSTagPercentY];
            }
            else{
                value = cssTagDict[IUCSSTagPixelY];
            }
            
            if(value){
                switch (obj.positionType) {
                    case IUPositionTypeAbsolute:
                    case IUPositionTypeAbsoluteCenter:
                        [dict putTag:@"top" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                        break;
                    case IUPositionTypeFixed:
                        [dict putTag:@"top" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                        break;
                    default:
                        [dict putTag:@"margin-top" floatValue:[value floatValue] ignoreZero:NO unit:unit];

                        break;
                }
            }
        }
        if (obj.hasWidth) {
            if ([obj isKindOfClass:[IUHeader class]] == NO) {
                
                BOOL enablePercent =[cssTagDict[IUCSSTagWidthUnitIsPercent] boolValue];
                IUCSSUnit unit = [self unitWithBool:enablePercent];
                
                if(enablePercent){
                    value = cssTagDict[IUCSSTagPercentWidth];
                }
                else{
                    value = cssTagDict[IUCSSTagPixelWidth];
                }
                if (value) {
                    
                    [dict putTag:@"width" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                }
            }
        }
        
        if (obj.hasHeight) {
            
            BOOL enablePercent =[cssTagDict[IUCSSTagHeightUnitIsPercent] boolValue];
            IUCSSUnit unit = [self unitWithBool:enablePercent];
            
            if(enablePercent){
                value = cssTagDict[IUCSSTagPercentHeight];
            }
            else{
                value = cssTagDict[IUCSSTagPixelHeight];
            }
            if (value) {
                if ([obj isKindOfClass:[IUHeader class]]) {
                    
                }
                [dict putTag:@"height" floatValue:[value floatValue] ignoreZero:NO unit:unit];
            }
            
        }
        if(isEdit){
            //it should be used IN Editor Mode!!!
            //Usage : Transition, carousel hidden
            value = cssTagDict[IUCSSTagEditorDisplay];
            if (value && [value boolValue] == NO) {
                [dict putTag:@"display" string:@"none"];
            }
        }
        
        
#pragma mark background-image and color
        value = cssTagDict[IUCSSTagDisplayIsHidden];
        if(value && [value boolValue]){
            [dict putTag:@"display" string:@"none"];
        }
        else{
            [dict putTag:@"display" string:@"inherit"];
        }
        
        value = cssTagDict[IUCSSTagBGColor];
        if(value){
            NSColor *color = value;
            [dict putTag:@"background-color" string:[color cssBGColorString]];
        }
        
        value = cssTagDict[IUCSSTagOpacity];
        if(value){
            [dict putTag:@"opacity" floatValue:[value floatValue]/100 ignoreZero:NO unit:IUCSSUnitNone];
            [dict putTag:@"filter" string:[NSString stringWithFormat:@"alpha(opacity=%d)", [value intValue]]];
        }
        
        value = cssTagDict[IUCSSTagImage];
        if(value){
            
            if([value isDjangoVariable] == NO){
                NSString *imgSrc = [[self imagePathWithImageName:value isEdit:isEdit] CSSURLString];
                [dict putTag:@"background-image" string:imgSrc];
            }
        }
        
        IUBGSizeType bgSizeType = [cssTagDict[IUCSSTagBGSize] intValue];
        switch (bgSizeType) {
            case IUBGSizeTypeStretch:
                [dict putTag:@"background-size" string:@"100% 100%"];
                break;
            case IUBGSizeTypeContain:
                [dict putTag:@"background-size" string:@"contain"];
                break;
            case IUBGSizeTypeFull:
                [dict putTag:@"background-attachment" string:@"fixed"];
            case IUBGSizeTypeCover:
                [dict putTag:@"background-size" string:@"cover"];
                break;
            default:
                break;
        }
        
        BOOL digitBGPosition = [cssTagDict[IUCSSTagEnableBGCustomPosition] boolValue];
        if(digitBGPosition){
            id bgValue = cssTagDict[IUCSSTagBGXPosition];
            [dict putTag:@"background-position-x" intValue:[bgValue intValue] ignoreZero:YES unit:IUCSSUnitPixel];
            
            bgValue = cssTagDict[IUCSSTagBGYPosition];
            [dict putTag:@"background-position-y" intValue:[bgValue intValue] ignoreZero:YES unit:IUCSSUnitPixel];
        }
        else{
            NSString *vString, *hString;
            IUCSSBGVPostion vPosition = [cssTagDict[IUCSSTagBGVPosition] intValue];
            switch (vPosition) {
                case IUCSSBGVPostionTop:
                    vString = @"top";
                    break;
                case IUCSSBGVPostionCenter:
                    vString = @"center";
                    break;
                case IUCSSBGVPostionBottom:
                    vString = @"bottom";
                    break;
                default:
                    break;
            }
            
            IUCSSBGHPostion hPosition = [cssTagDict[IUCSSTagBGHPosition] intValue];
            switch (hPosition) {
                case IUCSSBGHPostionLeft:
                    hString = @"left";
                    break;
                case IUCSSBGHPostionCenter:
                    hString = @"center";
                    break;
                case IUCSSBGHPostionRight:
                    hString= @"right";
                    break;
                default:
                    break;
            }
            [dict putTag:@"background-position" string:[NSString stringWithFormat:@"%@ %@", vString, hString]];
            
        }
        
        id bgValue = cssTagDict[IUCSSTagBGRepeat];
        BOOL repeat = [bgValue boolValue];
        if(repeat){
            [dict putTag:@"background-repeat" string:@"repeat"];
        }
        else{
            [dict putTag:@"background-repeat" string:@"no-repeat"];
        }
        
        BOOL enableGraident = [cssTagDict[IUCSSTagBGGradient] boolValue];
        if(cssTagDict[IUCSSTagBGGradient] && enableGraident){
            NSColor *bgColor1 = cssTagDict[IUCSSTagBGGradientStartColor];
            NSColor *bgColor2 = cssTagDict[IUCSSTagBGGradientEndColor];
            
            if(enableGraident){
                if(bgColor2 == nil){
                    bgColor2 = [NSColor rgbColorRed:0 green:0 blue:0 alpha:1];
                }
                if(bgColor1 == nil){
                    bgColor1 = [NSColor rgbColorRed:0 green:0 blue:0 alpha:1];
                }
                [dict putTag:@"background-color" color:bgColor1 ignoreClearColor:YES];
                
                
                NSString *webKitStr = [NSString stringWithFormat:@"-webkit-gradient(linear, left top, left bottom, color-stop(0.05, %@), color-stop(1, %@));", bgColor1.rgbString, bgColor2.rgbString];
                NSString *mozStr = [NSString stringWithFormat:@"	background:-moz-linear-gradient( center top, %@ 5%%, %@ 100%% );", bgColor1.rgbString, bgColor2.rgbString];
                NSString *ieStr = [NSString stringWithFormat:@"filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='%@', endColorstr='%@', GradientType=0)", bgColor1.rgbStringWithTransparent, bgColor2.rgbStringWithTransparent];
                NSString *gradientStr = [webKitStr stringByAppendingFormat:@"%@ %@", mozStr, ieStr];
                
                [dict putTag:@"background" string:gradientStr];
                
            }
            
        }
     
        
#pragma mark CSS - Border
        value = cssTagDict[IUCSSTagBorderLeftWidth];
        if (value) {
            [dict putTag:@"border-left-width" intValue:[value intValue] ignoreZero:NO unit:IUCSSUnitPixel];
            NSColor *color = cssTagDict[IUCSSTagBorderLeftColor];
            [dict putTag:@"border-left-color" color:color ignoreClearColor:NO];
        }
        value = cssTagDict[IUCSSTagBorderRightWidth];
        if (value) {
            [dict putTag:@"border-right-width" intValue:[value intValue] ignoreZero:NO unit:IUCSSUnitPixel];
            NSColor *color = cssTagDict[IUCSSTagBorderRightColor];
            [dict putTag:@"border-right-color" color:color ignoreClearColor:NO];
        }
        
        value = cssTagDict[IUCSSTagBorderBottomWidth];
        if (value) {
            [dict putTag:@"border-bottom-width" intValue:[value intValue] ignoreZero:NO unit:IUCSSUnitPixel];
            NSColor *color = cssTagDict[IUCSSTagBorderBottomColor];
            [dict putTag:@"border-bottom-color" color:color ignoreClearColor:NO];
        }
        
        value = cssTagDict[IUCSSTagBorderTopWidth];
        if (value) {
            [dict putTag:@"border-top-width" intValue:[value intValue] ignoreZero:NO unit:IUCSSUnitPixel];
            NSColor *color = cssTagDict[IUCSSTagBorderTopColor];
            [dict putTag:@"border-top-color" color:color ignoreClearColor:NO];
        }
        

        
        value = cssTagDict[IUCSSTagBorderRadiusTopLeft];
        if(value){
            [dict putTag:@"border-top-left-radius" intValue:[value intValue] ignoreZero:NO unit:IUCSSUnitPixel];}
        value = cssTagDict[IUCSSTagBorderRadiusTopRight];
        if(value){
            [dict putTag:@"border-top-right-radius" intValue:[value intValue] ignoreZero:NO unit:IUCSSUnitPixel];}
        value = cssTagDict[IUCSSTagBorderRadiusBottomLeft];
        if(value){
            [dict putTag:@"border-bottom-left-radius" intValue:[value intValue] ignoreZero:NO unit:IUCSSUnitPixel];}
        value = cssTagDict[IUCSSTagBorderRadiusBottomRight];
        if(value){
            [dict putTag:@"border-bottom-right-radius" intValue:[value intValue] ignoreZero:NO unit:IUCSSUnitPixel];}
        
        NSInteger hOff = [cssTagDict[IUCSSTagShadowHorizontal] integerValue];
        NSInteger vOff = [cssTagDict[IUCSSTagShadowVertical] integerValue];
        NSInteger blur = [cssTagDict[IUCSSTagShadowBlur] integerValue];
        NSInteger spread = [cssTagDict[IUCSSTagShadowSpread] integerValue];
        NSColor *color = cssTagDict[IUCSSTagShadowColor];
        if (color == nil){
            color = [NSColor blackColor];
        }
        if (hOff || vOff || blur || spread){
             [dict putTag:@"-moz-box-shadow" string:[NSString stringWithFormat:@"%ldpx %ldpx %ldpx %ldpx %@", hOff, vOff, blur, spread, [color rgbString]]];
             [dict putTag:@"-webkit-box-shadow" string:[NSString stringWithFormat:@"%ldpx %ldpx %ldpx %ldpx %@", hOff, vOff, blur, spread, [color rgbString]]];
             [dict putTag:@"box-shadow" string:[NSString stringWithFormat:@"%ldpx %ldpx %ldpx %ldpx %@", hOff, vOff, blur, spread, [color rgbString]]];
            //for IE5.5-7
            [dict putTag:@"filter" string:[NSString stringWithFormat:@"progid:DXImageTransform.Microsoft.Shadow(Strength=%ld, Direction=135, Color='%@')",spread, [color rgbString]]];
//            [dict putTag:@"filter" string:[NSString stringWithFormat:@"progid:DXImageTransform.Microsoft.Blur(pixelradius=%ld)",blur]];

            //for IE 8
            [dict putTag:@"-ms-filter" string:[NSString stringWithFormat:@"\"progid:DXImageTransform.Microsoft.Shadow(Strength=%ld, Direction=135, Color='%@')",spread, [color rgbString]]];
  //          [dict putTag:@"-ms-filter" string:[NSString stringWithFormat:@"\"progid:DXImageTransform.Microsoft.Blur(pixelradius=%ld)\"",blur]];


        }
        
        if(
#pragma mark - Text CSS
#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
           [obj isKindOfClass:[IUText class]]||
#else
           [obj shouldCompileFontInfo]
#endif

           )
        {
            value = cssTagDict[IUCSSTagFontName];
            if(value){
                NSString *font=cssTagDict[IUCSSTagFontName];
                [dict putTag:@"font-family" string:[[LMFontController sharedFontController] cssForFontName:font]];
            }
            value = cssTagDict[IUCSSTagFontSize];
            if(value){
                [dict putTag:@"font-size" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];}
            value = cssTagDict[IUCSSTagFontColor];
            if(value){
                NSColor *color=cssTagDict[IUCSSTagFontColor];
                [dict putTag:@"color" color:color ignoreClearColor:YES];
            }
            
            value = cssTagDict[IUCSSTagTextLetterSpacing];
            if(value){
                [dict putTag:@"letter-spacing" floatValue:[value floatValue] ignoreZero:YES unit:IUCSSUnitPixel];
            }
            
            value = cssTagDict[IUCSSTagLineHeight];
            if(value){
                
                if([value isEqualToString:@"Auto"]== YES)
                {
                    if ([obj isKindOfClass:[PGTextView class]]){
                        [dict putTag:@"line-height" floatValue:1.3 ignoreZero:YES unit:IUCSSUnitNone];

                    }
                }
               else{
                    [dict putTag:@"line-height" floatValue:[value floatValue] ignoreZero:YES unit:IUCSSUnitNone];
                }
            }
            
            BOOL boolValue =[cssTagDict[IUCSSTagFontWeight] boolValue];
            if(boolValue){
                [dict putTag:@"font-weight" string:@"bold"];
            }
            boolValue = [cssTagDict[IUCSSTagFontStyle] boolValue];
            if(boolValue){
                [dict putTag:@"font-style" string:@"italic"];
            }
            boolValue = [cssTagDict[IUCSSTagTextDecoration] boolValue];
            if(boolValue){
                [dict putTag:@"text-decoration" string:@"underline"];
            }
            
            id value = cssTagDict[IUCSSTagTextAlign];
            if (value) {
                NSInteger align = [value integerValue];
                NSString *alignText;
                switch (align) {
                    case IUAlignLeft:
                        alignText = @"left";
                        break;
                    case IUAlignCenter:
                        alignText = @"center";
                        break;
                    case IUAlignRight:
                        alignText = @"right";
                        break;
                    case IUAlignJustify:
                        alignText = @"justify";
                        break;
                    default:
                        JDErrorLog(@"no align type");
                }
                [dict putTag:@"text-align" string:alignText];
            }
            

        }
        /*
        else{
            [dict putTag:@"line-height" string:@"initial"];
        }
         */


    }
    //end of else (not hover)
    return dict;

}


#pragma mark - manage JS source

-(NSString*)outputJSInitializeSource:(IUSheet *)document{
    JDCode *jsSource = [self outputJSSource:document];
    return [jsSource string];
}

-(JDCode *)outputJSSource:(IUBox *)iu{
    JDCode *code = [[JDCode alloc] init];
   
    if([iu isKindOfClass:[IUCarousel class]]){
        [code addCodeLine:@"/* IUCarousel initialize */\n"];
        [code addCodeLineWithFormat:@"initCarousel('%@')", iu.htmlID];
    }
    else if ([iu isKindOfClass:[IUBox class]]) {
        if (iu.children.count) {
            for (IUBox *child in iu.children) {
                [code addCode:[self outputJSSource:child]];
            }
        }

    }
    
    return code;
}

#if 0

#pragma mark - PHP
-(JDCode *)outputPHP:(IUBox *)iu{
    JDCode *code = [[JDCode alloc] init];
#pragma mark - IUPHP
    if([iu isKindOfClass:[IUPHP class]]){
        [code addCodeLine:@"<? %@ ?>", iu.code];
    }
    
    return code;

}

-(JDCode *)editorPHP:(IUBox*)iu{
    JDCode *code = [[JDCode alloc] init];
    
    
    
#pragma mark - IUPHP
    /*
    if([iu isKindOfClass:[IUPHP class]]){
        [code addCodeLine:@"<? %@ ?>"];
    }
     */
#pragma mark - WPContentCollection
     if([iu isKindOfClass:[WPContentCollection class]]){
        WPContentCollection *collection = (WPContentCollection *)iu;
        //start loop
        [code addCodeLine:@"<? while ( have_posts() ) : the_post(); ?>"];
        [code increaseIndentLevelForEdit];
        
        //content title
        [code addCodeLine:@"<a href='<?php the_permalink(); ?>'><?php the_title(); ?></a>"];
        
        //date & time
        NSString *dateTime;
        if(collection.enableDate){
            [code addCodeLine:@"<?php echo get_the_date(); ?>"];
        }
        if (collection.enableTime) {
            [code addCodeLine:@"<?php echo get_the_time(); ?>"];
        }
        if (collection.enableCategory) {
            [code addCodeLine:@"| Category: <?php the_category(', '); ?>"];
        }
        if (collection.enableTag) {
            [code addCodeLine:@"| Tag: <?php the_tag(', '); ?>"];
        }
        
        //content type sellection disable
        [code addCodeLine:@"<?php if ( is_home() || is_category() || is_tag() ) { the_excerpt(); } else { the_content();} ?>"];
        
        
        [code decreaseIndentLevelForEdit];
        [code addCodeLine:@"<?php endwhile; ?> "];
    }
    
    return code;
}
#endif

- (void)dealloc{
    [JDLogUtil log:IULogDealloc string:@"IUCompiler"];
}
@end
