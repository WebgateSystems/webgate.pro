class BlacklistsController < ApplicationController
  layout 'blacklist'

  def blacklist; end

  def create
    return if Blacklist.find_by(ip: request.remote_ip)

    user_block = Blacklist.new(ip: request.remote_ip)
    user_block.save

    respond_to do |format|
      format.html { redirect_to blacklist_path, status: :created }
    end
  end
end
