$(function(){
	$('.ico_main,.service_lang,.ico_lang').click(function(){
		$('.header').find('span.mob').removeClass('active');
		$(this).toggleClass('active');
		$('.header').find('.mob_nav:visible').fadeOut().prev('span').removeClass('active');
		$(this).next('.mob_nav:hidden').slideDown();
	});
	$('.mob_nav li a').click(function(){
		$('.header').find('span.mob').removeClass('active');
		$(this).closest('ul').fadeOut();
	});
	$('.footer_content .up').click(function(){
		$('body').animatescroll({scrollSpeed:1000,easing:'easeOutCubic'});
	});
	$('.top_nav li:last,.main li:last').click(function(){
		//$(this).removeAttr('href');
		$('.footer').animatescroll({scrollSpeed:1000,easing:'easeOutExpo'});
	});
	$('#block1').click(function(){
		$('.block_1').animatescroll({scrollSpeed:1000,easing:'easeOutExpo'});
	});
	$('#block2').click(function(){
		$('.block_2').animatescroll({scrollSpeed:1000,easing:'easeOutExpo'});
	});
	$('#block3').click(function(){
		$('.block_3').animatescroll({scrollSpeed:1000,easing:'easeOutExpo'});
	});
	$('#block4').click(function(){
		$('.block_4').animatescroll({scrollSpeed:1000,easing:'easeOutExpo'});
	});
	$('#block5').click(function(){
		$('.block_5').animatescroll({scrollSpeed:1000,easing:'easeOutExpo'});
	});
	$('#block6').click(function(){
		$('.block_6').animatescroll({scrollSpeed:1000,easing:'easeOutExpo'});
	});
	$('.carousel div.mob').slidesjs({
		width: 320,
		height: 387,
		navigation:{
			active: false,
			effect: 'slide'
		}
	});
	$('.carousel_block ul.bx_carousel').bxSlider({
		minSlides: 1,
		maxSlides: 3,
		pager: false,
		slideWidth: 320,
		adaptiveHeight: true,
		slideMargin: 0
	});
});
