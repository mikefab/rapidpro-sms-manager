class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  def index
    @primary_nodes = {}
    Record.all.group_by{|e| e.primary}.keys.each do |e|
      @primary_nodes[e] = Record.primary_node_text(e)
    end
  end


  def rumors

  end

end
