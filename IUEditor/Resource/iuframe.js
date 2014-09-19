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

function resizeSideBar(){
	var windowHeight =  $(window).height();
	var documentHeight = $( document ).height();
	var height;
	if(windowHeight > documentHeight){
		height = windowHeight;
	}
	else{
		height = documentHeight;
	}
	
	var headerHeight = $('.IUHeader').height();
	var footerHeight = $('.IUFooter').height();
	
	$('.IUSidebar').each(function(){
		var type = $(this).attr('sidebarType');
		var sideBarHeight;
		if(type==0){
			sideBarHeight = height;
		}
		else{
			sideBarHeight = height-headerHeight-footerHeight;
		}
		$(this).css('height', sideBarHeight+'px');
		console.log('sidebar height:'+sideBarHeight);
	});
}


function reframeCenterIU(iu){
	var ius = [];
	if($(iu).attr('horizontalCenter')=='1'){
		ius.push($(iu));
	}
	ius = $.merge(ius, $(iu).find('[horizontalCenter="1"]').toArray());
	arrangeHCenter(ius);
	
	//vertical center
	ius = [];
	if($(iu).attr('verticalCenter')=='1'){
		ius.push($(iu));
	}
	ius = $.merge(ius, $(iu).find('[verticalCenter="1"]').toArray());
	
	arrangeVCenter(ius);
}

function arrangeHCenter(ius){
    //if flow layout, margin auto
    //if absolute layout, set left

	$.each(ius, function(){
        $(this).css('margin-left', 'auto');
        $(this).css('margin-right', 'auto');
        $(this).css('left','');
        var pos = $(this).css('position');
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

function arrangeVCenter(ius){
	$.each(ius, function(){
        $(this).css('margin-top', 'auto');
        $(this).css('margin-bottom', 'auto');
        $(this).css('top','');
        var pos = $(this).css('position');
        if (pos == 'absolute'){
            var parentH;
            var parent = $(this).parent();
            if(parent.prop('tagName') == 'A'){
                parentH = parent.parent().height();
            }
            else{
                parentH = $(this).parent().height();
            }
            
            var myH = $(this).height();
            $(this).css('top', (parentH-myH)/2 + 'px');
        }
		else if(pos == 'fixed'){
			var windowHeight = $(window).height();
            var myH = $(this).height();
            $(this).css('top', (windowHeight-myH)/2 + 'px');	
		}
    });
}

function reframeCenter(){
	arrangeHCenter($('[horizontalCenter="1"]').toArray());
	arrangeVCenter($('[verticalCenter="1"]').toArray());
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
