# frozen_string_literal: true

require 'spec_helper'
# if lunches_spec is commented, the unit testing may fail bcse of this: (tbc)
RSpec.describe 'Unit testing' do
  describe Preference do
    User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1)

    it 'Must be able to create a new preference object and save it' do
      correct_preference = Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian])
      correct_preference.save
      expect(Preference.count).to eq(1)
    end
    it 'Saves itself' do
      preference = Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian])
      preference.save
      expect(Preference.first).to eq(preference)
    end
    it 'No duplicate user name' do
      preference1 = Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian])
      preference1.save
      preference2 = Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian])
      preference2.save
      expect(Preference.last).not_to eq(preference2)
    end
  end
end
