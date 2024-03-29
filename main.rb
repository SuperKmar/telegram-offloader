@self = nil

def tg_request(socket)
	msg = yield
	puts "$ #{msg}"
	socket.puts msg 
	res = []
  while msg && !msg.empty?
  	puts msg = socket.gets.chomp 
  	res << msg
  end
  res
end

def get_id(socket, num)
  puts "history #{@self} #{num} 0"
  socket.puts "history #{@self} #{num} 0"
  msg = ''
  msg_ids = []
  while msg_ids.size < num do 
    puts msg = socket.gets
    split_msg = msg.split(' ')

    if !split_msg.nil? && split_msg.include?(@self) && split_msg[0].to_i.to_s == split_msg[0]
      msg_id = split_msg.first
      msg_ids << msg_id
    end
  end

  puts msg = socket.gets.chomp while !msg.empty?
  puts "got ids: #{msg_ids.inspect}"
  msg_ids
end

def load_document(socket, msg_id)
  tg_request(socket) { "load_document #{msg_id}"}
end

def delete_msg(socket, msg_id)
  tg_request(socket) { "delete_msg #{msg_id}"}
end

def save_next(socket, num)
  msg_ids = get_id(socket, num || 1)
  msg_ids.each do |msg_id|
    result = load_document(socket, msg_id)
    if result.any? { |line| line.include? 'Saved to' }
      delete_msg(socket, msg_id) 
    else
      puts "failed to save #{msg_id}"
    end
  end
end

def set_self(socket)
  res = tg_request(socket) { 'get_self' }
  res.each do |line|
    if line.index('User')
      @self = line.split(' ')[1]
      puts "Set current user to #{@self}"
      break
    end
  end
end

require 'socket'

UNIXSocket.open("/tmp/tg1") do |socket|

  set_self(socket)

  puts 'Enter the amount of messages to offload'

  while (num = gets.chomp; !num.nil? && num.to_i > 0) do
    save_next(socket, num.to_i)
    puts 'ready for next command'
  end

ensure
  socket.close
end