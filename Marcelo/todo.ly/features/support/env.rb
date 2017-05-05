
require 'pathname'
require 'yaml'
require 'json'
require 'json_spec/cucumber'

def find_config_file(filename)
  root = Pathname.pwd
  while not root.root?
    root.find do |path|
      if path.file? and path.basename.to_s == filename
        return path.to_s
      end
    end
    root = root.parent
  end
  raise 'Configuration file ' #{filename}' not found!'
end

def load_app_config_file(filename)
  config_file = find_config_file(filename)
  config = YAML.load_file(config_file)
  $app_context = config['app']['rootPath']
  return config
end

AfterConfiguration do |config|
  # read config file
  configuration = load_app_config_file('env.yml')
  # Load application configuration parameters
  $app_user = configuration['app']['admin_user']
  $app_pass = configuration['app']['admin_pass']
  $app_host = configuration['app']['host']
  $app_port = configuration['app']['port']
  $app_root = configuration['app']['rootPath']
end

def get_value_from_json(json_parsed, field_name)    
  field_value = false
  json_parsed.each_pair do |key, value|
    if key.eql?(field_name)
      field_value = value
      end
      break if field_value != false      
    end        
    return field_value  
end

def get_array_values_by_key(the_array, key)
  values_array = Array.new
  the_array.each_with_index do |value, index|
    values_array.push(get_value_from_json(the_array[index], key))
  end
  values_array
end

def get_id_giving_a_content(the_array, key)
  value_to_return = String.new
  the_array.each_with_index do |value, index|
    if get_value_from_json(the_array[index], "Content").eql?(key)
      value_to_return = the_array[0]
    end
  end
  value_to_return 
end

def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
end