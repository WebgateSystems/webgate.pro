var $slideshow;
var $nav;
var interval;
$(function(){
	var delay = 4000;
	var time_slide = 900;
	$slideshow = $(".slideshow");
	$nav = $(".slider_nav");
	var tabcss = {
		'position':'absolute',
		'top':'0',
		'left':'0',
	};
	$(".slide",$slideshow).css(tabcss);
	$(".slide:gt(0)",$slideshow).hide();
	$slideshow.append('<a href="#" class="prev"></a><a href="#" class="next"></a>');
	$("a:first",$nav).addClass("active");
	function slide_next(sens) {
		if(typeof sens=='undefined' || sens==undefined) {
			sens=1;
		}
		var $slideCurrent = $(".slide:visible",$slideshow);
		if(sens>0)
			var $suivante = $slideCurrent.last().next(".slide");
		else
			var $suivante = $slideCurrent.first().prev(".slide");
		if ($suivante.length<1) {
			if(sens>0) $suivante = $(".slide:first",$slideshow);
			else $suivante = $(".slide:last",$slideshow);
		}
		$suivante.stop(true, true).fadeIn(time_slide);
		$slideCurrent.stop(true, true).fadeOut(time_slide);
		$("a",$nav).removeClass("active");
		$("a#"+$suivante.data("nav")).addClass("active");
		$(".slider_nav a").parent().removeAttr('id');
		$(".slider_nav a.active#second").parent().attr('id', 'second');
		$(".slider_nav a.active#third").parent().attr('id', 'third');
		$(".slider_nav a.active#fourth").parent().attr('id', 'fourth');
		$(".slider_nav a.active#fifth").parent().attr('id', 'fifth');
		$(".slider_nav a.active#sixth").parent().attr('id', 'sixth');
	}
	$("a.next",$slideshow).click(
		function(e) {
			slide_next(1);
			e.preventDefault();
			slide_stop();		
		});
	$("a.prev",$slideshow).click(
		function(e) {
			slide_next(-1);
			e.preventDefault();
			slide_stop();
		});
	$("a",$nav).mouseenter(
		function() {
			clearInterval(interval);
			$("a",$nav).removeClass("active");
			$(this).addClass("active");
			$(".slide",$slideshow).stop(true, true).fadeOut(time_slide);		
			var id = $(this).attr("id");
			$(".slide[data-nav="+id+"]",$slideshow).stop(true, true).fadeIn(time_slide);
		});
	$("a",$nav).mouseleave(slide_start);
	$slideshow.mouseenter(slide_stop);
	$slideshow.mouseleave(slide_start);
	function slide_start() {
		clearInterval(interval);
		interval = setInterval(function() { slide_next(1); },delay);
	}
	function slide_stop() {
		clearInterval(interval);
	}
	slide_start();
});
