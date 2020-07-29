
#console_communities (no console principal, para lançar o console rails do ambiente communities).

turner #entra no ambiente da turner, já estando no console rails


# Imprime usuários ingratos (que nunca elogiaram ninguém)
def print_ingratos
    ja_elogiaram = []
    for elogio in CoinUser.all
        ja_elogiaram << elogio.sender if not ja_elogiaram.include? elogio.sender 
    end
    
    for user in User.all
        if not ja_elogiaram.include? user
            puts "O usuario #{user.email} nunca elogiou ninguém"
        end
    end
end 


print_ingratos