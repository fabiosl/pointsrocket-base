class AddAttachmentImageToCursoLandings < ActiveRecord::Migration
  def self.up
    change_table :curso_landings do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :curso_landings, :image
  end
end
