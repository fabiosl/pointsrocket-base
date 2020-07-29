namespace :fix_steps do

  desc 'Fix free steps'
  task :set_free_steps => :environment do
    construct = Course.where(slug: 'construct-2').first

    if construct
      construct.steps.update_all(free: false)
      construct.chapters.limit(2).each do |chapter|
        chapter.steps.update_all(free: true)
      end
    end

    scratch = Course.where(slug: 'scratch').first

    if scratch
      scratch.steps.update_all(free: false)
      scratch.chapters.limit(1).each do |chapter|
        chapter.steps.update_all(free: true)
      end
    end

    stencyl = Course.where(slug: 'stencyl').first

    if stencyl
      stencyl.steps.update_all(free: false)
      stencyl.chapters[0].steps.update_all(free: true)
      stencyl.chapters[1].steps.order('position asc').limit(11).update_all(free: true)
    end
  end

end
