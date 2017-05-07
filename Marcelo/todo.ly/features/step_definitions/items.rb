When(/^I send a (GET) request to ([A-Za-z\/.]+) and keep all the items id$/) do |method, end_point|
  http_request = Rest_service.get_request(method, end_point)
  @http_response = Rest_service.execute_request(@http_connection, http_request)
  @last_json = @http_response.body
  @json_array_response = JSON.parse(@last_json)

  @list_ids = get_array_values_by_key(@json_array_response, 'Id')
end

When(/^I select a random "([^"]*)" of the list as "([^"]*)"$/) do |field_name, variable|
  random_id = @list_ids.sample
  @id = eval(variable = random_id.to_s)
end

When(/^I send a (GET) request to ([A-Za-z\/.]+) with "([^"]*)" equal to "([^"]*)"$/) do |method, end_point, field_name, variable|
  end_point.sub! 'id', eval("#{field_name} = '#{@id}'")
  http_request = Rest_service.get_request(method, end_point)
  @http_response = Rest_service.execute_request(@http_connection, http_request)
  @last_json = @http_response.body
end

Given(/^I pick a random "([^"]*)" between (\d+) and (\d+) as "([^"]*)"$/) do |field_name, min, max, variable|
  @random_icon_id = Random.rand(min.to_i...max.to_i)
  @id = eval(variable = @random_icon_id.to_s)
end

Then(/^I expect that the json contains the following keys:$/) do |table|
  @table_keys = table.raw
  keys_in_json = @json_array_response[0].keys

  @table_keys.each_with_index do |value, index|
    expect(value.to_s.gsub(/[\[\]\\""]/, '')).to eql(keys_in_json[index])
  end
end

When(/^I send a (PUT|POST) request to ([A-Za-z\d+\/.]+) with json$/) do |method, end_point, json_text|
  http_request = Rest_service.get_request(method, end_point)
  http_request.body = json_text
  http_request['content-type'] = 'application/json'

  @http_response = Rest_service.execute_request(@http_connection, http_request)
  @last_json = @http_response.body
end


When(/^I keep the "([^"]*)" of the response as "([^"]*)"$/) do |fieldname, value|
  @json_array_response = JSON.parse(@last_json)
  value = @json_array_response[fieldname].to_s
  @id = eval(value)
end

When(/^I send a (PUT|POST) request to ([A-Za-z\/.]+) with "([^"]*)" equal to "([^"]*)" with a json$/) do |method, end_point, field_name, variable, json_text|
  end_point.sub! 'id', eval("#{field_name} = '#{@id}'")
  http_request = Rest_service.get_request(method, end_point)
  http_request.body = json_text
  http_request['content-type'] = 'application/json'

  @http_response = Rest_service.execute_request(@http_connection, http_request)
  @last_json = @http_response.body
end

When(/^I send a (DELETE) request to ([A-Za-z\/.]+) with "([^"]*)" equal to "([^"]*)"$/) do |method, end_point, field_name, variable|
  end_point.sub! 'id', eval("#{field_name} = '#{@id}'")
  http_request = Rest_service.get_request(method, end_point)
  @http_response = Rest_service.execute_request(@http_connection, http_request)
  @last_json = @http_response.body
end

When(/^I send a (DELETE) request to ([A-Za-z\/.]+) when ("Id") is (.*)$/) do |method, end_point, field, value|
  end_point.sub! 'id', value
  http_request = Rest_service.get_request(method, end_point)
  @http_response = Rest_service.execute_request(@http_connection, http_request)
  @last_json = @http_response.body
end