ActiveAdmin.register Chapter do
  menu parent: 'Cursos', label: 'Capítulos', priority: 1

  permit_params :name, :description, :course_id
end