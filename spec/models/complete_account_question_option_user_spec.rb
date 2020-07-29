# == Schema Information
#
# Table name: complete_account_question_option_users
#
#  id                                  :integer          not null, primary key
#  complete_account_question_option_id :integer
#  user_id                             :integer
#  created_at                          :datetime
#  updated_at                          :datetime
#

require 'rails_helper'

RSpec.describe CompleteAccountQuestionOptionUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
