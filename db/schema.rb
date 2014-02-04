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

ActiveRecord::Schema.define(version: 20140204104534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admins", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "call_requests", force: true do |t|
    t.integer  "member_id"
    t.integer  "mentor_id"
    t.integer  "passcode"
    t.string   "status"
    t.datetime "scheduled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "billable_duration"
    t.text     "agenda"
    t.integer  "proposed_duration"
  end

  add_index "call_requests", ["member_id"], name: "index_call_requests_on_member_id", using: :btree
  add_index "call_requests", ["mentor_id"], name: "index_call_requests_on_mentor_id", using: :btree

  create_table "calls", force: true do |t|
    t.integer  "call_request_id"
    t.string   "sid"
    t.string   "conferencesid"
    t.string   "status"
    t.string   "from_number"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calls", ["call_request_id"], name: "index_calls_on_call_request_id", using: :btree

  create_table "conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "industries", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "phone_number"
    t.string   "industries"
  end

  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "mentors", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "headline"
    t.integer  "years_of_experience"
    t.string   "phone_number"
    t.text     "availability"
    t.datetime "status_changed_at"
    t.boolean  "featured"
    t.string   "linkedin"
    t.string   "mentor_status"
    t.string   "location"
    t.decimal  "avg_call_duration"
    t.decimal  "avg_rating"
    t.integer  "total_reviews"
    t.string   "city"
    t.string   "state"
    t.string   "industries"
    t.string   "skills"
  end

  add_index "mentors", ["user_id"], name: "index_mentors_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "notifications", ["conversation_id"], name: "index_notifications_on_conversation_id", using: :btree

  create_table "payment_transactions", force: true do |t|
    t.integer  "call_request_id"
    t.string   "type"
    t.decimal  "amount"
    t.string   "status"
    t.string   "uri"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_transactions", ["call_request_id"], name: "index_payment_transactions_on_call_request_id", using: :btree

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "receipts", ["notification_id"], name: "index_receipts_on_notification_id", using: :btree

  create_table "reviews", force: true do |t|
    t.text     "review"
    t.decimal  "rating"
    t.integer  "mentor_id"
    t.integer  "member_id"
    t.integer  "call_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["call_id"], name: "index_reviews_on_call_id", using: :btree
  add_index "reviews", ["member_id"], name: "index_reviews_on_member_id", using: :btree
  add_index "reviews", ["mentor_id"], name: "index_reviews_on_mentor_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.string   "role_type"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar"
    t.string   "username"
    t.string   "time_zone",              default: "UTC"
    t.string   "customer_uri"
    t.datetime "deleted_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id", "role_type"], name: "index_users_on_role_id_and_role_type", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "work_histories", force: true do |t|
    t.string   "company"
    t.string   "date_started"
    t.string   "date_ended"
    t.boolean  "current_work"
    t.integer  "mentor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_foreign_key "notifications", "conversations", name: "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", name: "receipts_on_notification_id"

end
