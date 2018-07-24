class Api::V1::DriversController < ApplicationController

	def tuktuk_drivers
		drivers = Tuktuk.all.paginate(:page => params[:page], :per_page => 20)
		return all_tuktuk_drivers drivers
	end

	def bajaj_drivers
		drivers = Bajaj.all.paginate(:page => params[:page], :per_page => 20)
		return all_bajaj_drivers drivers
	end

	private

	def all_tuktuk_drivers drivers
		# byebug
		# Jbuilder.new do |driver|
		# 	driver.(self, :first_name, :last_name, :phone_number)
		# end
		render json: drivers.to_json
	end

	def all_bajaj_drivers drivers
		render json: drivers.to_json
	end
end
