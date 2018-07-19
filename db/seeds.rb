# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
['moderator', 'admin'].each do |role|
  Role.find_or_create_by({name: role})
end

require 'csv'
#<Tuktuk id: nil, first_name: nil, last_name: nil, number_plate: nil, phone_number: nil, stage: nil, status: nil, created_at: nil, updated_at: nil> 
#<Tuktuk id: nil, first_name: nil, last_name: nil, number_plate: nil, phone_number: nil, stage: nil, status: nil, created_at: nil, updated_at: nil> 
csv_text = File.read(Rails.root.join('lib', 'seeds', 'tuktuk.csv'))
# display the wall of text
# puts csv_text  
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
tuktukj_id = "TUK-"
csv.each do |row|
  #  Put s the hash to be save
  # puts row.to_hash
 #  # Create a new Obeject 
	first_name = row['First Name']
	last_name = row['Last Name']
	phone_number = row['Phone']
	number_plate = tuktukj_id + row['Number Plate']
	
  tuk = Tuktuk.find_or_create_by( first_name: "#{first_name}", last_name: "#{last_name}" , number_plate: "#{number_plate}", phone_number: "#{phone_number}" )
  # Save the obeject
  if tuk
  	puts "#{tuk.number_plate} saved"
  else
  	puts "#{tuk.number_plate} ERR:: Failed to Save! "
	puts "\n"
	puts "****Error****"
	puts "#{tuk.errors.messages}"
  end

end 

csv_text_baj = File.read(Rails.root.join('lib', 'seeds', 'bajaj.csv'))
# display the wall of text
# puts csv_text  
csv_baj = CSV.parse(csv_text_baj, :headers => true, :encoding => 'ISO-8859-1')
bajaj_id = "BAJ-"
csv_baj.each do |row|
  #  Put s the hash to be save
  # puts row.to_hash
 #  # Create a new Obeject 
  
	first_name = row['First Name']
	last_name = row['Last Name']
	phone_number = row['Phone']
	number_plateb = bajaj_id + row['Number Plate']

	# puts "#{number_plate}"
	# puts "\n"
	
  baj = Bajaj.find_or_create_by( first_name: "#{first_name}", last_name: "#{last_name}" , number_plate: "#{number_plateb}", phone_number: "#{phone_number}" )
  # Save the obeject
  if baj
  	puts "#{baj.number_plate} saved"
  else
  	puts "#{baj.number_plate} ERR:: Failed to Save! "
	puts "\n"
	puts "****Error****"
	puts "#{baj.errors.messages}"
  end

end 