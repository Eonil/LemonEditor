//ready collection
$(document).ready(function(){
	/* Initialize IU.JS*/
	
	console.log('iu')
	if (typeof isEditor != 'undefined' && isEditor == true){
		return;
	}
	console.log('start : transition code');
                  
	//Initialize transition
	$('.IUTransition').each(function(){
        var eventType = $(this).attr('transitionevent');
                            
        if (eventType=='mouseOn'){
            $(this).mouseenter(transitionAnimationOn);
            $(this).mouseleave(transitionAnimationOff);
        }
        else {
            $(this).bind(eventType, transitionAnimation);
        }
        var firstObj = $(this).children().filter('.IUItem')[0];
        $(firstObj).css('display', 'block');
        var secondObj = $(this).children().filter('.IUItem')[1];
        $(secondObj).css('display', 'none');
	});
                  
	//move : current viewport pc type
	if(isMobile()==false){
		$('[xPosMove]').each(function(){
			var xPosMove = $(this).attr('xPosMove');
			if ($(this).css('position') == 'absolute'){
				var startLeft = parseFloat($(this).css('left')) - xPosMove;
				$(this).css('left', startLeft + 'px');
				$(this).attr('startLeft', startLeft);
			};
		});
	}
                  
    //Initialize IUMenu
	$('.mobile-button').on('click', function(){
		var menu = $(this).next('ul');
		if (menu.hasClass('open')) {
			menu.removeClass('open');
		}
		else {
			menu.addClass('open');
		}
	});
	
	$('.IUMenuBar > ul > li.has-sub, .IUMenuBar > ul > li > ul > li.has-sub').hover(function(){
		if($(this).hasClass('open')){
			$(this).removeClass('open');
		}
		else{
			$(this).addClass('open');
		}
		
		var menu = $(this).children('ul');
		if (menu.hasClass('open')) {
			menu.removeClass('open');
		}
		else {
			menu.addClass('open');
		}
	});
	
	$('.IUMenuBar a[href]').each(function() {
		var url = window.location.pathname;
		var urlRegExp = new RegExp(url.replace(/\/$/,'')); 
		if(urlRegExp.test(this.href)){
	      $(this).parent().addClass('active');
	  	}
		else{
			if ($(this).parent().hasClass('active')) {
				$(this).parent().removeClass('active');
			}
		}
	  });
                  
                  
    /*INIT_JS_REPLACEMENT*/
                  
	/* Initialize IUFrame.js */
	resizePageContentHeight();
	resizeCollection();
	reframeCenter();
	resizePageLinkSet();
    setTextAutoHeight();
            
    console.log("ready : iuinit");
});
