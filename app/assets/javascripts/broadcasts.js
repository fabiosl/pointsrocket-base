//= require jquery
//= require gritter/js/jquery.gritter.js

(
  function($, BROADCAST) {
    // This code loads the IFrame Player API code asynchronously.
    var tag = document.createElement('script');

    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    var player,
        playerTimer,
        isBroadcastRewarded = false,
        elapsedTimePlaying = 0,
        $broadcastProgressContainer = $('.broadcast-progress-container'),
        $broadcastInfoMessage = $('#broadcast-info-message'),
        $broadcastWatchedMessage = $('#broadcast-watched-message'),
        $broadcastProgressBar = $("#broadcast-progress-bar");

    // Five minutes in seconds
    var BROADCAST_REWARD_SECONDS = 300;

    // This function must be global
    window.onYouTubeIframeAPIReady = function() {
      player = new YT.Player('player', {
        width: '100%',
        height: '400',
        videoId: BROADCAST.video_id,
        events: {
          'onReady': onPlayerReady,
          'onStateChange': onPlayerStateChange
        }
      });
    }

    function onPlayerReady(event) {
      checkBroadcastStatus(BROADCAST);
      updateBroadcastProgressBar($broadcastProgressBar);
    }

    function onPlayerStateChange(event) {
      if (event.data == YT.PlayerState.PLAYING && !isBroadcastRewarded) {
        showBroadcastProgressContainer()
        playerTimer = setInterval(function () {
          elapsedTimePlaying += 1;
          updateBroadcastProgressBar($broadcastProgressBar);
          $broadcastProgressBar.css('width', (broadcastProgressPercentage() + '%'));

          if (shouldRewardBroadcast() && !isBroadcastRewarded) {
            isBroadcastRewarded = true
            $.post(
              '/api/broadcasts/reward',
              { id: BROADCAST.id }
            )
            .done(function (data) {
              notifyWatchedBroadcast(BROADCAST);
              showBroadcastWatchedMessage();
            })
            .fail(function (error) {
              console.log(error);
            })
            .always(function () {
              clearInterval(playerTimer);
            });
          }
        }, 1000)
      }
      else {
        clearInterval(playerTimer);
      }
    }

    function checkBroadcastStatus(broadcast) {
      if (didCurrentUserViewBroadcast(broadcast)) {
        isBroadcastRewarded = true;
        elapsedTimePlaying = BROADCAST_REWARD_SECONDS;
      }
    }

    function updateBroadcastProgressBar($element) {
      var percentageValue = broadcastProgressPercentage() + '%';
      $element.css('width', percentageValue);
      // Update progress bar label text
      $('#' + $element.data('label-id')).text(percentageValue);
    }

    function broadcastProgressPercentage() {
      return Math.min(
        Math.round(elapsedTimePlaying / BROADCAST_REWARD_SECONDS * 100),
        100
      );
    }

    function shouldRewardBroadcast() {
      return elapsedTimePlaying >= BROADCAST_REWARD_SECONDS;
    }

    function didCurrentUserViewBroadcast(broadcast) {
      return broadcast.visualizations.some(function (item) {
        return item.user_id == USER_ID;
      });
    }

    function showBroadcastProgressContainer() {
      $broadcastInfoMessage.addClass('hide');
      $broadcastProgressContainer.removeClass('hide');
    }

    function showBroadcastWatchedMessage() {
      $broadcastProgressContainer.addClass('hide');
      $broadcastWatchedMessage.removeClass('hide');
    }

    function notifyWatchedBroadcast(broadcast) {
      $.gritter.add({
        title: i18next.t(
          'controllers.broadcasts.reward.earned_points',
          { points: broadcast.points }
        ),
        text: i18next.t(
          'controllers.broadcasts.reward.watched_broadcast',
          { broadcast_title: broadcast.title }
        ),
        class_name: 'custom-gritter',
        sticky: false
      });
    }
  }
)(jQuery, window.BROADCAST);
