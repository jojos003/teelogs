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

def actions(ary, name)
    ary.select{|l| l[0] == name.to_s}.flatten!.select!{|l| l != name.to_s}
end

def parse_values(str)
    values = Hash.new
    keys = str.scan(/\w+=/)
    keys.each do |key|
        i = str.index(key) + key.length
        ni = i
        if(str[i] =~ /'|"/)
            ni = str.index(/'|"/, i+1)
        elsif(i+1 < str.length)
            ni = str.index(/ /, i+1)
        end
        values[key.chop] = str.slice(i, ni)
    end
    values
end

logs = parse_logs(open(*ARGV))

kills = actions(logs, :kill)

results = Hash.new

kills.each do |kill|
    pp parse_values(kill)
end

