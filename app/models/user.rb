class User
  include ActiveModel::Model
  include Gravtastic

  attr_accessor :id, :name, :email, :groups

  gravtastic default: 'mm', size: 40
end
