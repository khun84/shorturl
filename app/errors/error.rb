class Error < Mutations::ErrorHash
  class ErrorAtom < Mutations::ErrorAtom; end

  # This implementation is borrowed from Mutation gem
  def add_error(key, kind, message = nil)
    raise ArgumentError, 'Invalid kind' unless kind.is_a?(Symbol)

    self.tap do |errs|
      path = key.to_s.split('.')
      last = path.pop
      inner = path.inject(errs) do |cur_errors, part|
        cur_errors[part.to_sym] ||= self.class.new
      end
      inner[last] = ErrorAtom.new(key, kind, message: message)
    end
  end

  # This implementation is borrowed from Mutation gem
  def merge_errors(hash)
    self.merge!(hash) if hash.any?
  end

  def error?
    self.present?
  end
  alias has_error? error?
end
