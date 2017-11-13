require "spec"
require "../src/lucky_record"
require "./support/*"

LuckyRecord::Repo.configure do
  settings.url = LuckyRecord::PostgresURL.build(
    database: "lucky_record_test",
    hostname: "localhost",
    username: "lucky-record"
  )
end

Spec.after_each do
  UserQuery.new.destroy_all
end

private class UserForm < User::BaseForm
  allow :name, :nickname, :joined_at, :age

  def prepare
    validate_required name, joined_at, age
  end
end

def create_user(name = "Default Name")
  params = {name: name, age: "27", joined_at: now_as_string}
  UserForm.new(**params).save
end

def now_as_string
  Time.now.to_s("%FT%X%z")
end
