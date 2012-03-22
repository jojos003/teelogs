require 'pp'


def line_of_type?(type, line)
    match = line.match(/\A\[\w+\]\[(\w+)\]/)
    true if match && match[1].to_sym == type.to_sym
end

def scan_game_line(line)
    match = line.match(/\[\w+\]\[(\w+)\]: (\w+) (.*)/)
    return nil unless match && match[1] == "game"
    
    match.to_a.drop(2)
end

def parse_logs(io)
    actions = Array.new
    io.each_line do |line|
        action = scan_game_line(line)
        actions << action if action
    end
    actions
end

def parse_values(str)
    
end

logs = parse_logs(open(*ARGV))

kills = logs.select{|l| l[0] == 'kill'}.flatten!.select!{|l| l != 'kill'}

results = Hash.new

kills.each do |kill|
    
end

