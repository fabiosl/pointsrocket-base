# == Schema Information
#
# Table name: complete_account_question_options
#
#  id                           :integer          not null, primary key
#  complete_account_question_id :integer
#  name                         :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#

require 'rails_helper'

RSpec.describe CompleteAccountQuestionOption, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
