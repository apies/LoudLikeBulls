# class Googler
   class Fetcher
    attr_reader :records, :remainder, :request_count, :next_page_token

    def initialize(desired_records_count)
      @request_count = desired_records_count / 20
      @remainder = desired_records_count % 20
      @records = []
      @next_page_token = ''
    end

    def fetch_records(blog_id, &block)
      until @request_count == 0
        new_query_result = block.call(blog_id, @next_page_token).data
        @records += new_query_result['items']
        @next_page_token = new_query_result['nextPageToken']
        @request_count -= 1
      end
      @records += block.call(blog_id, @next_page_token).data['items'][0...@remainder] unless @remainder == 0
      @records
    end
  end
#end