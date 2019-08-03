module Types
  class ImageType < ModelType
    field :name, String, null: false
    field :url, String, null: false
    field :url_processed, String, null: false
    field :url_span3, String, null: false
    field :url_span4, String, null: false
    field :url_span8, String, null: false
    field :url_span12, String, null: false

    def url
      object.file.public_url
    end

    def url_processed
      object.file.processed.public_url
    end

    def url_span3
      object.file.span3.public_url
    end

    def url_span4
      object.file.span4.public_url
    end

    def url_span8
      object.file.span8.public_url
    end

    def url_span12
      object.file.span12.public_url
    end
  end
end
