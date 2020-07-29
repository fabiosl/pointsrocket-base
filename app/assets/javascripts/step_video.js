(
  function ($, STEP) {
    var tag = document.createElement('script');
    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    var SECONDS_WATCHED_REQUIRED_TO_POINT,
        isVideoPointed = false,
        elapsedTimePlaying = 0,
        player,
        playerTimer,
        $progressContainer = $('.video-progress-container'),
        $infoMessage = $('#video-info-message'),
        $videoWatchedMessage = $('#video-watched-message'),
        $progressBar = $("#video-progress-bar"),
        $nextStepButton = $('.next-step-button');

    // This function must be global
    window.onYouTubeIframeAPIReady = function () {
      player = new YT.Player('youtube-video', {
        width: '100%',
        height: '400',
        videoId: STEP.video_id,
        events: {
          'onReady': onPlayerReady,
          'onStateChange': onPlayerStateChange
        }
      });
    }

    function onPlayerReady() {
      // Watch 51% of the video to get points from it
      SECONDS_WATCHED_REQUIRED_TO_POINT = player.getDuration() * 0.51;
    }

    function onPlayerStateChange(event) {
      if (event.data == YT.PlayerState.PLAYING && !isVideoPointed) {
        showProgressContainer()
        playerTimer = setInterval(function () {
          elapsedTimePlaying += 1;
          updateProgressBar($progressBar);
          $progressBar.css('width', (progressPercentage() + '%'));

          if (shouldPointVideo() && !isVideoPointed) {
            isVideoPointed = true
            $.post(
              '/dashboard/steps/' + STEP.id + '/point_video'
            )
            .done(function () {
              showVideoWatchedMessage();
              // Enable next step button
              $nextStepButton.data('stepCompleted', true);
              $nextStepButton.attr('data-step-completed', true);
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

    function shouldPointVideo() {
      return elapsedTimePlaying >= SECONDS_WATCHED_REQUIRED_TO_POINT;
    }

    function updateProgressBar($element) {
      var percentageValue = progressPercentage() + '%';
      $element.css('width', percentageValue);
      // Update progress bar label text
      $('#' + $element.data('label-id')).text(percentageValue);
    }

    function progressPercentage() {
      return Math.min(
        Math.round(elapsedTimePlaying / SECONDS_WATCHED_REQUIRED_TO_POINT * 100),
        100
      );
    }

    function showProgressContainer() {
      $infoMessage.addClass('hide');
      $progressContainer.removeClass('hide');
    }

    function showVideoWatchedMessage() {
      $progressContainer.addClass('hide');
      $videoWatchedMessage.removeClass('hide');
    }
  }
)(jQuery, window.STEP);
