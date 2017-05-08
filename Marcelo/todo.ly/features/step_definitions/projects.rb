When(/^I send a (POST) request to ([A-Za-z\/.]+) changing the "([^"]*)" of json with "([^"]*)"$/) do |method, end_point, field_name, value, json_text|
  @project_id = @id
  json_text.sub! 'id', eval("#{field_name} = '#{@id}'")

  http_request = Rest_service.get_request(method, end_point)
  http_request.body = json_text
  http_request['content-type'] = 'application/json'

  @http_response = Rest_service.execute_request(@http_connection, http_request)
  @last_json = @http_response.body
end

And(/^I set the "([^"]*)"$/) do |variable|
  if variable == "project_id"
    @id = @project_id
  end
end
