class ApplicationService
  Result = Struct.new(:result, :errors) do
    def success?
      errors&.has_error? == false
    end
  end

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def add_error(key, kind, message)
    errors.add_error(key, kind, message)
  end

  def errors
    @errors ||= empty_errors
  end

  def empty_errors
    Error.new
  end

  def has_error?
    errors.has_error?
  end

  def self.run(**args)
    new(**args).run
  end
end
