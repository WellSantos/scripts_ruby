require 'net/ssh'

response_log = "/path/to/response_file.log"
access_log = "/path/to/access_file.log"
host = "host"

def do_tail(session,file)
  session.open_channel do |channel|
    channel.on_data do |ch,data|
      puts "[#{file}] -> #{data}"
    end
    channel.exec "tail -f #{file}"
  end
end

Net::SSH.start (host) do |session|
  do_tail session, response_log
  do_tail session, access_log
  session.loop
end
