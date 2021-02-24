User.create(email: 'pierre@pierre.pierre', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF')
User.create(email: 'gilles@gilles.gilles', password: 'testest')
User.create(email: 'vince@vince.vince', password: 'testest')
User.create(email: 'sam@sam.sam', password: 'testest')


Preference.create(user_id: 1, name: 'Pierre', taste: %w[Italian Lebanese Japanese Belgian])
Preference.create(user_id: 2, name: 'Gilles', taste: %w[Italian Lebanese Japanese Belgian])
Preference.create(user_id: 2, name: 'Vince', taste: %w[Italian Japanese Lebanese])
Preference.create(user_id: 4, name: 'Sam', taste: %w[Belgian])
