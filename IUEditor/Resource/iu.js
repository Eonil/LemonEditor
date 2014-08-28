//for ie
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
        $(secondObj).show(effect, 1);
    }
    else{
        $(secondObj).show(effect, duration);
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

$(document).ready(function(){
    console.log('iu.js')
});


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

function resizeCollection(){
	$('.IUCollection').each(function(){
		//find current count
		var responsive = $(this).attr('responsive');
		responsiveArray = eval(responsive);
		count = $(this).attr('defaultItemCount');
		viewportWidth = $(window).width();
		var minWidth = 9999;
		for (var index in responsiveArray){
			dict = responsiveArray[index];
			width = dict.width;
			if (viewportWidth<width && minWidth > width){
				count = dict.count;
				minWidth = width;
			}
		}		
		//			var width  = 1/count *100;
		var width = $(this).width()/count;
		$(this).children().css('width', width.toFixed(0)+'px');
	});
}

$(window).resize(function(){
});

$(window).scroll(function(){
    if (typeof isEditor != 'undefined' && isEditor == true){
		return;
	}
	onWebMovieAutoPlay();
    moveScrollAnimation();             
	
});