class TeamController < ApplicationController

  def index
    @team = Member.order(:id)
  end

  def show
    @teammate = Member.find(params[:id])
  end
end
