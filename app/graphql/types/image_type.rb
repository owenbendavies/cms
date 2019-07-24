module Types
  class ImageType < ModelType
    field :name, String, null: false
    field :url, String, null: false

    def url
      object.file.public_url
    end
  end
end
