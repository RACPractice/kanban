# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Step
Step.create(name: 'Backlog', anchor: 1, capacity: 5, position: 1)
Step.create(name: 'Archive', anchor: 1, capacity: 5, position: 2)

# Priority
Priority.create(name: 'High')
Priority.create(name: 'Medium')
Priority.create(name: 'Low')

# WorkType
WorkType.create(name: 'Epic')
WorkType.create(name: 'Story')
WorkType.create(name: 'Feature')
WorkType.create(name: 'Enhancement')

# UserRoles
Role.create(name: 'owner')
Role.create(name: 'member')
