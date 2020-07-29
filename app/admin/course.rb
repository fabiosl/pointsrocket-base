ActiveAdmin.register Course do
  menu parent: 'Cursos', label: 'Todos os Cursos', priority: 0

  permit_params :name, :description, :avatar, :comming_soon,
                chapters_attributes: [:id, :name, :description,
                  steps_attributes: [:id, :name, :step_type, :description,
                    step_questions_attributes: [:id, :question, :hint, :score,
                      step_question_options_attributes: [:id, :content, :correct]
                    ],
                    archives_attributes: [:id, :name, :archive, :archiveable_id, :archiveable_type
                    ]
                  ]
                ]

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :name
      f.input :avatar
      f.input :description
      f.input :comming_soon
    end

    f.has_many :chapters, allow_destroy: true do |chapter|
      chapter.input :name
      chapter.input :description, as: :wysihtml5, commands: :all, blocks: [ :p, :h2, :h3]

      chapter.has_many :steps, allow_destroy: true do |step|
        step.input :step_type
        step.input :name
        step.input :description, as: :wysihtml5, commands: :all, blocks: [ :p, :h2, :h3]
        step.input :url

        step.has_many :archives, allow_destroy: true do |archive|
          archive.input :name
          archive.input :archive, as: :file, hint: ("Arquivo atual: <a href='#{archive.object.archive.url}' target='_blank'>Download</a>".html_safe() if archive.object.archive)
        end

        step.has_many :step_questions, allow_destroy: true do |question|
          question.input :question
          question.input :hint
          question.input :score

          question.has_many :step_question_options, allow_destroy: true do |option|
            option.input :content
            option.input :correct
          end
        end
      end
    end

    f.actions
  end
end
