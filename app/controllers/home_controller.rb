class HomeController < ApplicationController
  include ActionController::Live

  def index
  end

  def live
    begin
      response.headers['Content-Type'] = 'text/event-stream'
      response.headers['Last-Modified'] = Time.now.httpdate # this is needed to disabled ETag middleware, which disables SSE
      sse = SSE.new(response.stream, retry: 300, event: "event-name") # default params
      loop do
        sse.write({time: Time.now.to_s}, id: 10, event: "message", retry: 500)
        sleep 2
      end
    rescue ClientDisconnected
    ensure
      sse.close
    end
  end
end