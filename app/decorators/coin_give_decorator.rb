class CoinGiveDecorator < Draper::Decorator
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  delegate_all

  MENTION_REGEX = /<span (?:class=\"[\w\s-]*\") data-mention-user-id=\"(\d+)\">@(.+?)<\/span>/
  POINTS_REGEX = /\+(\d+)/
  HASHTAGS_REGEX = /(?<!\")#([a-zA-Z\u00C0-\u00FF\d-]+)(?!\")/i
  POINTS_HASHTAG_ATWHO_RE = /<span [^<]*>(\+\d+|#[a-zA-Z\u00C0-\u00FF\d-]+)<\/span>/
  BR_RE = /<br[^>]*>/i
  QUERY_REGEX = /atwho-query/

  def formatted_content
    (content || "")
    .gsub(QUERY_REGEX, 'atwho-inserted')
    .gsub(BR_RE, '')
    .gsub(POINTS_HASHTAG_ATWHO_RE, '\1')
    .gsub(MENTION_REGEX) do
      "<b><a href='/dashboard/usuarios/#{$1}'>@#{$2}</a></b>"
    end.gsub(POINTS_REGEX) do
      "<span class=\"plus\">+#{$1}</span>"
    end.gsub(HASHTAGS_REGEX) do
      "<span class=\"hashtag\">##{$1}</span>"
    end
  end

  def formatted_content_for_mail
    domain = Domain.get_current_domain

    (content || "").gsub(BR_RE) do
      ""
    end.gsub(POINTS_HASHTAG_ATWHO_RE) do
      "#{$1}"
    end.gsub(MENTION_REGEX) do
      "<b><a href='#{domain.get_url}/dashboard/usuarios/#{$1}'>@#{$2}</a></b>"
    end.gsub(POINTS_REGEX) do
      "<b>+#{$1}</b>"
    end.gsub(HASHTAGS_REGEX) do
      "<b>##{$1}</b>"
    end
  end

  def formatted_action
    users = coin_users.map {|coin_user| coin_user.recipient}.uniq

    case users.size
    when 0
      I18n.t "coin_give.formatted_action.zero"
    when 1
      person_1 = users[0] == nil ? "" : link_to(users[0].name, user_path(users[0]))
      I18n.t "coin_give.formatted_action.one", person1: person_1
    else
      person_1 = users[0] == nil ? "" : link_to(users[0].name, user_path(users[0]))
      person_2 = users[0] == nil ? "" : link_to(users[1].name, user_path(users[1]))
      I18n.t "coin_give.formatted_action.other", person1: person_1, person2: person_2, count: users.size - 2
    end
  end
end


"+5&nbsp;Boa <span class=\"atwho-inserted\"><span class=\"user-mention\" data-mention-user-id=\"3\">@Fábio Leal</span></span>&nbsp;e <span class=\"atwho-inserted\"><span class=\"user-mention\" data-mention-user-id=\"1\">@Manoel Quirino Neto</span></span>&nbsp;&nbsp;<span class=\"atwho-query\"><span class=\"test\">#team-work</span></span>"
