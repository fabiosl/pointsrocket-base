ActiveAdmin.register StepQuestion do
  menu parent: 'Cursos', label: 'Exercícios', priority: 4

  permit_params :question, :hint, :score, :step_id
end
