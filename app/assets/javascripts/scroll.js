$(document).ready(function(){
$(".scroll").click(function(event){
//Перехватываем обработку по умолчанию события нажатия мыши
event.preventDefault();
		
//Получаем полный url - например, mysitecom/index.htm#home
var full_url = this.href;
		
//Разделяем url по символу # и получаем имя целевой секции - home в адресе mysitecom/index.htm#home
var parts = full_url.split("#");
var trgt = parts[1];
		
//Получаем смещение сверху для целевой секции
var target_offset = $("#"+trgt).offset();
var target_top = target_offset.top;
		
//Переходим в целевую секцию установкой позиции прокрутки страницы в позицию целевой секции
$('html, body').animate({scrollTop:target_top}, 800);
});
});
