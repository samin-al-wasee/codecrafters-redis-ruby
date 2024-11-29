require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    # You can use print statements as follows for debugging, they'll be visible when running tests.
    puts("Logs from your program will appear here!")

    server = TCPServer.new(@port)

    loop do
      client = server.accept

      loop do
        command = client.gets
        puts command
        break if command.nil?

        response = "+PONG\r\n"
        client.puts(response)
      end

      client.close
    end
  end
end

YourRedisServer.new(6379).start
