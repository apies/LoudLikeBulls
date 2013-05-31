module GooglerTestingService

	def include_test_client
		alias_method :_create_client, :create_client
		define_method( 'create_client',
			->(service) do
				@client = Google::APIClient.new
			    key = Google::APIClient::PKCS12.load_key('./certs/3e2a044de811dc2bec5e1f728eec5dfd40809fbc-privatekey.p12', 'notasecret')
			    service_account = Google::APIClient::JWTAsserter.new(
			      '342909415861-58lunvc3h6b64b211i17rb0vi95gj5gp@developer.gserviceaccount.com',
			      'https://www.googleapis.com/auth/blogger',
			      key
			    )
			    client.authorization = service_account.authorize
			    @service = client.discovered_api(service, 'v3')
			end
		)	
	end

end


