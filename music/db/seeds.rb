# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Book.find_or_create_by!(title: 'Together in Song', acronym: 'TIS')
Book.find_or_create_by!(title: 'All Together Now', acronym: 'ATN')
Book.find_or_create_by!(title: 'All Together Again', acronym: 'ATA')
Book.find_or_create_by!(title: 'All Together Everybody', acronym: 'ATE')
Book.find_or_create_by!(title: 'All Together OK', acronym: 'ATO')
Book.find_or_create_by!(title: 'All Together Whatever', acronym: 'ATW')
Book.find_or_create_by!(title: 'All Together For Good', acronym: 'ATFG')
Book.find_or_create_by!(title: 'All Together All Right', acronym: 'ATAR')
