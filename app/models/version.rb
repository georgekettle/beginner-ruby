class Version < ApplicationRecord
	include AlgoliaSearch
	include Searchable::ForVersion # depends on AlgoliaSearch

	default_scope { order(number: :desc) }

	has_many :klasses, dependent: :destroy
	has_many :sections, through: :klasses
	
	validates :number, presence: true
end
