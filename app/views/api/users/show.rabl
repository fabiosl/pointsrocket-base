object @user
extends "api/users/user", locals: { unread_notifications_count: true, full_data: params[:full_data] || @show_full_data }
