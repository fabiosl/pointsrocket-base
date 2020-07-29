def creates_domains
  domains_names = %w(nyx vichy kiehls)

  domains_names.each do |domain_name|
    Domain.create(
      name: domain_name,
      url: domain_name,
      subdomain: domain_name,
      dashboard_menu_image: File.open("#{Rails.root}/public/loreal/#{domain_name}-logo.jpg", 'r')
    )
  end
end


creates_domains



# def create_plans
#   Plan.where(name: "Anual", duration:12, price: '39,90', active: true, moip_code: "anual", trial_days: 7).first_or_create
#   Plan.where(name: "Mensal", duration:1, price: '69,90', active: true, moip_code: "mensal", trial_days: 0).first_or_create
#   Plan.where(name: "Trimestral", duration:3, price: '59,90', active: true, moip_code: "trimestral", trial_days: 0).first_or_create
#   Plan.where(name: "Semestral", duration:6, price: '49,90', active: true, moip_code: "semestral", trial_days: 0).first_or_create
# end

# def create_badges
#   Badge.delete_all

#   Badge.create!(
#     name: "Iniciou um curso",
#     slug: "iniciou-um-curso",
#     badge_points: 150,
#     badgeable_type: "Course",
#     badge_type: "simple",
#     tag_list: "loreal",
#     category: "Plataforma",
#     hint: "Inicie qualquer curso da plataforma e destrave essa conquista!",
#     avatar: File.open("app/assets/images/badges/platform/iniciou-um-curso.png", "r")
#   )

#   Badge.create!(
#     name: "Conta de Facebook associada",
#     slug: "facebook-associated",
#     badge_points: 150,
#     badgeable_type: "Course",
#     tag_list: "loreal",
#     badge_type: "simple",
#     category: "Plataforma",
#     hint: "Associe sua conta de Facebook para destravar essa conquista!",
#     avatar: File.open("app/assets/images/badges/platform/facebook-associated.png", "r")
#   )

#   Badge.create!(
#     name: "Membro ativo da comunidade",
#     slug: "aprendiz-do-forum",
#     badge_points: 150,
#     badgeable_type: "Course",
#     tag_list: "loreal",
#     badge_type: "simple",
#     category: "Plataforma",
#     hint: "Essa conquista será destravada ao fazer ou responder uma pergunta em nossa comunidade!",
#     avatar: File.open("app/assets/images/badges/platform/aprendiz-do-forum.png", "r")
#   )

#   Badge.create!(
#     name: "Torcedor fanático!",
#     slug: "torcedor",
#     badge_points: 250,
#     badgeable_type: "Course",
#     tag_list: "loreal",
#     badge_type: "simple",
#     category: "Partidas",
#     hint: "Garanta presença em um dos jogos da CBFA e destrave essa conquista!",
#     avatar: File.open("app/assets/course_files/cbfa/badges/partida.png")
#   )

#   Badge
# end

# def master_user
#   User.where(master: true).first_or_create do |user|
#     user.name = "Admin"
#     user.tag_list = "loreal"
#     user.email = "admin@loreal.com.br"
#     user.password = 'loreal123'
#   end
# end

# def slugify_string(string)
#   string.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
# end

# def course_json(course_path)
#   JSON.parse(File.read("#{course_path}/course.json"))
# end

# def create_course(course_path)
#   course = create_course_object(course_path)
#   create_course_badge(course_path)
#   create_course_chapters(course_path)
# end

# def create_category(category_json)
#   if Category.where(category_json.slice("slug")).any?
#     return Category.where(category_json.slice("slug")).first
#   else
#     return Category.create!(category_json)
#   end
# end

# def create_course_object(course_path)
#   json = course_json(course_path)
#   category = create_category(json["category"])
#   course = Course.create!(
#     name: json["course_title"],
#     slug: slugify_string(json["course_title"]),
#     avatar: File.open("#{course_path}logo.jpg", "r"),
#     description: json["course_description"],
#     tag_list: json["tag_list"],
#     category: category
#   )
# end

# def create_course_badge(course_path)
#   tipo = "Educação"
#   tipo = "Produto" if course_path.include? "produto"

#   course = Course.last
#   json = course_json(course_path)
#   if json["has_badge"]
#     course.badge = Badge.create!(
#       name: "Curso \"#{json["course_title"]}\" finalizado",
#       badge_points: json["badge_points"],
#       tag_list:"fabio,loreal",
#       badgeable_id: course.id,
#       badgeable_type: "Course",
#       badge_type: "simple",
#       category: tipo,
#       slug: slugify_string(course.name),
#       avatar: File.open("#{course_path}/course_badge.png", "r")
#     )
#   end
# end


# def create_course_chapters(course_path)
#   course = Course.last
#   json = course_json(course_path)

#   for json_chapter in json["chapters"]

#     chapter = course.chapters.create!(
#       name: json_chapter["name"],
#       description: json_chapter["description"] || "Olar")
#     if json_chapter["badge"]["has_badge"]
#       puts "script needs to be updated to insert chapter badges"
#     end

#     create_chapter_steps(chapter, json_chapter["steps"])

#   end
# end

# def create_chapter_steps(chapter, steps)
#   step_counter = 1
#   for step in steps
#     if step["step_type"] == "video"
#       create_video_step(chapter, step, step_counter)
#     elsif step["step_type"] == "quiz"
#       create_quiz_step(chapter, step, step_counter)
#     else
#       puts "YOUUU MAAAD, BRO? #{step["step_type"]}"
#     end
#     step_counter += 1
#   end

# end

# def create_video_step(chapter, step, step_counter)
#   video = chapter.steps.create!(
#       step_type: "Vídeo",
#       description: "",
#       name: step["step_title"],
#       url: step["video_url"],
#       position: step_counter
#   )
#   archive = video.archives.create!(
#     name: 'Material de Apoio',
#     archive: File.open('app/assets/course_files/loreal/loreal-apoio.pdf')
#   )

# end

# def create_quiz_step(chapter, step_json, step_counter)

#   step = chapter.steps.create!(
#     name: step_json["step_title"],
#     description: "",
#     position: step_counter,
#   step_type: "Quiz")

#   position_step_question = 0;
#   for question in step_json["questions"]
#     step_question = step.step_questions.create!(
#       question: question["question_title"],
#       score: 10,
#       position: position_step_question + 1)

#     step_question.step_question_options.create!(
#       content: question["question_answer"],
#       correct: true
#     )

#     for option in question["other_options"]
#       step_question.step_question_options.create!(
#         content: option,
#         correct: false
#       )
#     end
#   end
# end

# def create_courses

#   # Course.delete_all
#   # Chapter.delete_all
#   # Step.delete_all
#   # Category.delete_all
#   # StepQuestionOption.delete_all
#   # Point.delete_all
#   # BadgeUser.delete_all


#   # create_course("app/assets/course_files/cbfa/educacao/introducao/")
#   # create_course("app/assets/course_files/cbfa/educacao/arbitragem/")
#   # create_course("app/assets/course_files/cbfa/educacao/coaching/")
#   # create_course("app/assets/course_files/cbfa/educacao/cheerleader/")
#   create_course("app/assets/course_files/cbfa/educacao/usando_a_plataforma/")
# end



# def create_question(step, title, position, answers, score=10)
#   step_question = step.step_questions.create!(question: title, position: position, score: score)
#   step_question.step_question_options.create!(answers)
# end

# def create_campaign
#   Campaign.delete_all

#   # Campaign.create(
#   #   title:"15 dias com a L'Oréal em Paris!",
#   #   description: "Os 15 melhores profissionais de L'Oréal ganharão uma viagem de 15 dias com tudo pago para conhecer a sede da L'Oréal, em Clichy, Hauts-de-Seine, na França.",
#   #   start_date: DateTime.parse("2016-03-01 00:00:00"),
#   #   tag_list:"loreal",
#   #   end_date: DateTime.parse("2016-12-31 23:59:00"),
#   #   image: File.open("app/assets/course_files/loreal/campaigns/loreal-paris.jpg", "r"),
#   #   badges: [ Badge.where(slug: "influenciador-de-instagram").first,
#   #             Badge.where(slug: "loreal-events-fan").first, #
#   #             Badge.where(slug: "aprendiz-do-forum").first # alcancar pelo menos 50 votos positivos
#   #           ]
#   # )

#   Campaign.create(
#     title:"Você no Super Bowl 2016!",
#     description: "Você é apaixonado(a) por futebol americano? Entre nessa e saiba já como garantir o seu par de ingressos para a final do Superbowl 2016!",
#     start_date: DateTime.parse("2016-03-01 00:00:00"),
#     tag_list:"loreal",
#     end_date: DateTime.parse("2016-04-25 23:59:00"),
#     image: File.open("app/assets/course_files/cbfa/campaigns/nfl.jpg", "r"),
#     badges: [
#       Badge.where(slug: "torcedor").first
#     ]
#   )

# end

# def load_users users_txt
#   homens = []
#   mulheres = []
#   File.open(users_txt, 'r').each_line do |line|
#     l = line.split("\t")
#     homens << l[1].gsub("\n", "")
#     mulheres << l[3].gsub("\n", "")
#   end

#   [homens, mulheres]
# end

# def create_users
#   User.delete_all
#   User.create!(email: 'cna@pointsrocket.com', password: 'cnapoints', name: 'CNA', tag_list: 'cna')

#   homens_names, mulheres_names = load_users("app/assets/course_files/loreal/users/users.txt")

#   male_glob =  Dir.glob("app/assets/images/fake-avatars/large/males/*")
#   female_glob =  Dir.glob("app/assets/images/fake-avatars/large/females/*")

#   mulheres_names.each do |name|
#     ap "#{name}@email.com".gsub(' ', '')
#     user = User.create!({
#       name: name,
#       email: "#{name.downcase}.@email.com".gsub(' ', ''),
#       password: "loreal1234",
#       tag_list: "loreal"
#     })
#     user.avatar = File.open(female_glob.sample, 'r')
#     user.save
#   end

#   homens_names.each do |name|
#     ap "#{name}@email.com".gsub(' ', '')
#     user = User.create!({
#       name: name,
#       email: "#{name}@email.com".gsub(' ', ''),
#       password: "loreal1234",
#       tag_list: "loreal"
#     })
#     user.avatar = File.open(male_glob.sample, 'r')
#     user.save
#   end

#   mulheres_names.each do |name|
#     ap "#{name}@email.com".gsub(' ', '')
#     user = User.create!({
#       name: name,
#       email: "#{name}@email.com".gsub(' ', ''),
#       password: "loreal1234",
#       tag_list: "loreal"
#     })
#     user.avatar = File.open(female_glob.sample, 'r')
#     user.save
#   end
# end

# def slugged(string)
#   string.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
# end

# # Trivias::Engine.load_seed
# # create_users
# # master_user
# # create_plans
# # create_badges
# create_courses
# # create_campaign
