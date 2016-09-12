class RenameTaxonomyExpertises < ActiveRecord::Migration
  def change
    taxonomic_expertises = {
      "Bonobo" => "Bonobo (Pan)",
      "Gorilla" => "Gorilla (Gorilla)",
      "Chimpanzee" => "Chimpanzee (Pan)",
      "Orangutan" => "Orang-utan (Pongo)"
    }

    taxonomic_expertises.each do |old, new|
      Expertise.where(name: old).update_all(name: new)
    end
  end
end
