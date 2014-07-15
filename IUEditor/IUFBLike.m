//
//  IUFBLike.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 23..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUFBLike.h"
@interface IUFBLike()

@property NSString *fbSource;

@end

@implementation IUFBLike{
}

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        self.innerHTML = @"";
        _fbSource = @"<iframe src=\"//www.facebook.com/plugins/like.php?href=__FB_LINK_ADDRESS__+&amp;width&amp;layout=standard&amp;action=like&amp;show_faces=__SHOW_FACE__&amp;share=true&amp;colorscheme=__COLOR_SCHEME__&amp;\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; height:__HEIGHT__px\" allowTransparency=\"true\"></iframe>";
        _showFriendsFace = YES;
        _colorscheme = IUFBLikeColorLight;
        [self.css setValue:@(80) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(320) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:nil forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
    }
    return self;
}

- (void)connectWithEditor{
    [super connectWithEditor];
    [self addObserver:self forKeyPaths:@[@"showFriendsFace", @"likePage", @"colorscheme"] options:0 context:@"IUFBSource"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUFBLike class] properties]];
        _fbSource = @"<iframe src=\"//www.facebook.com/plugins/like.php?href=__FB_LINK_ADDRESS__+&amp;width&amp;layout=standard&amp;action=like&amp;show_faces=__SHOW_FACE__&amp;share=true&amp;colorscheme=__COLOR_SCHEME__&amp;\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; height:__HEIGHT__px\" allowTransparency=\"true\"></iframe>";

    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUFBLike class] properties]];
    
}

- (id)copyWithZone:(NSZone *)zone{
    IUFBLike *iu = [super copyWithZone:zone];
    
    iu.likePage = [_likePage copy];
    iu.showFriendsFace = _showFriendsFace;
    
    return iu;
}

-(void) dealloc{
    [self removeObserver:self forKeyPaths:@[@"showFriendsFace", @"likePage", @"colorscheme"]];
}

- (void)IUFBSourceContextDidChange:(NSDictionary *)change{
    NSString *showFaces;
    if(self.showFriendsFace){
        [self.css setValue:@(80) forTag:IUCSSTagHeight forWidth:self.css.editWidth];
        showFaces = @"true";
    }else{
        [self.css setValue:@(35) forTag:IUCSSTagHeight forWidth:self.css.editWidth];
        showFaces = @"false";
    }
    
    [self updateCSSForEditViewPort];
        
    NSString *currentPixel = [[NSString alloc] initWithFormat:@"%.0f", [self.css.assembledTagDictionary[IUCSSTagHeight] floatValue]];
    
    NSString *source;

    source = [self.fbSource stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:currentPixel];
    source = [source stringByReplacingOccurrencesOfString:@"__SHOW_FACE__" withString:showFaces];
    
    NSString *pageStr = self.likePage;
    if(self.likePage.length == 0){
        pageStr = @"";
    }
    
    switch (_colorscheme) {
        case IUFBLikeColorLight:
            source = [source stringByReplacingOccurrencesOfString:@"__COLOR_SCHEME__" withString:@"light"];
            break;
        case IUFBLikeColorDark:
            source = [source stringByReplacingOccurrencesOfString:@"__COLOR_SCHEME__" withString:@"dark"];
        default:
            break;
    }
    
    source = [source stringByReplacingOccurrencesOfString:@"__FB_LINK_ADDRESS__" withString:pageStr];
    
    self.innerHTML = source;
}


- (BOOL)canChangeWidthByUserInput{
    return NO;
}
- (BOOL)canChangeHeightByUserInput{
    return NO;
}

@end
