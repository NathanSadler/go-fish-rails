require 'rails_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:user) {User.new(name: "Test user", email: "user@example.com")}

  it("requires a name to be present") do
    user.name = " "
    expect(user.valid?).to(eq(false))
  end

  it("should not have a name longer than 50 chars") do
    user.name = "A" * 51
    expect(user.valid?).to(eq(false))
  end

  it("should have an email present") do
    user.email = "  "
    expect(user.valid?).to(eq(false))
  end

  it("should not have an email longer than 255 chars") do
    user.email = ("a" * 244) + "@example.com"
    expect(user.valid?).to(eq(false))
  end

  it("accepts valid email addresses") do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                     first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user.valid?).to(eq(true))
    end
  end

  it("rejects invalid email addresses") do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user.valid?).to(eq(false))
    end
  end

  it("should have unique email addresses") do
    duplicate_user = user.dup
    user.save
    expect(duplicate_user.valid?).to(eq(false))
  end

  it("treats uppercase and lowercase characters the same when checking for "+
  "uniqueness") do
    user.email = "sample@email.com"
    duplicate_user = user.dup
    user.save
    duplicate_user.email = "SAMPLE@email.com"
    expect(duplicate_user.valid?).to(eq(false))
  end

  it("saves email addresses as lowercase") do
    test_email = "SAMPlE@emAIl.Com"
    user.email = test_email
    user.save
    expect(user.email).to(eq(test_email.downcase))
  end

end
