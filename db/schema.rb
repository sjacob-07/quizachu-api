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

ActiveRecord::Schema.define(version: 2023_11_28_122619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessment_options", force: :cascade do |t|
    t.bigint "assessment_question_id", null: false
    t.bigint "assessment_id", null: false
    t.string "option"
    t.string "option_attachment"
    t.string "option_attachment_caption"
    t.integer "order_seq"
    t.boolean "is_correct_option", default: false
    t.string "option_type"
    t.boolean "is_active", default: true
    t.datetime "deleted_at"
    t.boolean "model_generated"
    t.datetime "generated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assessment_id"], name: "index_assessment_options_on_assessment_id"
    t.index ["assessment_question_id"], name: "index_assessment_options_on_assessment_question_id"
  end

  create_table "assessment_questions", force: :cascade do |t|
    t.text "question"
    t.text "question_type"
    t.text "question_description"
    t.integer "order_seq"
    t.boolean "model_generated"
    t.datetime "generated_at"
    t.bigint "assessment_id", null: false
    t.boolean "is_active", default: true
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assessment_id"], name: "index_assessment_questions_on_assessment_id"
  end

  create_table "assessments", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "category"
    t.string "duration"
    t.string "image_url"
    t.text "context"
    t.integer "passmark"
    t.string "status"
    t.integer "ques_count"
    t.boolean "is_active", default: true
    t.datetime "deleted_at"
    t.bigint "created_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_assessments_on_created_by_id"
  end

  create_table "role_masters", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "is_active", default: true
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_assessment_responses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "assessment_id", null: false
    t.bigint "assessment_question_id", null: false
    t.string "user_answer"
    t.string "user_answer_url"
    t.boolean "is_answered"
    t.boolean "is_correct"
    t.integer "marks_obtained_for_question"
    t.datetime "started_at"
    t.datetime "completed_on"
    t.integer "time_taken"
    t.datetime "deleted_at"
    t.boolean "model_evaluated"
    t.datetime "evaluated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assessment_id"], name: "index_user_assessment_responses_on_assessment_id"
    t.index ["assessment_question_id"], name: "index_user_assessment_responses_on_assessment_question_id"
    t.index ["user_id"], name: "index_user_assessment_responses_on_user_id"
  end

  create_table "user_assessments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "assessment_id", null: false
    t.integer "marks_obtained"
    t.integer "percentage"
    t.integer "attempts_taken"
    t.boolean "is_passed"
    t.integer "time_taken"
    t.datetime "started_at"
    t.datetime "completed_on"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assessment_id"], name: "index_user_assessments_on_assessment_id"
    t.index ["user_id"], name: "index_user_assessments_on_user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_master_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_master_id"], name: "index_user_roles_on_role_master_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "fullname"
    t.string "email", null: false
    t.string "external_uid", null: false
    t.string "profile_picture_url"
    t.boolean "is_active", default: true
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "assessment_options", "assessment_questions"
  add_foreign_key "assessment_options", "assessments"
  add_foreign_key "assessment_questions", "assessments"
  add_foreign_key "assessments", "users", column: "created_by_id"
  add_foreign_key "user_assessment_responses", "assessment_questions"
  add_foreign_key "user_assessment_responses", "assessments"
  add_foreign_key "user_assessment_responses", "users"
  add_foreign_key "user_assessments", "assessments"
  add_foreign_key "user_assessments", "users"
  add_foreign_key "user_roles", "role_masters"
  add_foreign_key "user_roles", "users"
end
