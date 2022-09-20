class Section < ApplicationRecord
  include AlgoliaSearch
  include Searchable::ForSection # depends on AlgoliaSearch
  
  CATEGORY_HEADERS = {
    "instance_method" => "Instance Methods",
    "class_method" => "Class Methods",
    "included_module" => "Included Modules",
    "inherits_from_parent" => "Parent"
  }
  
  belongs_to :klass
  has_one :version, through: :klass
  
  validates :name, presence: true
  
  enum category: { instance_method: 0, class_method: 1, included_module: 2, inherits_from_parent: 3 }

  def formatted_name
    if instance_method?
      "# #{name}"
    elsif class_method?
      ":: #{name}"
    else
      name
    end
  end

  def category_header
    CATEGORY_HEADERS[category]
  end
end
