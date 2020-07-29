ActiveAdmin.register Step do
  menu parent: 'Cursos', label: 'Passos', priority: 3

  permit_params :name, :url, :description, :step_type, :chapter_id
end
