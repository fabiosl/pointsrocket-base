require 'rails_helper'

RSpec.describe SheetWriter do

  describe 'write' do
    let(:filepath) { Rails.root.join('spec/lib/sheet_write_spec_data_generated.xls') }
    let(:data) {
      [
        ['dia', 'mes', 'ano'],
        ['1', '2', '3']
      ]
    }

    subject {
      sub = described_class.new
      sub.filepath = filepath
      sub.data = data
      sub.write
    }

    it "runs" do
      subject
    end

  end

end
