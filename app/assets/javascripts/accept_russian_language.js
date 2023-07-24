$(document).ready(function() {
  $('#acceptBtn').click(function() {
    new AcceptRuLanguage().accept();
  });

  $('#declineBtn').click(function() {
    new AcceptRuLanguage().decline();
  });
});

class AcceptRuLanguage {
  constructor() {
    this.messageBlock = $('.accept-russian');
    this.declineMessage = $('.decline-text');
  }

  accept() {
    this.acceptRequest();
    this.removeMessageBlock();
  }

  decline() {
    this.addHideClassToBatton();
    this.declineMessage.removeClass('hide');
    this.declineRequest();
    setTimeout(this.redirectToBlacklist, 3000);
  }

  declineRequest() {
    $.ajax({
      type: 'POST',
      url: '/blacklists',
      contentType: 'application/json',
    });
  }

  removeMessageBlock() {
    this.messageBlock.remove();
  }

  addHideClassToBatton() {
    $('.next').addClass('hide');
    $('.bx-next').addClass('hide');
  }

  redirectToBlacklist() {
    window.location.replace($('.decline-btn').data().url);
  }

  acceptRequest() {
    $.ajax({
      type: 'get',
      url: '/',
      data: {locale: 'ru', user_accepted: true},
      contentType: 'application/json',
    });
  }
}
