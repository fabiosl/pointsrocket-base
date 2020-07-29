def flat_keys_to_nested(hash)
  hash.each_with_object({}) do |(key,value), all|
    key_parts = key.split('.').map!(&:to_sym)
    leaf = key_parts[0...-1].inject(all) { |h, k| h[k] ||= {} }
    leaf[key_parts.last] = value
  end
end

flat_keys_to_nested(YAML.load(File.read(Rails.root.join("config/locales_source/en.yml"))))
