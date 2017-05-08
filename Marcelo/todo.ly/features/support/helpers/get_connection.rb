#Add the library for HTTP
require 'net/http'

module Rest_service
  #
  # This method set up a connection 
  #
  def Rest_service.get_connection
      http_connection = nil
      http_connection = Net::HTTP.new($app_host)      
      http_connection.read_timeout = $app_timeout
      return http_connection
  end
end

def Rest_service.get_request(method, url, user=$app_user, password=$app_pass)
    request = nil   
    url = $app_root + url
    Log.info("Endpoint: " + url)
    case method
      when "POST"
        Log.info("Method Request: " + method)
        request = Net::HTTP::Post.new(url)
      when "PUT"
        Log.info("Method Request: " + method)
        request = Net::HTTP::Put.new(url)
      when "DELETE"
        Log.info("Method Request: " + method)
        request = Net::HTTP::Delete.new(url)
      when "GET"
        Log.info("Method Request: " + method)
        request = Net::HTTP::Get.new(url)
    end
    request.basic_auth(user,password)  
    return request
  end
  
def Rest_service.get_no_auth(method, url)
    request = nil   
    url = $app_root + url
    Log.info("Endpoint: " + url)
    case method
      when "POST"
        Log.info("Method Request: " + method)
        request = Net::HTTP::Post.new(url)
      when "PUT"
        Log.info("Method Request: " + method)
        request = Net::HTTP::Put.new(url)
      when "DELETE"
        Log.info("Method Request: " + method)
        request = Net::HTTP::Delete.new(url)
      when "GET"
        Log.info("Method Request: " + method)
        request = Net::HTTP::Get.new(url)
    end
    return request
  end

def Rest_service.execute_request(http_connection, http_request)
  http_response = http_connection.request(http_request)
  Log.info("Status code response: " + http_response.code)
  Log.info("Response body: " + http_response.body)
  return http_response
end
