begin
  if Domain.all.count == 0
    Domain.create!({
      url: 'http://localhost.com:3000',
      name: "localhost",
      default: true
      })
    end
rescue Exception

end
