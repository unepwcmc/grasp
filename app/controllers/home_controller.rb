class HomeController < ApplicationController
  def index
    @json = File.read(Rails.root.join("config/questionnaire.json"))
    puts @json
  end
end
