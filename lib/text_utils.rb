# frozen_string_literal: true

module TextUtils
  NULL_CHARS = "\u0000\u00ad"

  module_function

  # @param text [String]
  # @return [String]
  def fix_encoding(text)
    text = text.dup if text.frozen?

    text =
      if text.force_encoding('UTF-8').valid_encoding?
        text.encode('UTF-8')
      else
        text.force_encoding(CharDet.detect(text)['encoding'] || 'UTF-8')
            .encode('UTF-8', replace: '?', invalid: :replace, undef: :replace)
      end

    text.tr(NULL_CHARS, '')
  end
end
