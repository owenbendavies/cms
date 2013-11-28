module CouchModel
  extend ActiveSupport::Concern

  included do
    extend AutoStripAttributes
    extend CarrierWave::ActiveRecord
    include CouchPotato::Persistence

    property :updated_from, type: String

    validates :updated_from, presence: true, ip: true

    view :by_id, key: :_id
  end

  module ClassMethods
    # Method only needed to get CarrierWave working
    def after_commit(*args)
    end

    def all
      CouchPotato.database.view(by_id)
    end

    def count
      CouchPotato.database.view(by_id(reduce: true))
    end

    def find_by_id(id)
      CouchPotato.database.load id
    end
  end

  def save
    CouchPotato.database.save_document self
  end

  def save!
    CouchPotato.database.save_document! self
  end

  def update_attributes(hash)
    self.attributes = hash
    save
  end

  def update_attributes!(hash)
    self.attributes = hash
    save!
  end

  # Method only needed to get CarrierWave working
  def read_attribute(property)
    self.send(property.to_s)
  end

  # Method only needed to get CarrierWave working
  def write_attribute(property, value)
    self.send("#{property}=", value)
  end
end
