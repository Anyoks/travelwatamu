

# status
# started 	- driver found the customer and took them
# completed - driver responded after successful trip completion
# failed 	- driver accepted trip but passenger refused or driver didn't go and told the system
class Ttrip < ApplicationRecord
	belongs_to :ttrip_request

end
