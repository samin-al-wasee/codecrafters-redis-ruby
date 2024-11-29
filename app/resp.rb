module RESP
  DATA_TYPES = {
    "+" => :simple_string,
    "-" => :error,
    ":" => :integer,
    "$" => :bulk_string,
    "*" => :array,
  }

  COMMAND_HANDLERS = {
    "PING" => ->(client) { client.puts("+PONG\r\n") },
    "INVALID" => ->(client) { client.puts("-ERR unknown data type\r\n") },
  }

  INVALID_COMMAND_HANDLER = COMMAND_HANDLERS["INVALID"]
end
