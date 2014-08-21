
function resizePageContentHeight(){
	//for page file,
	//make page content height
    var height=0;
    $('.IUPageContent').siblings().each(function(){height += $(this).height()});
    
    //@deprecated
    //remove to set pageContent height
    
	//make min height of page content
	var minHeight=0;
    $('.IUPageContent').children().each(function(){
		if (minHeight < $(this).height() + $(this).position().top){
			minHeight = $(this).height() + $(this).position().top;
		}
    });
    $('.IUPageContent').css('min-height', minHeight+'px');
}



function resizeCollection(){
	$('.IUCollection').each(function(){
		var responsive = $(this).attr('responsive');
		responsiveArray = eval(responsive);
		count = $(this).attr('defaultItemCount');
		viewportWidth = $(window).width();
		for (var index in responsiveArray){
			dict = responsiveArray[index];
			width = dict.width;
			if (viewportWidth<width){
				count = dict.count;
			}
		}
		widthStr = 1/count *100 + '%';
		$(this).children().css('width', widthStr);
	});
}

function reframeCenterIU(iu){
    //if flow layout, margin auto
    //if absolute layout, set left
    if($(iu).attr('horizontalCenter')=='1'){
        $(iu).css('margin-left', 'auto');
        $(iu).css('margin-right', 'auto');
        $(iu).css('left','');
        var pos = $(iu).css('position');
        if (pos == 'absolute'){
            var parentW;
            var parent = $(iu).parent();
            if(parent.prop('tagName') == 'A'){
                parentW = parent.parent().width();
            }
            else{
                parentW = $(iu).parent().width();
            }
            
            var myW = $(iu).width();
            $(iu).css('left', (parentW-myW)/2 + 'px');
        }
    }
    
}

function reframeCenter(){
    
    var respc = $('[horizontalCenter="1"]').toArray();
    $.each(respc, function( i, iu ){
        reframeCenterIU(iu);
    });
}

function resizePageLinkSet(){
	$('.PGPageLinkSet div').each(function(){
		len = $(this).children().children().length;
		m = parseFloat($(this).children().children().children().css('margin-left'));
		w = $(this).children().children().children().width();
		width = (2*m+w)*len;
		$(this).width(width+'px');
	});
}



$(window).resize(function(){
                 console.log("resize window : iuframe.js");
                 resizePageContentHeight();
                 resizeCollection();
                 reframeCenter();
				 resizePageLinkSet();
                 });

$(document).ready(function(){
                 console.log("ready : iuframe.js");
                 });


