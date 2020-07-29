object @answer
attributes *[:id, :content, :slug, :linked_content]

child(:user) { attributes :id, :name}

child(:question) { attributes :id, :title }