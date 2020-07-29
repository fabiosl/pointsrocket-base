namespace :fix_accounts do
  task :after_employee_and_domains do
    desc "Fix after employee advocacy with domains and tenants"
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "fix_accounts:after_employee_and_domains"
        end
      end
    end
  end

  task :after_identity_layout_deployed do
    desc 'fix accounts after identity deployed'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "fix_accounts:after_identity_layout_deployed"
        end
      end
    end
  end

  task :after_plans_deployed do
    desc 'fix accounts after plans deployed'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "fix_accounts:after_plans_deployed"
        end
      end
    end
  end

  task :after_employee_advocacy do
    desc 'Fix Emploee Advocacy changes'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "fix_accounts:after_employee_advocacy"
        end
      end
    end
  end

  task :after_employee_advocacy_mail do
    desc 'Fix Emploee Advocacy Mail changes'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "fix_accounts:after_employee_advocacy_mail"
        end
      end
    end
  end

  task :fix_submit_payment_form_field do
    desc 'fix accounts to mark that has submited payment form'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "fix_accounts:fix_submit_payment_form_field"
        end
      end
    end
  end

  task :after_tags_deployed do
    desc 'fix accounts after tags deployed'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "fix_accounts:after_tags_deployed"
        end
      end
    end
  end
end
