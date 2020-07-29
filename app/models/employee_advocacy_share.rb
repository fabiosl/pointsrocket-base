# == Schema Information
#
# Table name: employee_advocacy_shares
#
#  id                        :integer          not null, primary key
#  employee_advocacy_post_id :integer
#  user_id                   :integer
#  social_network            :string(255)
#  user_content              :text
#  schedule_date             :datetime
#  shared_date               :datetime
#  token                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  social_json               :text
#  post_json                 :text
#  where_to_publish          :string(255)
#

class EmployeeAdvocacyShare < ActiveRecord::Base
  # Utilizado no renderizador de json
  # para informar que os pontos foram adicionados
  # para evitar do usuário compartilhar mais de uma vez e
  # ganhar pontos sempre. Ele só ganha na primeira vez que compartilhar.
  attr_accessor :points_added

  validates_presence_of :user, :employee_advocacy_post
  validates_presence_of :user_content, if: lambda { self.social_network.to_sym != :download }

  belongs_to :employee_advocacy_post, inverse_of: :employee_advocacy_shares
  belongs_to :user, inverse_of: :employee_advocacy_shares
  has_many :employee_advocacy_visits, inverse_of: :employee_advocacy_share, dependent: :destroy
  serialize :post_json

  scope :facebook, -> { where(social_network: :facebook) }
  scope :twitter, -> { where(social_network: :twitter) }
  scope :linkedin, -> { where(social_network: :linkedin) }
  scope :instagram, -> { where(social_network: :instagram) }
  scope :download, -> { where(social_network: :download) }


  act_as_pointable
  act_as_timelineable type: :user

  before_save :set_advocacy_post_json

  def set_advocacy_post_json
    if self.employee_advocacy_post.present? and not self.post_json.present?
      self.post_json = JSON.parse self.employee_advocacy_post.to_json
    end
  end
end
