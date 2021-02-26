# frozen_string_literal: true

User.create(email: 'pierre@pierre.pierre', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF')
User.create(email: 'gilles@gilles.gilles', password: 'testest')
User.create(email: 'vince@vince.vince', password: 'testest')
User.create(email: 'sam@sam.sam', password: 'testest')

Preference.create(user_id: 1, name: 'Pierre', taste: %w[Italian Lebanese Japanese Belgian])
Preference.create(user_id: 2, name: 'Gilles', taste: %w[Italian Lebanese Japanese Belgian])
Preference.create(user_id: 2, name: 'Vince', taste: %w[Italian Japanese Lebanese])
Preference.create(user_id: 4, name: 'Sam', taste: %w[Belgian])

Lunch.create(id: 1000, localisation: 'Arlon', distance: 1000, price: [1, 4], user_id: '1')
Lunch.create(id: 1001, localisation: 'Saint Gilles', distance: 50, price: [1, 4], user_id: '1')
