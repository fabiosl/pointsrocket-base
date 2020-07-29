ActiveAdmin.register Voucher do
  permit_params :code, :plan_id, :price, :valid_until, :active, :used_at

  index do
    selectable_column
    id_column
    column :code
    column :plan
    column :price
    column :active
    column :used_at
    column :valid_until
    actions
  end

  filter :code
  filter :plan
  filter :price
  filter :valid_until
  filter :active
  filter :used_at

  form do |f|
    f.inputs "Voucer details" do
      f.input :code
      f.input :plan
      f.input :price
    end

    f.inputs "Others fields" do
      f.input :active
      f.input :valid_until, as: :datepicker
      f.input :used_at, as: :datepicker, :input_html => { :disabled => true }
    end

    f.actions
  end

end
