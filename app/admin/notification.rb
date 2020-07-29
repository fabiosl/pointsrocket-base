ActiveAdmin.register Notification do
  permit_params :message, :link, :to_all, :notificable_id, :notificable_type, :recipient_id,
    :sender_id

  index do
    selectable_column
    id_column
    column :message
    column :link
    column :to_all
    column :recipient
    column :sender
    actions
  end

  filter :message_cont, label: "mensagem"
  filter :to_all, label: "Pra todos"
  filter :link_cont, label: "Link"
  filter :recipient_name_or_recipient_email_cont, label: "Quem recebeu (email/nome)"
  filter :sender_name_or_sender_email_cont, label: "Quem enviou (email/nome)"

  form do |f|
    f.inputs "Details" do
      f.input :message
      f.input :link
      f.input :to_all
    end
    f.inputs "relations" do
      f.input :sender_id
      f.input :recipient_id
      f.input :notificable_id
      f.input :notificable_type
    end
    f.actions
  end

end
