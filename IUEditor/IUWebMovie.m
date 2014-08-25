//
//  IUWebMovie.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUWebMovie.h"

@interface IUWebMovie()


@end

@implementation IUWebMovie{
}

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.undoManager disableUndoRegistration];

        _thumbnail = YES;
        _movieType = IUWebMovieTypeVimeo;
        _movieLink = @"http://vimeo.com/101677733";
        _playType = IUWebMoviePlayTypeNone;
        _enableLoop = YES;
        _thumbnailID = @"101677733";
        _thumbnailPath = @"http://i.vimeocdn.com/video/483513294_640.jpg";
        
        [self.css setValue:@(700) forTag:IUCSSTagPixelWidth forViewport:IUCSSDefaultViewPort];
        [self.css setValue:@(400) forTag:IUCSSTagPixelHeight forViewport:IUCSSDefaultViewPort];

        
        [self.undoManager enableUndoRegistration];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [self.undoManager disableUndoRegistration];

        [aDecoder decodeToObject:self withProperties:[[IUWebMovie class] properties]];
        
        [self.undoManager enableUndoRegistration];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUWebMovie class] properties]];
    
}
- (id)copyWithZone:(NSZone *)zone{
    IUWebMovie *webMovie = [super copyWithZone:zone];
    [self.undoManager disableUndoRegistration];
    [self.delegate disableUpdateAll:self];
    
    webMovie.thumbnail = self.thumbnail;
    webMovie.thumbnailID = [_thumbnailID copy];
    webMovie.thumbnailPath = [_thumbnailPath copy];
    
    webMovie.movieType = _movieType;
    webMovie.playType = _playType;
    webMovie.enableLoop = _enableLoop;
    webMovie.movieLink = [_movieLink copy];
    webMovie.movieID = [_movieID copy];
    
    [self.delegate enableUpdateAll:self];
    [self.undoManager enableUndoRegistration];
    return webMovie;
}

- (void)connectWithEditor{
    [super connectWithEditor];
    [self updateWebMovieSource];
}

#pragma mark - should setting
- (BOOL)shouldAddIUByUserInput{
    return NO;
}


#pragma mark - property

- (void)setMovieLink:(NSString *)movieLink{
    if([_movieLink isEqualToString:movieLink]){
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setMovieLink:_movieLink];
    _movieLink = movieLink;
    if(self.isConnectedWithEditor){
        [self updateWebMovieSource];
    }
}

- (void)setPlayType:(IUWebMoviePlayType)playType{
    if(playType != _playType){
        [[self.undoManager prepareWithInvocationTarget:self] setPlayType:_playType];
        _playType = playType;
    }
    [self updateWebMovieSource];
}

- (void)setEnableLoop:(BOOL)enableLoop{
    if(_enableLoop != enableLoop){
        [[self.undoManager prepareWithInvocationTarget:self] setEnableLoop:_enableLoop];
        _enableLoop = enableLoop;
    }
    [self updateWebMovieSource];
}

#pragma mark - webmovie
- (void)updateWebMovieSource{
    NSMutableString *movieCode = [NSMutableString string];
    NSMutableString *attribute = [NSMutableString string];
    
    //vimeo
    if([_movieLink containsString:@"vimeo"]){
        //http://vimeo.com/channels/staffpicks/79426902
        //<iframe src="//player.vimeo.com/video/VIDEO_ID" width="WIDTH" height="HEIGHT" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

        _movieID = [[_movieLink lastPathComponent] substringWithRange:NSMakeRange(0, 9)];
        
        
        [movieCode appendFormat:@"<iframe src=\"http://player.vimeo.com/video/%@?api=1&player_id=%@_vimeo", _movieID, self.htmlID];
        [attribute appendString:@" webkitallowfullscreen mozallowfullscreen"];

        _movieType = IUWebMovieTypeVimeo;
    }
    else if([_movieLink containsString:@"youtu.be"]){
        //http://youtu.be/Z0uknBJc8NI
        //http://youtu.be/EM06XSULpgc?list=RDEM06XSULpgc
        //<iframe width="560" height="315" src="//www.youtube.com/embed/Sl-BDzmORX0?list=RDHCzBybJtuKWjA" frameborder="0" allowfullscreen></iframe>
        _movieID = [[_movieLink lastPathComponent] substringWithRange:NSMakeRange(0, 11)];
        
        [movieCode appendString:@"<object width=\"100%\" height=\"100%\">"];
        
        [movieCode appendFormat:@"<param name=\"movie\" value=\"https://youtube.googleapis.com/%@?version=2&fs=1\"</param>", [_movieLink lastPathComponent]];
        [movieCode appendString:@"<param name=\"allowFullScreen\" value=\"true\"></param>"];
        [movieCode appendString:@"<param name=\"allowScriptAccess\" value=\"always\"></param>"];
        
        
        [movieCode appendFormat:@"<embed id='%@_youtube'", self.htmlID];
        [movieCode appendFormat:@" src=\"http://www.youtube.com/v/%@?version=3&enablejsapi=1", [_movieLink lastPathComponent]];
        if([[_movieLink lastPathComponent] containsString:@"list"]){
            [movieCode appendString:@"&listType=playlist"];
        }
        [movieCode appendFormat:@"&autohide=1&playerapiid=%@_youtube", self.htmlID];
        _movieType = IUWebMovieTypeYoutube;

    }
    else{
        _movieType = IUWebMovieTypeUnknown;
        self.innerHTML = @"";
        return;
    }
    
    if(_playType == IUWebMoviePlayTypeAutoplay){
        [movieCode appendString:@"&autoplay=1"];
    }
    if(_enableLoop){
        [movieCode appendString:@"&loop=1"];
    }
    
    [movieCode appendString:@"\""];
    
    [movieCode appendString:attribute];
    [movieCode appendString:@" allowfullscreen frameborder=\"0\" width=\"100%\" height=\"100%\" "];
    
    if(_movieType == IUWebMovieTypeVimeo){
        [movieCode appendString:@"></iframe>"];
    }
    else if(_movieType == IUWebMovieTypeYoutube){
        [movieCode appendString:@"type=\"application/x-shockwave-flash\" allowscriptaccess=\"always\""];
        [movieCode appendString:@"></embed>"];
        [movieCode appendString:@"</object>"];

    }
    
    [self updateThumbnailOfWebMovie];
    self.innerHTML = movieCode;
}


-(void)updateThumbnailOfWebMovie{
    if([_thumbnailID isEqualToString:_movieID] && _thumbnail){
        return;
    }
    else{
        _thumbnail = NO;
    }

    if (_movieType == IUWebMovieTypeYoutube){
        _thumbnailID = _movieID;
        //http://stackoverflow.com/questions/2068344/how-do-i-get-a-youtube-video-thumbnail-from-the-youtube-api
        NSString *youtubePath = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/sdddefault.jpg", _movieID];
        NSInteger width = [[self.delegate callWebScriptMethod:@"getImageWidth" withArguments:@[youtubePath]] integerValue];
        if(width < 130 ){
            youtubePath = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg", _movieID];
        }
        
        _thumbnailPath = youtubePath;
        _thumbnail = YES;
        
    }
    // 2. vimeo
    else if (_movieType == IUWebMovieTypeVimeo){
        _thumbnailID = _movieID;
        NSURL *filePath =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.vimeo.com/api/v2/video/%@.json", _movieID]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
            NSData* data = [NSData dataWithContentsOfURL:
                            filePath];
            [self performSelectorOnMainThread:@selector(fetchedVimeoData:)
                                   withObject:data waitUntilDone:YES];
        });
        
    }
}

- (void)fetchedVimeoData:(NSData *)responseData {

    //data 연결 등의 문제로 empty일때
    if(responseData == nil) return;
    NSError* error;
    
    //parse out the json data
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions
                     error:&error];
    
    NSDictionary* vimeoDict = json[0];
    _thumbnailPath = [vimeoDict objectForKey:@"thumbnail_large"]; //2
    _thumbnail = YES;
    
    [self updateHTML];
    
}

@end
