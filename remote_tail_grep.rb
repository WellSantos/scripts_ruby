#!/usr/bin/env ruby

require 'net/ssh'

print "Qual o servidor/host que vc quer capturar os logs? "
host = gets.chomp

print "Qual tecnologia? (N)ginx ou (U)nicorn? "
tech = gets.chomp
tech.upcase!

if tech == "N"
  tech = "nginx"
elsif tech == "U"
  puts "FE não tem Unicorn"
else
  puts "Não conheço essa tecnologia. Tente novamente!"
end

project = host.split('-').first

response_log = "/opt/logs/#{project}/#{tech}-fe/nginx-fe_response.log"
access_log = "/opt/logs/#{project}/#{tech}-fe/nginx-fe_access.log"



def do_tail(session,file)
  session.open_channel do |channel|
    channel.on_data do |ch,data|
      puts "[#{file}] ->
	 #{data}"
    end
    channel.exec "tail -f #{file}"
  end
end

Net::SSH.start (host) do |session|
  do_tail session, response_log
  do_tail session, access_log
  session.loop
end
