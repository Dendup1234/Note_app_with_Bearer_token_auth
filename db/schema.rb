# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_03_181020) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "applications", force: :cascade do |t|
    t.text "cover_note"
    t.datetime "created_at", null: false
    t.bigint "internship_id", null: false
    t.integer "status"
    t.datetime "status_changed_at"
    t.bigint "status_changed_by_id"
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["internship_id"], name: "index_applications_on_internship_id"
    t.index ["status_changed_by_id"], name: "index_applications_on_status_changed_by_id"
    t.index ["student_id"], name: "index_applications_on_student_id"
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.bigint "recruiter_id", null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["recruiter_id"], name: "index_companies_on_recruiter_id"
  end

  create_table "internships", force: :cascade do |t|
    t.date "application_deadline"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration_weeks"
    t.string "location"
    t.integer "mode"
    t.decimal "monthly_stipend"
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_internships_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "bio"
    t.string "college"
    t.datetime "created_at", null: false
    t.string "email"
    t.integer "graduation_year"
    t.string "name"
    t.string "password_digest"
    t.integer "role"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applications", "internships"
  add_foreign_key "applications", "users", column: "status_changed_by_id"
  add_foreign_key "applications", "users", column: "student_id"
  add_foreign_key "companies", "users", column: "recruiter_id"
  add_foreign_key "internships", "companies"
end
