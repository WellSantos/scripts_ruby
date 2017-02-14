#!/usr/bin/env ruby

require 'net/ssh'

print "Qual o servidor/host que vc quer capturar os logs? "
host = gets.chomp
host.downcase!

print "Qual tecnologia? (N)ginx ou (U)nicorn? "
tech = gets.chomp
tech.upcase!
project = host.split('-')[0]
layer = host.split('-')[2]


if tech == "N"
  tech = "nginx"
elsif tech == "U" && layer == "fe"
  puts "FE não tem Unicorn"
elsif tech == "U"
  tech = "unicorn"
else
  puts "Não conheço essa tecnologia. Tente novamente!"
end

response_log = "/opt/logs/#{project}/#{tech}-#{layer}/nginx-fe_response.log"
access_log = "/opt/logs/#{project}/#{tech}-#{layer}/#{tech}-#{layer}_access.log"


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
