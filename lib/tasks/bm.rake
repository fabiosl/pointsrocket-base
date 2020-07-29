namespace :bm do

  desc 'Seed bm data'
  task :seed => :environment do
    if not Course.where(name: 'BuzzMonitor').any?
      course = Course.create!(name:  "BuzzMonitor", slug: "buzzmonitor", avatar: File.open("app/assets/course_files/bm/perguntas-icon.png", "r"), description: "Aprenda como utilizar a melhor plataforma de monitoramento e SCRM do mundo", tag_list: 'bm')
      course.badge = Badge.create!(name: "Curso de #{course.name} finalizado", badge_points: 500, badgeable_id: course.id, badgeable_type: "Course", category: "Construct 2", slug: "curso-construct2", avatar:File.open("app/assets/images/badges/bm/perguntas-icon.png", "r"), badge_type: 'simple', tag_list: 'bm')

      chapter = course.chapters.create!(name: "Perguntas", description: 'Teste seus conhecimentos')
      chapter.badge = Badge.create!(name: "Capítulo \"#{chapter.name}\" finalizado", badge_points: 100, badgeable_id: chapter.id, badgeable_type: "Chapter", category: "Construct 2", slug:"conhecendo-o-construct2", avatar:File.open("app/assets/images/badges/construct2/conhecendo-o-construct2.png", "r"), badge_type: 'simple', tag_list: 'bm')

      create_questions_by_txt Rails.root.join('app', 'assets', 'course_files', 'bm', 'perguntas.txt'), chapter
    end
  end

  def create_questions_by_txt txt, chapter
    questions = []
    question_buff = {}
    first_question_line = true

    txt.each_line do |line|
      if line == "\n"
        questions << question_buff if question_buff.present?

        question_buff = {}
        first_question_line = true
        next
      end

      if first_question_line
        first_question_line = false
        question_buff[:question] = remove_question_count_or_letter line
      else
        question_buff[:answers] ||= []
        ans_buff = line.split(' | ')
        correct = " #{ans_buff[1].gsub('\n', '')} ".strip
        question_buff[:answers] << {
          answer: remove_question_count_or_letter(ans_buff[0]),
          correct: correct == "true"
        }
      end
    end

    questions << question_buff if question_buff.present?

    create_questions_by_config questions, chapter
  end

  def remove_question_count_or_letter str
    str.gsub!(/^[0-9A-Z]+\)\s/, "")
    str.gsub!(/\n$/, "")
    str
  end

  def create_questions_by_config questions, chapter
    step_counter = 0

    questions.each do |question|
      step_counter += 1

      step = chapter.steps.create!(
      name: "Quiz - Pergunta #{step_counter}",
      description: '',
      position: step_counter,
      step_type: "Quiz")

      position_step_question = 0
      step_question = step.step_questions.create!(question: question[:question], score: 10, position: position_step_question += 1)
      question[:answers].each do |answer|
        step_question.step_question_options.create!(content: answer[:answer], correct: answer[:correct])
      end
    end

  end

end
