require 'spec_helper'
# if lunches_spec is cmmented, the unit testing may fail bcse of this: not sur???
RSpec.describe 'Unit testing' do

  describe Lunch do
    User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1)
    it "Must be able to create a new object and save it" do
      correct_lunch = Lunch.new(localisation: "Arlon", distance: 1000, price: [1, 4], user_id: '1')
      correct_lunch.save
      expect(Lunch.count).to eq(1)
    end
    it "saves itself" do
      lunch = Lunch.new(localisation: "Arlon", distance: 1000, price: [1, 4], user_id: '1')
      lunch.save
      expect(Lunch.first).to eq(lunch)
    end
    it "localisation must not be empty" do
      lunch = Lunch.new(localisation: "", distance: 1000, price: [1, 4], user_id: '1')
      lunch.save
      expect(Lunch.count).to eq(0)
    end
     it "price range must be between 1 and 4" do
      lunch = Lunch.new(localisation: "Arlon", distance: 1000, price: [1,9], user_id: '1')
      lunch.save
      expect(Lunch.count).to eq(0)
    end
      it "distance must not be empty" do
      lunch = Lunch.new(localisation: "Arlon", distance: "String", price: [1, 4], user_id: '1')
      lunch.save
      expect(Lunch.count).to eq(0)
    end
      it "price must not be empty" do
      lunch = Lunch.new(localisation: "Arlon", distance: 1000, price: [], user_id: '1')
      lunch.save
      expect(Lunch.count).to eq(0)
    end

  end
end
