//this file only used in output file from IUEditor

//for ie console defined
var alertFallback = false;
if (typeof console === "undefined" || typeof console.log === "undefined") {
    console = {};
    if (alertFallback) {
        console.log = function(msg) {
            alert(msg);
        };
    } else {
        console.log = function() {};
    }
}


function isMobile(){
	if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
	 	return true;
	}
	else{
		return false;
	}
}

function transitionAnimationOn(eventObject){
	var transition = eventObject.currentTarget;
    var secondObj = $(transition).find('.IUItem')[1];
	var effect = $(transition).attr('transitionanimation');
    var duration = $(transition).attr('transitionduration');

    if(duration <= 0){
        $(secondObj).show(effect, 1, function(){reframeCenterIU('#'+transition.id)});
    }
    else{
        $(secondObj).show(effect, duration, function(){reframeCenterIU('#'+transition.id)});
    }
	
   	$(transition).data('isSelected', 'false');
}

function transitionAnimationOff(eventObject){
	var transition = eventObject.currentTarget;
    var secondObj = $(transition).find('.IUItem')[1];
    var isEndAnimation = $($(transition).children()[1]).hasClass('IUItem');
    var effect = $(transition).attr('transitionanimation');
    var duration = $(transition).attr('transitionduration');
    
    if(duration <= 0){
        $(secondObj).hide(effect, 1);
    }
    else{
        $(secondObj).hide(effect, duration);
    }
    $(transition).data('isSelected', 'true');
}

function transitionAnimation(eventObject){
    if (typeof isEditor != 'undefined' && isEditor == true){
        return;
    }
	
	var transition = eventObject.currentTarget;
    var effect = $(transition).attr('transitionanimation');
    var isSelected= $(transition).data('isSelected');
    
    
   	if (isSelected=='true'){
   		transitionAnimationOn(eventObject);
    }
   	else {
   		transitionAnimationOff(eventObject);
   	}
}

function showCollectionView(iu, index){
	$('#'+iu).children().each(function(i){
		if(i != index){
			$(this).css('display', 'none');
		}
		else{
			$(this).css('display', 'block');
		}
	});
}

function activateLink(iu, location){
	var url = window.location.pathname;
	var links =  iu.href.split('#');
    var urlRegExp = new RegExp(url == '/' ? window.location.origin + '/?$' : url.replace(/\/$/,''));
	if(urlRegExp.test(links[0]) && links.length==1 ){
		if(location=='parent'){
			$(iu).parent().addClass('active');
		}
		else if(location=='child'){
			$(iu).children().first().addClass('active');
		}	
  	}
	else{
		if(location=='parent'){
			if ($(iu).parent().hasClass('active')) {
				$(iu).parent().removeClass('active');
			}
		}		
		else if(location=='child'){
			if ($(iu).children().first().hasClass('active')) {
				$(iu).children().first().removeClass('active');
			}
		}		
	}
}

function activateDivLink(){
	if($('[iudivlink]').length <=0) return;
	
	var dict={};
	$('[iudivlink]').each(function(){
		var pos = $(this).position().top;
		var caller = $(this).attr('linkcaller');
		dict[caller] = pos;
	});
	
	var sortable = [];
	for(var caller in dict){
		sortable.push([caller, dict[caller]]);
	}
	sortable.sort(function(a, b){return a[1] - b[1]});
	
	var scrollY = $(document).scrollTop();
	var currentCaller;
	for(var caller in dict){
		var position = dict[caller];
		if(position < scrollY){
			currentCaller = caller;
		}
		
		if ($('#'+caller).hasClass('active')) {
			$('#'+caller).removeClass('active');
		}
	}
	
	$('#'+currentCaller).addClass('active');
}

function onWebMovieAutoPlay(){
	//autoplay when appear
	var scrollY = $(document).scrollTop();
	var screenH = $(window).height();
	var maxY = scrollY + screenH;
	$('[eventAutoplay]').each(function(){
		var yPos = $(this).offset().top;
		var type = $(this).attr('videotype');
        var display = $(this).css('display');
		if(yPos > scrollY && yPos < maxY && display != 'none'){
			//play
			if(type=='vimeo'){
				var vimeo = $f($(this).children()[0]);
				vimeo.api('play');
			
			}
			else if(type=='youtube'){
				var id = $(this).attr('id')+'_youtube';
			 	var youtube = document.getElementById(id);
				youtube.playVideo();
			}
		}
		else{
			//stop
			if(type=='vimeo'){
				var vimeo = $f($(this).children()[0]);
				vimeo.api('pause');
			}
			else if(type=='youtube'){
				var id = $(this).attr('id')+'_youtube';
			 	var youtube = document.getElementById(id);
				youtube.pauseVideo();
			}
		
		
		}
	});
}


function relocateScrollAnimation(){
	//move : current viewport pc type
	if(isMobile()==false){
		$('[xPosMove]').each(function(){
			var xPosMove = $(this).attr('xPosMove');
            var start;
            
			if ($(this).css('float') == 'left'){
                start = parseFloat($(this).css('margin-left')) - xPosMove;
                $(this).css('margin-left', start + 'px');
            }
            else if($(this).css('float') == 'right'){
               start = parseFloat($(this).css('margin-right')) - xPosMove;
               $(this).css('margin-right', start + 'px');
            }
            else{
				start = parseFloat($(this).css('left')) - xPosMove;
				$(this).css('left', start + 'px');
			};
            $(this).attr('start', start);

		});
	}
}


function moveScrollAnimation(){
	//disable small size view port
	var viewportWidth = $(window).width();
	if(isMobile()==true || viewportWidth < 650){
		
		$('[xPosMove]').each(function(){
			$(this).removeAttr('style');
		});
		
		return;
	}
		
	var scrollY = $(document).scrollTop();
	var screenH = $(window).height();
		
		
	//move horizontally
	$('[opacitymove]').each(function(){
		var opacityMove = $(this).attr('opacitymove'); 
		var yPos = $(this).offset().top+$(this).outerHeight()/2;
		var percent = (yPos - scrollY)/(screenH/2);
		if(percent > 0){
			if(percent<=0.35){
				percent = percent*2.0;	
			}
			else if(percent>0.35 && percent <1.0){
				percent = 1.0;
			}
			else if(percent > 1.0){
				percent = percent - 1.0;
				percent = 1.0 - percent;
			}
			$(this).css('opacity', percent);
		}
	});
	
	
	$('[xPosMove]').each(function(){
		var start = parseFloat($(this).attr('start'));
		var xMove = parseFloat($(this).attr('xPosMove'));
		y = $(window).height()/1.5;
		x = (scrollY- $(this).offset().top+screenH);
		
		var current = (start) +  xMove/y* x;
		
		if (xMove > 0){
			if (current < start){
				current = start;
			}
			else if ( current > start + xMove ){
				current = start + xMove;
			}
		}
		else {
			if (current > start){
				current = start;
			}
			else if ( current < start + xMove ){
				current = start + xMove;
			}
		}
		var position = $(this).css('float');
		if(position =='left'){
			$(this).css('margin-left', current+'px');
		}
		else if(position =='right'){
			$(this).css('margin-right', current+'px');
		}
		else{
			$(this).css('left', current+'px');
		}
		
	});
	
	
}


function makeBottomLocation(){
	if($('.IUFooter').length > 0){
		var windowHeight =  $(window).height();
		var footerHeight = $('.IUFooter').height();
		var footerTop =  $('.IUFooter').position().top;
		var footerBottom = footerTop + footerHeight;
		if(footerBottom < windowHeight){
			$('.IUFooter').css('bottom','0px');
			$('.IUFooter').css('position','fixed');
		}
		else{
			$('.IUFooter').css('bottom','');
			$('.IUFooter').css('position','');
		}
	}
}
$(window).resize(function(){
	//iu.js
	makeBottomLocation();
	
	//iuframe.js
	resizeCollection();
	reframeCenter();
	resizePageLinkSet();
	relocateScrollAnimation();
	resizeSideBar();
	makefullSizeSection();
});

var scrollTimer = null;

$(window).scroll(function(){
    if(scrollTimer){
           window.clearTimeout(timer);
    }
	scrollTimer = window.setTimeout(handleScroll, 50);	   	
});

function handleScroll(){
	scrollTimer = null;
	
    // actual callback
	onWebMovieAutoPlay();
    moveScrollAnimation();          
	activateDivLink(); 
}