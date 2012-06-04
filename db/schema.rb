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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120604170704) do

  create_table "ministry_newaddress", :primary_key => "addressID", :force => true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "address3",            :limit => 55
    t.string   "address4",            :limit => 55
    t.string   "city",                :limit => 50
    t.string   "state",               :limit => 50
    t.string   "zip",                 :limit => 15
    t.string   "country",             :limit => 64
    t.string   "homePhone",           :limit => 26
    t.string   "workPhone",           :limit => 250
    t.string   "cellPhone",           :limit => 25
    t.string   "fax",                 :limit => 25
    t.string   "email",               :limit => 200
    t.string   "url",                 :limit => 100
    t.string   "contactName",         :limit => 50
    t.string   "contactRelationship", :limit => 50
    t.string   "addressType",         :limit => 20
    t.datetime "dateCreated"
    t.datetime "dateChanged"
    t.string   "createdBy",           :limit => 50
    t.string   "changedBy",           :limit => 50
    t.integer  "fk_PersonID"
    t.string   "email2",              :limit => 200
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "facebook_link"
    t.string   "myspace_link"
    t.string   "title"
    t.string   "dorm"
    t.string   "room"
    t.string   "preferredPhone",      :limit => 25
    t.string   "phone1_type",                        :default => "cell"
    t.string   "phone2_type",                        :default => "home"
    t.string   "phone3_type",                        :default => "work"
  end

  add_index "ministry_newaddress", ["addressType", "fk_PersonID"], :name => "unique_person_addressType", :unique => true
  add_index "ministry_newaddress", ["addressType"], :name => "index_ministry_newAddress_on_addressType"
  add_index "ministry_newaddress", ["email"], :name => "email"
  add_index "ministry_newaddress", ["fk_PersonID"], :name => "fk_PersonID"

  create_table "ministry_person", :primary_key => "personID", :force => true do |t|
    t.string   "accountNo",                     :limit => 11
    t.string   "lastName",                      :limit => 50
    t.string   "firstName",                     :limit => 50
    t.string   "middleName",                    :limit => 50
    t.string   "preferredName",                 :limit => 50
    t.string   "gender",                        :limit => 1
    t.string   "region",                        :limit => 5
    t.boolean  "workInUS",                                            :default => true,  :null => false
    t.boolean  "usCitizen",                                           :default => true,  :null => false
    t.string   "citizenship",                   :limit => 50
    t.boolean  "isStaff"
    t.string   "title",                         :limit => 5
    t.string   "campus",                        :limit => 128
    t.string   "universityState",               :limit => 5
    t.string   "yearInSchool",                  :limit => 20
    t.string   "major",                         :limit => 70
    t.string   "minor",                         :limit => 70
    t.string   "greekAffiliation",              :limit => 50
    t.string   "maritalStatus",                 :limit => 20
    t.string   "numberChildren",                :limit => 2
    t.boolean  "isChild",                                             :default => false, :null => false
    t.text     "bio",                           :limit => 2147483647
    t.string   "image",                         :limit => 100
    t.string   "occupation",                    :limit => 50
    t.string   "blogfeed",                      :limit => 200
    t.datetime "cruCommonsInvite"
    t.datetime "cruCommonsLastLogin"
    t.datetime "dateCreated"
    t.datetime "dateChanged"
    t.string   "createdBy",                     :limit => 50
    t.string   "changedBy",                     :limit => 50
    t.integer  "fk_ssmUserId"
    t.integer  "fk_StaffSiteProfileID"
    t.integer  "fk_spouseID"
    t.integer  "fk_childOf"
    t.date     "birth_date"
    t.date     "date_became_christian"
    t.date     "graduation_date"
    t.string   "level_of_school"
    t.string   "staff_notes"
    t.string   "donor_number",                  :limit => 11
    t.string   "url",                           :limit => 2000
    t.string   "isSecure",                      :limit => 1
    t.integer  "primary_campus_involvement_id"
    t.integer  "mentor_id"
    t.string   "lastAttended",                  :limit => 20
    t.string   "ministry"
    t.string   "strategy",                      :limit => 20
    t.integer  "fb_uid",                        :limit => 8
  end

  add_index "ministry_person", ["accountNo"], :name => "accountNo_ministry_Person"
  add_index "ministry_person", ["campus"], :name => "campus"
  add_index "ministry_person", ["fb_uid"], :name => "index_ministry_person_on_fb_uid"
  add_index "ministry_person", ["firstName"], :name => "firstname_ministry_Person"
  add_index "ministry_person", ["fk_ssmUserId"], :name => "fk_ssmUserId"
  add_index "ministry_person", ["lastName"], :name => "lastname_ministry_Person"
  add_index "ministry_person", ["region"], :name => "region_ministry_Person"

  create_table "rideshare_event", :force => true do |t|
    t.integer "conference_id"
    t.string  "event_name",    :limit => 50
    t.string  "password",      :limit => 50, :null => false
    t.text    "email_content"
  end

  create_table "rideshare_ride", :force => true do |t|
    t.integer "event_id"
    t.integer "driver_ride_id"
    t.integer "person_id"
    t.string  "address1",                        :null => false
    t.string  "address2",                        :null => false
    t.string  "address3",                        :null => false
    t.string  "address4",                        :null => false
    t.string  "city",              :limit => 50, :null => false
    t.string  "state",             :limit => 50, :null => false
    t.string  "zip",               :limit => 20, :null => false
    t.string  "country",           :limit => 64, :null => false
    t.float   "latitude"
    t.float   "longitude"
    t.string  "phone",             :limit => 25, :null => false
    t.string  "contact_method",    :limit => 0
    t.integer "number_passengers", :limit => 1
    t.integer "drive_willingness", :limit => 1
    t.time    "depart_time"
    t.text    "special_info"
    t.string  "email",                           :null => false
  end

  add_index "rideshare_ride", ["drive_willingness"], :name => "drivewillingness"
  add_index "rideshare_ride", ["driver_ride_id"], :name => "fk_driverID"
  add_index "rideshare_ride", ["event_id"], :name => "fk_eventID"
  add_index "rideshare_ride", ["person_id"], :name => "fk_personID"

  create_table "westons", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
