class Teelogs
    
    def initialize(io)
        @logs = parse_logs(io)
    end

    def results
        @results = parse_results(actions(@logs, :kill)) unless @results
        @results
    end
    
    def scores
        @scores = parse_scores(results) unless @scores
        @scores
    end
    
    private

    def parse_logs(io)
        actions = Array.new
        io.each_line do |line|
            action = scan_game_line(line)
            actions << action
        end
        actions.compact!
        actions
    end

    def scan_game_line(line)
        match = line.match(/\[\w+\]\[(\w+)\]: (\w+) (.*)/)
        return nil unless match && match[1] == "game"
        
        match.to_a.drop(2)
    end
    
    def line_of_type?(type, line)
        match = line.match(/\A\[\w+\]\[(\w+)\]/)
        true if match && match[1].to_sym == type.to_sym
    end

    def actions(ary, name)
        ary.select{|l| l[0] == name.to_s}.flatten!.select!{|l| l != name.to_s}
    end

    def parse_values(str)
        values = Hash.new
        keys = str.scan(/\w+=/)
        keys.each do |key|
            i = str.index(key) + key.length
            ni = i+1
            if(str[i] =~ /['"]/)
                i = i+1
                ni = str.index(/['"]/, ni)
            elsif(ni < str.length)
                ni = str.index(/ /, ni)
            end
            values[key.chop] = str[i...ni]
        end
        values
    end

    def clean_name(str)
        str.sub(/\A\d+:/, '')
    end

    def parse_results(kills)
        results = Hash.new

        kills.each do |kill|
            values = parse_values(kill)
            killer = clean_name(values["killer"])
            victim = clean_name(values['victim'])
            
            results[killer] = Hash.new unless results[killer]
            results[killer][victim] = unless results[killer][victim]
                1
            else
                results[killer][victim] + 1
            end
        end
        results
    end

    def parse_scores(results)
        scores = Array.new
        results.each do |key, value|
            kill = 0
            suicide = 0
            victim = 0
            value.each do |k, v| 
                if key == k
                    suicide = suicide + v
                else
                    kill = kill + v
                end
            end
            
            results.each do |k, v|
                next if key == k
                v.each {|k2,v2| victim = victim + v2 if key == k2 }
            end
            
            s = {kill: kill, 
              suicide: suicide, 
               victim: victim, 
                ratio: (kill - suicide - victim)
            }
            scores << {key => s}
        end
        scores
    end
    
end







