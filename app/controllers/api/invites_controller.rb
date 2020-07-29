module Api
  class InvitesController < Api::BaseController
    include InvitesHelper
    include ControllerApiDomainHelper

    def bulk_invite
      if params[:invites].present?
        emails = params[:invites].split(',').join("\n"
          ).split(' ').join("\n").split("\n")

        invites = emails.map do |email|
          if email.present?
            Invite.create_for email
          end
        end

        invites = invites.select do |invite|
          not invite.nil?
        end

        invites.each do |invite|
          InviteMailer.invite(invite, @domain).deliver
        end

        render json: {created: true}, status: :created
      else
        render json: {message: "You must pass invites"}, status: :unprocessable_entity
      end
    end
  end
end
