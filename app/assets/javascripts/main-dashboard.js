//= require ./lib/jquery-2.2.4.js
// require ./lib/twitter-bootstrap-3.3.5.js
// require ./lib/twitter-bootstrap-3.3.1.js
//= require ./lib/bootstrap-3.3.7.js
//= require ./lib/mustache.js
//= require vendor.js
//= require jquery_ujs.js
//= require ./lib/jquery.touchSwipe.min
//= require core.js
//= require backend/app.js
//= require ajax.js
//= require jquery.atwho
//= require ./lib/mentionable
//= require ./lib/pointable
//= require ./lib/hashtagable
//= require steps.js
//= require questions.js
//= require badges.js
//= require badge-modal.js
//= require jquery-text-counter

//= require lodash
//= require readmore
//= require ./lib/summernote/summernote.js

//= require gritter/js/jquery.gritter.js
//= require selectize/js/selectize.js
//= require site/jquery.maskedinput.min.js
//= require backend/pages/dashboard-v1.js

//= require zeroclipboard

//= require parsley/js/parsley.js
//= require inputmask/js/inputmask.js
//= require notify_render
//= require search
//= require notifications
//= require points-earned
//= require live-comments
//= require challenge_user
//= require fixed_scroll
//= require lib/moment-2.18.1
//= require lib/moment.pt-BR
//= require ./lib/vue.min
//= require ./lib/vue-carousel.min
//= require ./lib/spin
//= require ./lib/ladda
//= require timeline_items
//= require timeline_post
//= require timeline_onscreen
//= require campaigns_redeem
//= require dashboard/activities
//= require ios
//= require android
//= require_self

var locale = window.locale || 'en';
moment.locale(locale.toLowerCase());

window.loader = $('#loader');


$('[data-maskedinput]').each(function(){
  var $this = $(this);
  $this.mask($this.data('maskedinput'));
});

if ($(".copy-me").length > 0) {
  new ZeroClipboard($(".copy-me"))
}

$('.form-control.error').each(function(){
  $(this).parents('.form-group').addClass('has-error');
});


$('.hide-after-toggle-button').on('click', function(e){
  e.preventDefault();
  $(this).parents('.hide-after, .show-after').parent().toggleClass('show-after-blocks');
});


$('.cancel-button').on('click', function(e){
  e.preventDefault();

  if (confirm('Tem certeza que quer cancelar')) {
    var reason = $('#user_cancel_reason').val()

    if (!reason) {
      alert('Por favor, nos informe o motivo do cancelamento');
      return;
    }

    $.ajax({
      url: this.href,
      method: 'POST',
      dataType: 'json',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        user: {
          cancel_reason: reason
        }
      },
      success: function(response) {
        alert(response.text);
        location.reload(true);
      }
    });
  }
})


$(document).ready(function() {
  $(window).scroll(function() {
    if ($('body').height() <= ($(window).height() + $(window).scrollTop())) {
      $("#doll-footer").addClass("animation animating bounce");
    }
  });

  // SIDEBAR MENU SWIPE

  var sidebarMenuTapLink = true,
      $sidebarMenu = $('.sidebar-left'),
      $sidebarMenuLinks = $sidebarMenu.find('a');

  $sidebarMenuLinks.click(function(e){
    // Do not go to link page when swipping
    if(!window.sidebarMenuTapLink) {
      e.preventDefault();
    }
  });

  $sidebarMenu.swipe({
    tap: function (event, target) {
      window.sidebarMenuTapLink = true;
    },
    swipeLeft:function(event, direction, distance, duration, fingerCount) {
      $('html').removeClass('sidebar-open-ltr');
      window.sidebarMenuTapLink = false;

    },
    swipeRight:function(event, direction, distance, duration, fingerCount) {
      window.sidebarMenuTapLink = false;
    },
    threshold: 20
  });

  // END - SIDEBAR MENU SWIPE
});


$("#doll-footer").hover(function() {
  $(this).addClass("animation animating tada");
}, function() {
  $(this).removeClass("animation animating tada");
});

if(document.querySelectorAll('.move-me-on-desktop').length) {
  if (window.innerWidth >= 800) {
    document.querySelectorAll('.move-me-on-desktop').forEach(function(dom){
      document.getElementById(dom.getAttribute('target').replace("#", '')).appendChild(dom);
    });
  }
}
