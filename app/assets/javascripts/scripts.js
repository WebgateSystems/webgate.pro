﻿$(function(){
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
	$('.carousel_block ul.bx_carousel').bxSlider({
		minSlides: 1,
		maxSlides: 3,
		pager: false,
		slideWidth: 320,
		adaptiveHeight: true,
		slideMargin: 0
	});
	$('.more_info').click(function(){
		$(this).closest('.team_block').find('.columns_container').fadeIn();
		$(this).fadeOut(0);
		$(this).closest('.team_block').find('.service_block_btn').addClass('active');
		/*var hideBlock = $(this).closest('.team_block').find('.columns_container');
		$(this).text('More information');
		$('.columns_container.mob').fadeToggle(300, function() {
			$(this).closest('.team_block').find('.service_block_btn').text(($('hideBlock' + ':visible').length==0) ? 'More information' : 'Hide information');
		});*/
	});
	$('.team_block .service_block_btn').click(function(){
		$(this).removeClass('active');
		$(this).closest('.team_block').find('.columns_container').fadeOut();
		$(this).closest('.team_block').find('.more_info').fadeIn();
	});
	/* Tooltip */
	/* http://iamceege.github.io/tooltipster/ */
	$('#tooltip1').tooltipster({
		position: 'bottom',
		minWidth: 300,
		maxWidth: 300,
		position: 'bottom',
		content: $('<div class="tooltip_block"><p><img src="images/img22.png" /> <strong>PHP</strong> is a server-side scripting language designed for web development but also used as a general-purpose programming language.</p><p>As of January 2013, PHP was installed on more than 240 million websites (39% of those sampled) and 2.1 million web servers.</p><p>More on Wikipedia: <a href="#">PHP article</a></p></div>')
	});
});
