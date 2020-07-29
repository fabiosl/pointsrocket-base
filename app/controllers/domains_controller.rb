class DomainsController < ApplicationController
  before_action :authenticate_user!

  def index
    @domains = Domain.where.not(default: true)
  end

  def new
    authorize! :create, Domain
    @domain = Domain.new
  end

  def create
    authorize! :create, Domain
    @domain = Domain.new(domain_params)
    if @domain.save
      flash[:success] = I18n.t('views.domains.create.success')
      redirect_to domains_path
    else
      render :new
    end
  end

  def destroy
    authorize! :destroy, Domain
    @domain = Domain.find(params[:id])
    if @domain.destroy
      redirect_to domains_path, notice: "Comunidade deletada com sucesso"
    else
      redirect_to domains_path
    end
  end

  private

  def domain_params
    params.require(:domain).permit(:name, :url, :subdomain)
  end
end
