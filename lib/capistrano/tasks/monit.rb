namespace :monit do
  %w(start stop restart).each do |task_name|
    desc "#{task_name} Monit"
    task task_name do
      on roles(:app), in: :sequence, wait: 5 do
        sudo "service monit #{task_name}"
      end
    end

    desc "#{task_name} jobs Monit"
    task "#{task_name}_jobs" do
      on roles(:app), in: :sequence, wait: 5 do
        sudo "monit #{task_name} -g #{fetch(:full_app_name)}"
      end
    end
  end
end
