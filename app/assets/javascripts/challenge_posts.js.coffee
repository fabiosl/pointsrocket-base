# Limit text to a given number of chars
$('.challenge-post-message').not('.skip-read-more').readmore
  collapsedHeight: 90
  moreLink: "<a href='#'>#{i18next.t('views.general.buttons.read_more')}</a>"
  lessLink: "<a href='#'>#{i18next.t('views.general.buttons.close')}</a>"
