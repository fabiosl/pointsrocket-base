# Serve para disparar eventos cadastrados no banco de dados
# event => nome do evento
# args, primeiro argumento é requerido, sempre será um domain
#
# ex:
#
#   TriggerEvent.new.run "employee_advocacy_post_created", domain, post
#   TriggerEvent.new.run "watch_step", domain, step, user


class TriggerEvent
  attr_reader :br_badges

  def initialize
    @br_badges = []
  end

  def run event, *args
    domain = args.first
    if domain.is_a? String
      domain = Domain.find_by subdomain: domain
    end

    raise "O primeiro argumento deve ser um domínio, foi passado #{domain.inspect}" if not domain.present? or not domain.is_a? Domain

    domain.domain_br_badge_events.where(event: event).each do |domain_br_badge_event|
      begin
        br_badge = domain_br_badge_event.br_badge.constantize.new(event, *args)
        br_badge.run
        @br_badges << br_badge
      rescue Exception => e
        ap "exception on runing #{domain_br_badge_event.br_badge} class with #{event} and #{args}"
        ap e.message
        ap e.backtrace
      end
    end

    # independente de ter ou não essa opção no admin, rode pra todos os domínios.
    if event == "challenge_user_update"
      br_badge = ChallengeUserApproved.new(event, *args)
      br_badge.run
      @br_badges << br_badge
    end

    self
  end
end
