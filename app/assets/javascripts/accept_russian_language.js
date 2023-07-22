$(document).ready(function () {

  $('#acceptBtn').click(function () {
    new AcceptRuLanguage().accept();
  })

  $('#declineBtn').click(function () {
    new AcceptRuLanguage().decline();
  })

  $('.decline-btn').click(function () {
    new AcceptRuLanguage().changeLanguageToEn();
  })
})

class AcceptRuLanguage {

  constructor() {
    this.messageBlock = $('.accept-russian')
    this.declineMessage = $('.decline-text')
  }


  accept() {
    this.acceptRequest();
    this.removeMessageBlock();
  }

  decline() {
    this.addHideClassToBatton();
    this.declineMessage.removeClass('hide')
    setInterval(function () { window.location.replace($('.decline-btn').data().url) }, 3000);
  }

  removeMessageBlock() {
    this.messageBlock.remove();
  }

  addHideClassToBatton() {
    $('.next').addClass('hide')
    $('.bx-next').addClass('hide')
  }

  changeLanguageToEn() {
    window.location.replace($('.decline-btn').data().url);
  }

  acceptRequest() {
    $.ajax({
      type: 'get',
      url: '/',
      data: { 'locale': 'ru', 'user_accepted': true },
      contentType: 'application/json',
    });
  }
}
