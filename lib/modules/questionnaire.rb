module Questionnaire
  QUESTIONNAIRE_ROOT = Rails.root.join("config/questionnaire")
  QUESTIONNAIRE_PATH = Rails.root.join("config/questionnaire/main.json.erb")

  def self.load
    ERB.new(File.read(QUESTIONNAIRE_PATH)).result(binding)
  end

  def self.pages
    ERB.new(File.read(QUESTIONNAIRE_ROOT.join("pages.json.erb"))).result(binding)
  end

  def self.partial name
    ERB.new(File.read(QUESTIONNAIRE_ROOT.join("pages", "#{name}.json.erb"))).result(binding)
  end

  def self.page name
    ERB.new(File.read(QUESTIONNAIRE_ROOT.join("pages", "#{name}.json.erb"))).result(binding)
  end
end
