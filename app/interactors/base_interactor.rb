class BaseInteractor
  include Interactor

  private

  # Some GPT clients return Hashes with symbol keys; normalize everything to string keys.
  # Also accepts objects responding to `to_h`.
  def normalize_answer_hash(answer)
    hash = if answer.is_a?(Hash)
             answer
           else
             (answer.respond_to?(:to_h) ? answer.to_h : {})
           end
    deep_stringify_keys(hash)
  end

  def deep_stringify_keys(obj)
    case obj
    when Hash
      obj.each_with_object({}) do |(k, v), acc|
        acc[k.to_s] = deep_stringify_keys(v)
      end
    when Array
      obj.map { |v| deep_stringify_keys(v) }
    else
      obj
    end
  end
end
