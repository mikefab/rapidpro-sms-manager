class HomeController < ApplicationController
  def index
    @primary_nodes = {}
    Record.all.group_by{|e| e.primary}.keys.each do |e|
      @primary_nodes[e] = Record.primary_node_text(e)
    end
  end


  def rumors
	redirect_to '/'
  end

end
