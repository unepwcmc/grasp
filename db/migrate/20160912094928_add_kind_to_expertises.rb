class AddKindToExpertises < ActiveRecord::Migration
  def change
    add_column :expertises, :kind, :text

    geographic_expertises = ["West Africa", "Central Africa", "East Africa", "Southeast Asia", "Rest of the World"]
    taxonomic_expertises = ["Bonobo (Pan)", "Gorilla (Gorilla)", "Chimpanzee (Pan)", "Orang-utan (Pongo)"]

    Expertise.where(name: geographic_expertises).update_all(kind: "region")
    Expertise.where(name: taxonomic_expertises).update_all(kind: "genus")
  end
end
