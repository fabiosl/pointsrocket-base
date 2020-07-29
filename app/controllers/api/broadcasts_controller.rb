module Api
  class BroadcastsController < Api::BaseController
    include BroadcastsHelper
    include ControllerApiDomainHelper

    before_action :set_broadcast, only: [:reward]

    def reward
      current_user.visualizations.build(
        broadcast_id: @broadcast.id,
        status: 'complete'
      )
      if current_user.save
        add_points_to_current_user
        add_badge_to_current_user
        render json: { 
          user_id: current_user.id,
          points: current_user.points.to_i,
          badges: current_user.badges
        }
      else
        render json: { errors: current_user.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    private

    def add_points_to_current_user
      current_user._add_points(pointable: @broadcast, value: @broadcast.points)
    end

    def add_badge_to_current_user
      current_user.add_badge(@broadcast.badge)
    end

    def set_broadcast
      @broadcast = Broadcast.find(params[:id])
    end
  end
end