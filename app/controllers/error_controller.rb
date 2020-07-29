class ErrorController < ApplicationController
  def index
    raise "Erro qualquer"
  end

  def internal_error
    render status: 500, layout: false
  end
end
