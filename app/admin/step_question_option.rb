ActiveAdmin.register StepQuestionOption do
  menu parent: 'Cursos', label: 'Exercícios (Opções)', priority: 5

  permit_params :content, :correct, :step_question_id
end
