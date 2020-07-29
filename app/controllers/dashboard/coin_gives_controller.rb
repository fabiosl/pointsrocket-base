class Dashboard::CoinGivesController < DashboardController
  def create
    if current_user.has_coins_quantity?(total_coins) && !current_user.admin?
      coin_give = CoinGive.create(
        content: coin_gives_params[:content],
        user: current_user
      )
      get_recipient_ids_from_content.each do |id|
        user = User.find(id)

        coin_give.coin_users.create(
          sender_id: current_user.id,
          recipient_id: user.id,
          points: coin_gives_params[:points],
          hashtags: get_hashtags_from_content
        )
      end

      render json: {
              recipient: coin_gives_params[:recipient_names].join(', '),
              sender: User.find(current_user.id),
              points: coin_gives_params[:points]
             },
             status: :created
    else
      render json: { error: I18n.t('controllers.dashboard.coin_users.error.not_enough_coins') },
             status: :unprocessable_entity
    end
  end

  private

  def coin_gives_params
    params.require(:coin_give)
          .permit(:content, :points, :recipient_names => [])
  end

  def get_recipient_ids_from_content
    recipient_mention_regexp = /mention-user-id="(\d+)"/
    coin_gives_params[:content].scan(recipient_mention_regexp).flatten!
  end

  def get_hashtags_from_content
    hashtags_regexp = /(?<!\")#([a-zA-Z\u00C0-\u00FF\d-]+)(?!\")/i
    coin_gives_params[:content].scan(hashtags_regexp).flatten!
  end

  def total_coins
    get_recipient_ids_from_content.size * coin_gives_params[:points].to_i
  end
end
