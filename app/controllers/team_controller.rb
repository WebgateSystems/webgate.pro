class TeamController < ApplicationController

  def index
    @team = Member.order(:id).page(params[:page]).per(10)
  end

  def show
    @member = Member.find(params[:id])
  end
end
