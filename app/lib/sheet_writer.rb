class SheetWriter
  attr_accessor :filepath, :data

  def write
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet

    header_format = Spreadsheet::Format.new(
      :weight => :bold,
      :horizontal_align => :center,
      :locked => true
    )

    sheet1.row(0).default_format = header_format

    data.each_with_index do |row, index|
      sheet1.row(index).replace(row)
    end

    # cols_size = data.inject({}) do |memo, item|
    #   item.each_with_index do |str, index|
    #     memo[index] ||= [str.size, (memo[index]||0)].max
    #   end

    #   memo
    # end

    # cols_size.keys do |index|
    #   sheet1.column(index).width = col_size[index] + 5
    # end

    book.write(filepath)
  end
end
