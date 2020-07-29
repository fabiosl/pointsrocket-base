#console_communities (no console principal, para lançar o console rails do ambiente communities).

melissa #entra no ambiente da melissa, já estando no console rails

list_user_emails = []

for ue in list_user_emails
    ue = ue.strip
    user_name = ue.split("@")[0].upcase.sub(".", " ")
    user = User.where(email: ue).first

    if user == nil
        puts "o usuário #{ue} era novo, tou criando"
        User.new(email: ue, password: ue, name: ue.split("@")[0].upcase, location: user_name, name: user_name, locale: "pt-BR" ).save
    end 
end 