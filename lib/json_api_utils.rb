# frozen_string_literal: true

module JsonApiUtils
  module_function

  # @param object [Object] Serializeable object
  # @param params [ActionController::Parameters]
  # @param options [Hash]
  # @return [Hash] Serializeable hash
  def render(object, params = {}, options = {})
    return { data: nil } unless object

    klass  = options.delete(:serializer) || serializer_class(object)
    params = serializer_params(params)

    klass.new(object, params.merge(options)).serializable_hash.to_json
  end

  # @param object [Object] Serializeable object
  # @return [Class] Serializer class
  def serializer_class(object)
    klass =
      case object
      when Array
        object.first.class.name
      when ActiveRecord::Relation
        object.klass.name
      else
        object.class.name
      end

    "Api::#{klass}Serializer".constantize
  end

  # @param params [ActionController::Parameters]
  # @return [Hash] Normalized serializer params
  def serializer_params(params)
    {
      include: params[:include].to_s.split(','),
      fields: parse_fields(params[:fields]&.to_unsafe_h || {})
    }
  end

  # @param fields [Hash]
  # @return [Hash]
  def parse_fields(fields)
    fields.to_h { |key, value| [key.to_sym, value.to_s.split(',')] }
  end
end
