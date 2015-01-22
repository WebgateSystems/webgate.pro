class TeamController < ApplicationController

  def index
    @team = Member.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @member = Member.find(params[:id])
  end
end
