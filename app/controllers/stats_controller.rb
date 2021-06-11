class StatsController < ApplicationController
  def index
    @stats = Stat.all
  end
end
