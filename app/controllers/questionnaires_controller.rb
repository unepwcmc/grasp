class QuestionnairesController < ApplicationController
  # Authenticate user and load CanCanCan permissions
  before_action :authenticate_user!

  def template
    @template = JSON.parse(Questionnaire.load)
  end
end
