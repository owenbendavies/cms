class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.per_page = 10

  has_paper_trail
end
