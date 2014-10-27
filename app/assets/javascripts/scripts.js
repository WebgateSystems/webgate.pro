$(function(){
	$(".slider_nav a#first").hover(function(){
		$(".slider_nav").removeAttr('id');
	});
	$(".slider_nav a#second").hover(function(){
		$(".slider_nav").removeAttr('id');
		$(".slider_nav").attr('id', 'second');
	});
	$(".slider_nav a#third").hover(function(){
		$(".slider_nav").removeAttr('id');
		$(".slider_nav").attr('id', 'third');
	});
	$(".slider_nav a#fourth").hover(function(){
		$(".slider_nav").removeAttr('id');
		$(".slider_nav").attr('id', 'fourth');
	});
	$(".slider_nav a#fifth").hover(function(){
		$(".slider_nav").removeAttr('id');
		$(".slider_nav").attr('id', 'fifth');
	});
	$(".slider_nav a#sixth").hover(function(){
		$(".slider_nav").removeAttr('id');
		$(".slider_nav").attr('id', 'sixth');
	});
	$(".next,.prev").bind("click", function(e){
		$(".slider_nav a").parent().removeAttr('id');
		$(".slider_nav a.active#second").parent().attr('id', 'second');
		$(".slider_nav a.active#third").parent().attr('id', 'third');
		$(".slider_nav a.active#fourth").parent().attr('id', 'fourth');
		$(".slider_nav a.active#fifth").parent().attr('id', 'fifth');
		$(".slider_nav a.active#sixth").parent().attr('id', 'sixth');
	});
//////////////////////////////////////////////
//	$(".lang ul li a").click(function(){
//		$(".lang ul").toggleClass('active');
//	});
	$('.footer_content .up').click(function(){
		$('body,html').animate({
			scrollTop: 0
		}, 800);
		return false;
	});
	$(".carousel_block").carousel({
		dispItems: 3
	});
	$(".feedback textarea,.text_input").focus(function(){
		this.value=""
	});
	$(".text_input:first").blur(function(){
		this.value==""&&(this.value="Imie i Nazwisko:")
	});
	$(".text_input").eq(1).blur(function(){
		this.value==""&&(this.value="Twoj adres email")
	});
	$(".feedback textarea").blur(function(){
		this.value==""&&(this.value="Tresc wiadomosci")
	});
	$('ul.portfolio_carousel').roundabout({
		minScale: 0.7
	});
});