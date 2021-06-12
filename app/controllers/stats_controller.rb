class StatsController < ApplicationController
  def index
    @stats = Stat.all
  end

  def search
    stat = find_stat(params[:stat])
    unless stat
      flash[:alert] = 'Stats not found'
      return render action: :index
    end
  end

end
