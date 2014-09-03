function makefullSizeSection(){
    var respc = $('[enableFullSize="1"]').toArray();
	var windowHeight =  $(window).height();
	$.each(respc, function(){
		$(this).css('height', windowHeight+'px');
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
		var width = $(this).width()/count;
		$(this).children().css('width', width.toFixed(0)+'px');
	});
}

function reframeCenterIU(iu, isAlreadyChecked){
	var ius = [];
	if(isAlreadyChecked == true){
		ius.push(iu);
	}
	else{
	    if($(iu).attr('horizontalCenter')=='1'){
			ius.push($(iu));
		}
		ius = $(iu).children('[horizontalCenter="1"]');
	}
    //if flow layout, margin auto
    //if absolute layout, set left

	$.each(ius, function(){
        $(this).css('margin-left', 'auto');
        $(this).css('margin-right', 'auto');
        $(this).css('left','');
        var pos = $(iu).css('position');
        if (pos == 'absolute'){
            var parentW;
            var parent = $(this).parent();
            if(parent.prop('tagName') == 'A'){
                parentW = parent.parent().width();
            }
            else{
                parentW = $(this).parent().width();
            }
            
            var myW = $(this).width();
            $(this).css('left', (parentW-myW)/2 + 'px');
        }
		else if(pos == 'fixed'){
			var windowWidth = $(window).width();
            var myW = $(this).width();
            $(this).css('left', (windowWidth-myW)/2 + 'px');	
		}
    });
    
}

function reframeCenter(){
    var respc = $('[horizontalCenter="1"]').toArray();
    $.each(respc, function( i, iu ){
        reframeCenterIU(iu, true);
    });
}

function resizePageLinkSet(){
	$('.PGPageLinkSet div').each(function(){
		len = $(this).children().children().length;
		m = parseFloat($(this).children().children().children().css('margin-left'));
		w = $(this).children().children().children().width();
		width = (2*m+w)*len;
		$(this).width(width+'px');
        console.log('setting width'+$(this).id+' width : '+width);
	});
}

$(window).resize(function(){
	console.log("resize window : iuframe.js");
	resizeCollection();
	reframeCenter();
	resizePageLinkSet();
	relocateScrollAnimation();
	makefullSizeSection();

});

$(document).ready(function(){
	console.log("ready : iuframe.js");
});


