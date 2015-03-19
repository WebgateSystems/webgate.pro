class TeamController < ApplicationController
  layout 'portfolio'

  def index
    @members = Member.rank(:position).all#.page(params[:page]).per(3)
  end

  def show
    @member = Member.find(params[:id])
  end
end
