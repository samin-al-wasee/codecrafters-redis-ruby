require "socket"
require_relative "resp"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    # You can use print statements as follows for debugging, they'll be visible when running tests.
    puts("Logs from your program will appear here!")

    server = TCPServer.new(@port)
    puts("Server started on port #{@port}")

    loop do
      client = server.accept
      puts("New client connected")

      handle(client)
    end
  end

  private

  def handle(client)
    loop do
      command_s = parse_command(client)
      puts("Command: #{command_s}")

      next if command_s.nil?

      if command_s.class == Array
        puts("Command_Array: #{command_s}")
        command_s.each do |command|
          handler = RESP::COMMAND_HANDLERS.fetch(command, RESP::INVALID_COMMAND_HANDLER)
          handler.call(client)
        end
      else
        puts("Command_Single: #{command_s}")
        handler = RESP::COMMAND_HANDLERS.fetch(command_s, RESP::INVALID_COMMAND_HANDLER)
        handler.call(client)
      end
    end

    client.close
    puts("Client disconnected")
  end

  def parse_command(client)
    data_type_info = client.gets
    puts("Data Type Info: #{data_type_info}")
    data_type_symbol = data_type_info[0]
    puts("Data Type Symbol: #{data_type_symbol}")
    data_type = RESP::DATA_TYPES[data_type_symbol]
    puts("Data Type: #{data_type}")

    case data_type
    when :simple_string || :error
      data_type_info[1..-1]
    when :integer
      data_type_info[1..-1].to_i
    when :bulk_string
      length = data_type_info[1..-1].to_i
      client.read(length)
    when :array
      length = data_type_info[1..-1].to_i
      length.times.map { parse_command(client) }
    else
      nil
    end
  end
end

YourRedisServer.new(6379).start
