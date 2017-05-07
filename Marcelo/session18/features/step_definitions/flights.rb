Given(/^I have set a connection to EXAMPLE service$/) do
	puts "Connection to EXAMPLE services Done."
end

When(/^I set headers values :$/) do |table|
	# table is a Cucumber::MultilineArgument::DataTable
	@headers = table.hashes	
	# p @headers
end

When(/^I send a (POST) request to "([^"]*)" for TRAVEL with values$/) do |request, url, table|
	# table is a Cucumber::MultilineArgument::DataTable
	@request = request
	@url = url
	@data = table.raw

	# Overriting the file template JSON
	file = File.read "./features/support/helpers/file_template.json"
	json = JSON.parse(file)
	p json['Name'] = @data[0][1]
	# ...
	# .. need to overrite remaining data
	# ...

	# Print the JSON result
	p "**** #{json}"

	# Simulating the POST request and return a random value
	id_number = Random.new
	@id = id_number.rand(1000)
	puts "Generated ID after #{request} request: #{@id}"

	# Simulate I got the json response from the request
	json_response = File.read "./features/support/helpers/post_response.json"
	@json_response_parsed = JSON.parse(json_response)
	# puts "*********** #{@json_response_parsed}"
end

Then(/^I expect HTTP status code (\d+)$/) do |http_code|
	# Simulate the http_code.response is 201
	http_response_code = 201
	expect(http_response_code).to eql(http_code.to_i)
end

When /^I keep the "(.*?)" as "(.*?)" from JSON(?: response|)$/ do |field_name, variable|  
	@field_value = get_value_from_json(@json_response_parsed, field_name)  
	puts "FIELD VALUE: #{@field_value}"
	puts "EVAL: #{eval("#{variable} = '#{@field_value}'")}"
	
end

When(/^I send (GET) requests to "([^"]*)" with "([^"]*)" until the json at "([^"]*)" matches "([^"]*)"$/) do |request, url, variable, status, complete|
	puts "I send #{request} to #{url} with variable #{eval("#{variable} = '#{@field_value}'")} until json at #{status} is #{complete}"
end

Then(/^I expect HTTP code (\d+)$/) do |http_code|
	# Simulate the http_code.response is 201
	http_response_code = 200
	expect(http_response_code).to eql(http_code.to_i)
end

Then(/^I validate the response of the "([^"]*)" displayed is "([^"]*)"$/) do |field_name, variable|
	puts "THE RESPONSE OF THE #{field_name} IS: #{eval("#{variable} = '#{@field_value}'")}"
end