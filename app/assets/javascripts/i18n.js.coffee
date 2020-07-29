# I18n packages
#= require i18next

do ->
  # I18n init
  initConfig =
    lng: 'en'
    lngs: ['en', 'pt-BR']
    fallbackLng: false
    resources:
      en: {
        translation: window.translations.en
      }
      "pt-BR": {
        translation: window.translations["pt-BR"]
      }

  i18next
    .init initConfig, ->
      i18next.changeLanguage window.locale
