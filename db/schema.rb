# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160309210925) do

  create_table "scraped_products", force: :cascade do |t|
    t.string   "page_uri"
    t.string   "name"
    t.string   "application"
    t.string   "engine_type"
    t.string   "quality"
    t.string   "category"
    t.string   "viscosity"
    t.string   "acea"
    t.string   "api"
    t.string   "homologation"
    t.string   "is_dpf"
    t.string   "is_fuel_eco"
    t.string   "pdf_uri"
    t.string   "pdf_text"
    t.string   "img_uri"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
