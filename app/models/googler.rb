class Googler     
	
	attr_accessor :token, :client

  attr_reader :service, :fetcher


  def initialize(options)
    @token = options[:token]
    create_client(options[:service])
  end

  def create_client(service)
    @client = Google::APIClient.new
    client.authorization.access_token = token
    instantiate_service(service)
  end

  def instantiate_service(service)
    @service = client.discovered_api(service, 'v3') 
  end

  
  def get_method_hash(method_string)
    method_match = method_string.match(/([a-z]+)[_]([a-z]+)[_]*(.*)/)
    model = method_match[2]
    unless method_match[3].empty?
      method = "#{method_match[1]}_#{method_match[3]}"
    else
      method = method_match[1]
    end
    { :model => model, :method => method }
  end
  
  def build_api_method(model, method)
    api_method = service.send(model).send(method)
  end
	
  def build_execution_hash(method_string, params)

    method_hash = get_method_hash(method_string)
    api_method = build_api_method(method_hash[:model], method_hash[:method])
    params = parse_params(params)
    execution_hash = { 
      :api_method => api_method, 
      :parameters => params[:params], 
      :headers => {'Content-Type' => 'application/json'}  
    }
    execution_hash.merge!(:body_object => params[:body_object]) if params[:body_object]
    #puts execution_hash
    execution_hash
  end

  def parse_params(params)
    parsed_params = {}
    parsed_params[:params] = params.reject {|key, value| key == :body_object }
    parsed_params[:body_object] = params[:body_object]
    parsed_params
  end

  def method_missing(method, *args)
    return super unless args and method.to_s.include?('_')
    execution_hash = build_execution_hash(method.to_s, args.first)
    #binding.pry
    result = client.execute(execution_hash)
  end


  # def make_post(params)
  #   { :api_method => @service.posts.insert :parameters => params, :headers => {'Content-Type' => 'application/json'}  }
  # end




  
  

end