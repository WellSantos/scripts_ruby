require 'net/ssh'

response_log = "/opt/logs/globosatplay/nginx-fe/nginx-fe_response.log"
access_log = "/opt/logs/globosatplay/nginx-fe/nginx-fe_access.log"
host = "globosatplay-qa-fe-01"

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
