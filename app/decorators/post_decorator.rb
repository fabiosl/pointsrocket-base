class PostDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def mail_content
    domain = Domain.find_by(subdomain: Apartment::Tenant.current)
    iframe_regex = /<iframe.*?(?<=src=\")[\/]*([^\s]+)(?=[^\s])[\"].*?\/iframe>/
    
    object.content.gsub(iframe_regex) do
      # $1 refers to video url
      %{
        <a href='#{$1}' target='_blank'>
        <img src='#{domain.get_url}/original/player.jpg' style='display: block' width='300'>
        </a>
      }
    end
  end
end
