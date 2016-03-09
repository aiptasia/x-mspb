class CreateScrapedProducts < ActiveRecord::Migration
  def change
    create_table :scraped_products do |t|
      t.string :page_uri
      t.string :name
      t.string :application
      t.string :engine_type
      t.string :quality
      t.string :category
      t.string :viscosity
      t.string :acea
      t.string :api
      t.string :homologation
      t.string :is_dpf
      t.string :is_fuel_eco
      t.string :pdf_uri
      t.string :pdf_text
      t.string :img_uri

      t.timestamps null: false
    end
  end
end
