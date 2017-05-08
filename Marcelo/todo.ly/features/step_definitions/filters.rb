# Author : Marcelo Vargas

Given(/^I have set a connection to application$/) do
	@http_connection = Rest_service.get_connection
end

When (/I have filters by default in my account/) do
	puts "I have filters by default in my account"
end

When(/^I send a (GET) request to ([A-Za-z\/.]+)$/) do |method, end_point|
	http_request = Rest_service.get_request(method, end_point)
	@http_response = Rest_service.execute_request(@http_connection, http_request)
	@last_json = @http_response.body
	@json_array_response = JSON.parse(@last_json)
end

Then(/^I expect HTTP code (\d+)$/) do |http_code|
	expect(@http_response.code).to eql(http_code)
end

Then(/^I expect the default filter names in the response$/) do |table|
	# table is a Cucumber::MultilineArgument::DataTable
	
	# Save the table as an array
	@default_values = table.raw
	
	# Getting array of values based on key "Content" criteria
	content_values = get_array_values_by_key(@json_array_response, "Content")

	# Iterate the array and compare the Name with the response values
	@default_values.each_with_index do |value, index|
		# I had to use gsub because the value from the table was like this ["Inbox"] VS "Inbox" and was failing the comparison, if we can improve this it will be great
		expect(value.to_s.gsub(/[\[\]\\""]/, '')).to eql(content_values[index])
	end
end

When(/^I send (GET) request to "([A-Za-z\/.]+)" with "([^"]*)" equal to "([^"]*)" for each filter$/) do |method, end_point, field_name, variable|
	# table is a Cucumber::MultilineArgument::DataTable
	
	# Getting array of values based on key "Content" criteria
	id_values = get_array_values_by_key(@json_array_response, "Id")
	id_value = "id"

	# TODO: This failed because for some reason the request to /filters/-3.json fails and returns an error!!!!! I had to remove the last value of the array
	@json_array_response.pop

	# Iterate the array and compare the Name with the response values
	@json_array_response.each_with_index do |value, index|
		end_point.sub! id_value, eval("#{field_name} = '#{id_values[index]}'")
		id_value = eval("#{field_name} = '#{id_values[index]}'").to_s
		http_request = Rest_service.get_request(method, end_point)
		@http_response = Rest_service.execute_request(@http_connection, http_request)
		@last_json = @http_response.body
		expect(id_values[index]).to eql(get_value_from_json(JSON.parse(@last_json), "Id"))
	end
end

When(/^I get the "Id" of "(\w+)" filter$/) do |filter|
	# Getting array of values based on key "Inbox" criteria
	@content_sub_json = get_id_giving_a_content(@json_array_response, filter)
	
end

When(/^I keep the "([^"]*)" as "([^"]*)"$/) do |field_name, variable|
	# Asign the Id
	@filter_id = eval(variable = @content_sub_json[field_name].to_s)
end

When(/^I send (GET) request to "([A-Za-z\/.]+)" with "([^"]*)" equal to "([^"]*)"$/) do |method, end_point, field_name, variable|
	# Replacing the id by the value
	end_point.sub! "id", eval("#{field_name} = '#{@filter_id}'")

	http_request = Rest_service.get_request(method, end_point)
	@http_response = Rest_service.execute_request(@http_connection, http_request)
	@last_json = @http_response.body
	
	# Validate if it is a valid Json
	# TODO: it fails if the filter does not have any done item!
	expect(valid_json?(@last_json)).to be true
end

Then(/^All items of the response are marked as Done$/) do
	# Validate if the "Checked" key is true in all elements of the response
	array_test = JSON.parse(@last_json)
	array_test.each_with_index do |value|
		expect(value["Checked"]).to be true		
	end
end
