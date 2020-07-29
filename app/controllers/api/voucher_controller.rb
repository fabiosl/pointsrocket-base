module Api
  class VoucherController < Api::BaseController

    def voucher_info
      voucher = params[:voucher]
      franchisee = Franchisee.all.where(token: voucher).first
      if franchisee.present?
        render json: {
          voucher: voucher,
          type: :franchisee,
          message: "Parabéns, este voucher pertence a <b>#{franchisee.name}</b>."
        }
        return
      end

      render nothing: true, status: :not_found
    end
  end
end
