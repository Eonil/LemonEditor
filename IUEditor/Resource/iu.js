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
    var secondObj = $(this).find('.IUItem')[1];
	var effect = $(this).attr('transitionanimation');
    var duration = $(this).attr('transitionduration');

    if(duration <= 0){
        $(secondObj).show(effect, 1);
    }
    else{
        $(secondObj).show(effect, duration);
    }

   	$(this).data('isSelected', 'false');
}

function transitionAnimationOff(eventObject){
    var secondObj = $(this).find('.IUItem')[1];
    var isEndAnimation = $($(this).children()[1]).hasClass('IUItem');
    var effect = $(this).attr('transitionanimation');
    var duration = $(this).attr('transitionduration');
    
    if(duration <= 0){
        $(secondObj).hide(effect, 1);
    }
    else{
        $(secondObj).hide(effect, duration);
    }
    $(this).data('isSelected', 'true');
}

function transitionAnimation(eventObject){
    if (typeof isEditor != 'undefined' && isEditor == true){
        return;
    }
    var effect = $(this).attr('transitionanimation');
    var isSelected= $(this).data('isSelected');
    
    
   	if (isSelected=='true'){
   		transitionAnimationOn(eventObject);
    }
   	else {
   		transitionAnimationOff(eventOBject);
   	}
}

$(document).ready(function(){
    console.log('iu.js')
});

function onYouTubePlayerReady(playerId){
	console.log("playerId : "+playerId);
}

$(window).scroll(function(){
    if (typeof isEditor != 'undefined' && isEditor == true){

		return;
	}
	
	if(isMobile()==false){
		//autoplay when appear
		var scrollY = $(document).scrollTop();
		var screenH = $(window).height();
		var maxY = scrollY + screenH;
		$('[eventAutoplay]').each(function(){
			var yPos = $(this).offset().top;
			var type = $(this).attr('videotype');
			if(yPos > scrollY && yPos < maxY){
				//play
				if(type=='vimeo'){
					var vimeo = $f($(this).children()[0]);
					vimeo.api('play');
				
				}
				/*
				else if(type=='video'){
				$(this).load();
				$(this).play();
				}
				*/
			}
			else{
				//stop
				if(type=='vimeo'){
					var vimeo = $f($(this).children()[0]);
					vimeo.api('pause');
				}
			
			
			}
		});
	
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
			startLeft = parseFloat($(this).attr('startLeft')); 
			xMove = parseFloat($(this).attr('xPosMove')); 
			y = $(window).height()/1.5;
			x = (scrollY- $(this).offset().top+screenH);
		
			var left = (startLeft) +  xMove/y* x;
		
			if (xMove > 0){
				if (left < startLeft){
					left = startLeft;
				}
				else if ( left > startLeft + xMove ){
					left = startLeft + xMove;
				}
			}
			else {
				if (left > startLeft){
					left = startLeft;
				}
				else if ( left < startLeft + xMove ){
					left = startLeft + xMove;
				}
			}
            var position = $(this).css('float');
            if(position =='left'){
                $(this).css('margin-left', left+'px');
            }
            else if(position =='right'){
                $(this).css('margin-right', left+'px');
            }
            else{
                $(this).css('left', left+'px');
            }
		});
	
	}
});
