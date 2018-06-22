module Processms
	extend ActiveSupport::Concern

	def self.included(klass)
		klass.extend(ClassMethods)
	end

	module ClassMethods

	end

	
end