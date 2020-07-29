class ExternalActionBase

  def initialize external_action
    @external_action = external_action
  end

  def separator
    # splita por %s% ou %S%
    /\%S\%|\%s\%/
  end

  def key_value_regex
    /^([^=]+)=(.+)$/
  end

  def run
  end

  def get_tokens
    if not @tokens.present?
      fields_spliteds = @external_action.text.split(separator)
      # transforma array em um objeto
      @tokens = fields_spliteds.inject({}) do |memo, obj|
        match_data = key_value_regex.match obj
        # splita as keys e values
        memo[match_data[1]] = match_data[2]
        memo
      end
    end

    @tokens
  end

end
