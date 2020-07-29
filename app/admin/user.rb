ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :admin, :tag_list

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :tag_list
    actions
  end

  filter :email_cont
  filter :name_cont
  filter :created_at
  # should work!
  filter :comments_body

  controller do
    # skip blank validation of password
    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin
      para "Tags must be separated by comma (spaces are allowed too) ex: onrocket, good student, paied"
      f.input :tag_list
    end
    f.actions
  end

end
