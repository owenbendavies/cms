module I18n
  def self.raise_exception(*args)
    raise "Missing translation #{args.first}"
  end
end

I18n.exception_handler = :raise_exception
